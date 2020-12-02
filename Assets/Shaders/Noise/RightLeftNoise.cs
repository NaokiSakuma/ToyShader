using UnityEngine;

namespace CameraNoise {
    public class RightLeftNoise : MonoBehaviour {
        [SerializeField]
        private Shader _shader;

        // 横にズレる値
        [SerializeField, Range(0, 1)]
        private float _horizonValue;
        private Material _material;

        void Awake() {
            Initialize();
        }

        /// <summary>
        /// 全てのレンダリングがRenderImageへと完了したとき
        /// </summary>
        /// <param name="src">コピー元</param>
        /// <param name="dest">コピー先</param>
        void OnRenderImage(RenderTexture src, RenderTexture dest) {
            // マテリアルが存在していない場合、生成する
            if (_material == null) {
                Initialize();
            }
            // フレームカウントでシード値の設定
            _material.SetInt("_Seed", Time.frameCount);
            _material.SetFloat("_HorizonValue", _horizonValue);
            // 描画
            Graphics.Blit(src, dest, _material);
        }

        /// <summary>
        /// 初期化
        /// </summary>
        private void Initialize() {
            // マテリアルの生成
            _material = new Material(_shader);
            _material.hideFlags = HideFlags.DontSave;
        }
    }
}