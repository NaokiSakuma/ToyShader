using UnityEngine;

[ExecuteInEditMode, RequireComponent(typeof(Renderer))]

public class PostEffect : MonoBehaviour {
    [SerializeField]
    private Shader _shader;
    private Material _material;

    void Start()
    {
        GetComponent<Camera>().depthTextureMode |= DepthTextureMode.Depth;
        _material = new Material(_shader);
    }

    void OnRenderImage(RenderTexture source, RenderTexture dest)
    {
        Graphics.Blit(source, dest, _material);
    }
}