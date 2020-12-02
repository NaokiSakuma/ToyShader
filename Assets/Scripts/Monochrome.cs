using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Monochrome : MonoBehaviour {
	[SerializeField]
    private Shader _shader;
	[SerializeField]
    private Material _material;

	void Start() {
		if(_material == null)
			_material = new Material(_shader);
	}
	void OnRenderImage(RenderTexture source, RenderTexture dest) {
		Graphics.Blit(source, dest, _material);
	}
}
