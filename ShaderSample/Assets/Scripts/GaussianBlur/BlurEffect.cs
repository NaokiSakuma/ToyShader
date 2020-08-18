using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class BlurEffect : MonoBehaviour {
    [SerializeField]
    private Shader _shader;

    [SerializeField, Range(1f, 100f)]
    private float _offset = 1f;

    [SerializeField, Range(10f, 1000f)]
    private float _blur = 100f;

    [SerializeField, Range(0f, 1f)]
    private float _intencity = 0;

    [SerializeField]
    private CameraEvent _cameraEvent = CameraEvent.AfterImageEffects;

    private Material _material;

    private Dictionary<Camera, CommandBuffer> _cameras = new Dictionary<Camera, CommandBuffer>();

    private float[] _weights = new float[10];

    private int _copyTexID = 0;
    private int _blurredID1 = 0;
    private int _blurredID2 = 0;
    private int _weightsID = 0;
    private int _intencityID = 0;
    private int _offsetsID = 0;
    private int _grabBlurTextureID = 0;

    /// <summary>
    /// 初期化
    /// </summary>
    private void Awake() {
        // OnWillRenderObjectで呼ばれるためにRendererをつける
        MeshFilter filter = gameObject.AddComponent<MeshFilter>();
        filter.hideFlags = HideFlags.DontSave;
        MeshRenderer renderer = gameObject.AddComponent<MeshRenderer>();
        renderer.hideFlags = HideFlags.DontSave;

        // propertyID制作
        _copyTexID = Shader.PropertyToID("_ScreenCopyTexture");
        _blurredID1 = Shader.PropertyToID("_Temp1");
        _blurredID2 = Shader.PropertyToID("_Temp2");
        _weightsID = Shader.PropertyToID("_Weights");
        _intencityID = Shader.PropertyToID("_Intencity");
        _offsetsID = Shader.PropertyToID("_Offset");
        _grabBlurTextureID = Shader.PropertyToID("_GrabBlurTexture");

        // mainカメラの子にすることで、mainカメラが消えたときに対応できるように
        Transform parent = Camera.main.transform;
        transform.SetParent(parent);
        transform.localPosition = Vector3.forward;

        // 重みの計算
        UpdateWeights();
    }

    /// <summary>
    /// 更新
    /// </summary>
    private void Update() {
        foreach (var kv in _cameras) {
            // CommandBufferの更新
            kv.Value.Clear();
            BuildCommandBuffer(kv.Value);
        }
    }

    /// <summary>
    /// アクティブ時
    /// </summary>
    private void OnEnable() {
        Cleanup();
    }

    /// <summary>
    /// 非アクティブ時
    /// </summary>
    private void OnDisable() {
        Cleanup();
    }

    /// <summary>
    /// Rendererがカメラに映っているときにカメラ毎に呼ばれる
    /// </summary>
    public void OnWillRenderObject() {
        // 自身が非アクティブならreturn
        if (!gameObject.activeInHierarchy || !enabled) {
            Cleanup();
            return;
        }

        // マテリアルの初期化
        if (_material == null) {
            _material = new Material(_shader);
            _material.hideFlags = HideFlags.HideAndDontSave;
        }

        // 現在のカメラを取得
        Camera cam = Camera.current;
        if (cam == null) {
            return;
        }

#if UNITY_EDITOR
        // カメラがシーンビューのものだった場合return
        if (cam == UnityEditor.SceneView.lastActiveSceneView.camera) {
            return;
        }
#endif

        // すでに処理済ならreturn
        if (_cameras.ContainsKey(cam)) {
            return;
        }

        // CommandBufferの生成
        CommandBuffer buf = new CommandBuffer();
        _cameras[cam] = buf;
        BuildCommandBuffer(buf);
        cam.AddCommandBuffer(_cameraEvent, buf);
    }

    /// <summary>
    /// CommandBufferの設定
    /// </summary>
    /// <param name="buf">CommandBuffer</param>
    private void BuildCommandBuffer(CommandBuffer buf) {
        // 現在のレンダリング結果をカメラと同じ解像度でRenderTextureにコピー
        buf.GetTemporaryRT(_copyTexID, -1, -1, 0, FilterMode.Bilinear);
        buf.Blit(BuiltinRenderTextureType.CurrentActive, _copyTexID);

        // カメラの半分の解像度で縦横の2枚のRenderTexture生成
        buf.GetTemporaryRT(_blurredID1, -2, -2, 0, FilterMode.Bilinear);
        buf.GetTemporaryRT(_blurredID2, -2, -2, 0, FilterMode.Bilinear);

        // 半分の解像度にする
        buf.Blit(_copyTexID, _blurredID1);

        // カメラと同じ解像度のものは不要なので破棄
        buf.ReleaseTemporaryRT(_copyTexID);

        // 縦横のオフセット
        float x = _offset / Screen.width;
        float y = _offset / Screen.height;
        buf.SetGlobalFloatArray(_weightsID, _weights);
        buf.SetGlobalFloat(_intencityID, _intencity);

        // 横方向ブラー
        buf.SetGlobalVector(_offsetsID, new Vector4(x, 0, 0, 0));
        buf.Blit(_blurredID1, _blurredID2, _material);

        // 縦方向ブラー
        buf.SetGlobalVector(_offsetsID, new Vector4(0, y, 0, 0));
        buf.Blit(_blurredID2, _blurredID1, _material);

        // 縦横ブラーをかけたテクスチャをシェーダーに適応
        buf.SetGlobalTexture(_grabBlurTextureID, _blurredID1);
    }

    /// <summary>
    /// 設定の削除
    /// </summary>
    private void Cleanup() {
        foreach (var cam in _cameras) {
            if (cam.Key != null) {
                cam.Key.RemoveCommandBuffer(_cameraEvent, cam.Value);
            }
        }
        _cameras.Clear();
        Object.DestroyImmediate(_material);
    }

    /// <summary>
    /// 重みの計算
    /// </summary>
    private void UpdateWeights() {
        float total = 0;
        float d = _blur * _blur * 0.001f;

        for (int i = 0; i < _weights.Length; i++) {
            float r = 1.0f + 2.0f * i;
            float w = Mathf.Exp(-0.5f * (r * r) / d);
            _weights[i] = w;
            // xとyがあるので2倍
            if (i > 0) {
                w *= 2.0f;
            }
            total += w;
        }

        // 正規化
        for (int i = 0; i < _weights.Length; i++) {
            _weights[i] /= total;
        }
    }
}
