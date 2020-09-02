using UnityEngine;
using System.Collections.Generic;

namespace CameraNoise {
    public class FlameNoise : MonoBehaviour {
        [SerializeField]
        private Shader _shader;
        private Material _material;
        private List<RenderTexture> _textureList = new List<RenderTexture>();

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
            // 配列の用意
            int width = src.width;
            int height = src.height;
            const int FLAME_NUM = 3;
            for (int i = 0; i < FLAME_NUM; i++) {
                _textureList.Add(new RenderTexture(width, height, 0, RenderTextureFormat.RGB565));
            }

            // 1フレームずつズラしたものをコピーする
            RenderTexture tmpTexture = _textureList[Time.frameCount % FLAME_NUM];
            Graphics.Blit(src, tmpTexture);
            for (int i = 0; i < _textureList.Count; i++) {
                _material.SetTexture("_Tex" + i.ToString(), _textureList[i]);
            }
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