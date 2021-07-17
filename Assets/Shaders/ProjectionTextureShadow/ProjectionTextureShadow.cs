using UnityEngine;

[RequireComponent(typeof(Camera))]
public class ProjectionTextureShadow : MonoBehaviour
{
    [Header ("Setting")]
    [SerializeField]
    private Camera _camera;
    [SerializeField]
    private int _renderTextureSize = 512;
    [SerializeField]
    private Material _material;
    [SerializeField]
    private Transform _lightTransform;

    private int _matrixVpId;
    private int _textureId;
    private int _posId;
    private RenderTexture _renderTexture;

    private void Start()
    {
        SetPropertyId();
        CameraSettings();
    }

    /// <summary>
    /// PropertyIdの設定
    /// </summary>
    private void SetPropertyId()
    {
        _matrixVpId = Shader.PropertyToID("_ShadowProjectorMatrixVP1");
        _textureId = Shader.PropertyToID("_ShadowProjectorTexture1");
        _posId = Shader.PropertyToID("_ShadowProjectorPos1");
    }

    /// <summary>
    /// カメラの設定
    /// </summary>
    private void CameraSettings()
    {
        // 先にレンダリングさせるために、小さい値に
        _camera.depth = -10000;
        _camera.clearFlags = CameraClearFlags.Color;
        _camera.backgroundColor = Color.white;
        // 点滅を防ぐ
        _camera.allowHDR = false;
    }

    /// <summary>
    /// カメラがシーンのレンダリングを開始する前に呼ばれる
    /// </summary>
    private void OnPreRender()
    {
        if (_renderTexture == null)
        {
            UpdateSettings();
        }
        SetMaterialParam();
    }

    /// <summary>
    /// 設定の更新
    /// </summary>
    private void UpdateSettings()
    {
        ReleaseTexture();
        SetLightPosition();
        UpdateRenderTexture();
    }

    /// <summary>
    /// テクスチャの解放
    /// </summary>
    private void ReleaseTexture()
    {
        if (_renderTexture == null)
        {
            return;
        }
        _material.SetTexture(_textureId, null);
        RenderTexture.ReleaseTemporary(_renderTexture);
        _renderTexture = null;
        _camera.targetTexture = null;
    }

    /// <summary>
    /// 位置の設定
    /// </summary>
    private void SetLightPosition()
    {
        var objTransform = transform;
        _lightTransform.position = objTransform.position;
        _lightTransform.rotation = objTransform.rotation;
    }

    /// <summary>
    /// RenderTextureの更新
    /// </summary>
    private void UpdateRenderTexture()
    {
        _renderTexture = RenderTexture.GetTemporary(_renderTextureSize, _renderTextureSize, 16, RenderTextureFormat.ARGB32);
        _camera.targetTexture = _renderTexture;
    }

    /// <summary>
    /// マテリアルのパラメータ設定
    /// </summary>
    private void SetMaterialParam()
    {
        var viewMatrix = _camera.worldToCameraMatrix;
        var projectionMatrix = GL.GetGPUProjectionMatrix(_camera.projectionMatrix, true);
        _material.SetMatrix(_matrixVpId, projectionMatrix * viewMatrix);
        _material.SetTexture(_textureId, _renderTexture);
        _material.SetVector(_posId, GetProjectorPos());
    }

    /// <summary>
    /// プロジェクターの座標取得
    /// </summary>
    /// <returns></returns>
    private Vector4 GetProjectorPos()
    {
        Vector4 projectorPos;
        // Orthographic
        // _ObjectSpaceLightPosを参考に、wに0が入っていたらOrthographicの前方方向とみなす
        if (_camera.orthographic)
        {
            projectorPos = transform.forward;
            projectorPos.w = 0;
        }
        // Perspective
        else
        {
            projectorPos = transform.position;
            projectorPos.w = 1;
        }
        return projectorPos;
    }

    private void OnDestroy()
    {
        ReleaseTexture();
    }
}
