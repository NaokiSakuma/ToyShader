using UnityEngine;

public class PostEffect : MonoBehaviour {
    [SerializeField]
    private Shader _shader;
    private Material _material;

    void Start() {
        // デプステクスチャの生成
        GetComponent<Camera>().depthTextureMode |= DepthTextureMode.Depth;
        _material = new Material(_shader);
    }

    // カメラによるレンダリング終了時に呼ばれる
    void OnRenderImage(RenderTexture source, RenderTexture dest) {
        // sourceのtextureを元に、_marerialを使用してdestに書き出し
        Graphics.Blit(source, dest, _material);
    }
}