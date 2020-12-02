using UnityEngine;

public class PostEffects : MonoBehaviour {
	[SerializeField]
	Material _material;

	void OnRenderImage(RenderTexture source, RenderTexture dest) {
		Graphics.Blit(source, dest, _material);
	}
}
