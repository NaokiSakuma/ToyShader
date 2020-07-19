using UnityEngine;
using UnityEngine.Rendering;

public class PostEffectCommandBuffer : MonoBehaviour {
    [SerializeField]
    private Shader _shader;

    void Awake() {
        Initialize();
    }

    private void Initialize() {
        Camera camera = this.GetComponent<Camera>();
        Material material = new Material(_shader);
        // CommandBuffer生成
        CommandBuffer commandBuffer = new CommandBuffer();
        commandBuffer.name = "commandBufferTest";
        int tempTextureIdentifier = Shader.PropertyToID("_PostEffectTemp");
        // RenderTextureをカメラの解像度で取得
        commandBuffer.GetTemporaryRT(tempTextureIdentifier, -1, -1);
        // PostEffectを反映
        // RenderTextureに描画
        commandBuffer.Blit(BuiltinRenderTextureType.CameraTarget, tempTextureIdentifier);
        // RenderTargetにmaterialの結果を反映させて描画
        commandBuffer.Blit(tempTextureIdentifier, BuiltinRenderTextureType.CameraTarget, material);
        // RenderTextureの解放
        commandBuffer.ReleaseTemporaryRT(tempTextureIdentifier);
        // ImageEffects前にCommnadBufferを追加
        camera.AddCommandBuffer(CameraEvent.BeforeImageEffects, commandBuffer);
    }
}