using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Monochrome : MonoBehaviour {
	[SerializeField]
    private Shader _shader;
    private Material _material;

	void Start() {
		_material = new Material(_shader);
	}
	void OnRenderImage(RenderTexture source, RenderTexture dest) {
		Graphics.Blit(source, dest, _material);
	}
}
