using UnityEngine;
using UnityEngine.UI;

namespace onMouseMove {
    public class OnMouseMoveImage : MonoBehaviour {
        [SerializeField]
        private Image _previewImage;
        [SerializeField]
        private Shader _shader;
        // もとのテクスチャに戻る時間,1が最大
        [SerializeField]
        private float easing = 0.1f;
        // 移動量に応じた円の大きさ
        // 移動量が大きいほど円は大きくなる
        [SerializeField]
        private float maxR = 100f;
        [SerializeField]
        private bool isUseImage;
        private Texture2D _touchTex;
        private Material _material;
        private Image _image;
        private RectTransform _rectTrans;
        private Vector2 _ratio;
        private Vector2 _inverseRatio;
        private Vector2 _prevPos;

        /// <summary>
        /// 初期化
        /// </summary>
        void Start () {
            _image = GetComponent<Image>();
            _rectTrans = GetComponent<RectTransform>();
            _material = new Material(_shader);
            _previewImage.material = _material;
            // 2のべき乗でテクスチャ制作
            _touchTex = new Texture2D(128, 128);
            // テクスチャの繰り返し設定をoff
            _touchTex.wrapMode = TextureWrapMode.Clamp;
            // ワールド空間からローカル空間へマウス座標を変換
            _prevPos = _rectTrans.InverseTransformPoint(Input.mousePosition);
            // Imageに対して、制作したテクスチャの割合を取得
            _ratio = new Vector3(_touchTex.width / _rectTrans.sizeDelta.x, _touchTex.height / _rectTrans.sizeDelta.y);
            _inverseRatio = new Vector2(1f / _ratio.x, 1f / _ratio.y);;
            // xベクトルをred、yベクトルをgreenに設定する
            // 移動していない状態を0.5とする
            for (int y = 0; y < _touchTex.height; ++y) {
                Color[] colors = new Color[_touchTex.width];
                for (int i = 0; i < colors.Length; ++i) {
                    // blueは移動量として使用しないので、0にする
                    colors[i] = new Color(0.5f, 0.5f, 0f);
                }
                // x : フェッチするピクセル配列のx位置
                // y : フェッチするピクセル配列のｙ位置
                // blockWidth : フェッチするピクセル配列の幅の長さ
                // blockHeight : フェッチするピクセル配列の高さ
                // for文節約
                _touchTex.SetPixels(y, 0, 1, _touchTex.width, colors);
            }
            _touchTex.Apply ();
            if (isUseImage == false) {
                _previewImage.sprite = Sprite.Create (_touchTex, new Rect (0, 0, _touchTex.width, _touchTex.height), Vector2.zero);
                _previewImage.GetComponent<RectTransform> ().sizeDelta = _rectTrans.sizeDelta;
            }
        }

        /// <summary>
        /// 更新
        /// </summary>
        void Update () {
            CalcColor();
        }

        /// <summary>
        /// 色の計算
        /// </summary>
        private void CalcColor() {
            // 元のテクスチャに戻る時間、最大1
            float easing = 0.1f;
            // 移動量に応じた円の大きさの許容値
            float maxR = 100f;
            // ワールド空間からローカル空間へマウス座標を変換
            Vector2 localPos = _rectTrans.InverseTransformPoint(Input.mousePosition);
            // _touchTexでの位置
            Vector2 drawPos = new Vector2(Mathf.Round(localPos.x * _ratio.x), Mathf.Round(localPos.y * _ratio.y));
            // 前フレームとの移動量
            Vector2 v = localPos - _prevPos;
            float radius = v.magnitude;
            // 円の半径が許容値を超えないように
            if (radius > maxR) {
                radius = maxR;
                v = v.normalized * maxR;
            }
            float radius2 = radius * radius;
            // 各ピクセルを総舐め
            for (int x = 0; x < _touchTex.width; ++x) {
                for (int y = 0; y < _touchTex.height; ++y) {
                    // 移動時の軌跡を元に戻す
                    Color c = _touchTex.GetPixel(x, y);
                    float r = c.r;
                    float g = c.g;
                    // 移動している時
                    if (r != 0.5f && g != 0.5f) {
                        // easingの値に応じて0.5に戻す
                        r += easing * (0.5f - r);
                        g += easing * (0.5f - g);
                        // 軽微なズレを元に戻す
                        if (Mathf.Abs(r - 0.5f) < 0.05f) {
                            r = 0.5f;
                        }
                        if (Mathf.Abs(g - 0.5f) < 0.05f) {
                            g = 0.5f;
                        }
                    }
                    // 移動量に応じて軌跡を大きくする
                    // 各ピクセルのローカルでの位置
                    Vector2 pixelPos = new Vector2(x * _inverseRatio.x - _rectTrans.sizeDelta.x / 2f, y * _inverseRatio.y - _rectTrans.sizeDelta.y / 2f);
                    float distance2 = (localPos - pixelPos).sqrMagnitude;
                    // 影響範囲内か
                    if (distance2 < radius2) {
                        // 影響力を計算
                        // 円の中心の方が影響力を高くするように
                        float strength = 1 - Mathf.Sqrt(distance2) / radius;
                        r += v.x * 1f / maxR * strength;
                        g += v.y * 1f / maxR * strength;
                    }
                    // 重いので注意
                    // 隣接しているピクセルに影響を与える
                    float effect = 0.01f;
                    for (int xx = Mathf.Max(0, x - 1); xx <= Mathf.Min(_touchTex.width, x + 1); ++xx) {
                        for (int yy = Mathf.Max(0, y - 1); yy <= Mathf.Min(_touchTex.height, y + 1); ++yy) {
                            if (xx == x && yy == y) {
                                continue;
                            }
                            // 隣接しているピクセルとの距離
                            int distance = Mathf.Abs(xx - x) + Mathf.Abs(yy - y);
                            r += (_touchTex.GetPixel(xx, yy).r - 0.5f) * (distance == 1 ? effect : effect * 0.7f);
                        }
                    }
                    // 色を設定
                    _touchTex.SetPixel(x, y, new Color(Mathf.Clamp01(r), Mathf.Clamp01(g), 0f));
                }
            }
            // 色を更新
            _touchTex.Apply();
            // shaderに設定
            _image.material.SetTexture("_TouchMap", _touchTex);
            // 現在のマウス座標を前フレームの座標として保持
            _prevPos = localPos;
        }
    }
}