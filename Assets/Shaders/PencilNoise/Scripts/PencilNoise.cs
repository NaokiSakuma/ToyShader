using UnityEngine;

public class PencilNoise : MonoBehaviour {

    [SerializeField]
    private Material _material;

    void OnRenderImage(RenderTexture src, RenderTexture dest) {
        Graphics.Blit(src, dest, _material);
    }
}
