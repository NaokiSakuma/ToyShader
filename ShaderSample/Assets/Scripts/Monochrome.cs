using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Monochrome : MonoBehaviour {
	[SerializeField]
    private Shader _shader;
<<<<<<< HEAD
	[SerializeField]
    private Material _material;

	void Start() {
		if(_material == null)
			_material = new Material(_shader);
=======
    private Material _material;

	void Start() {
		_material = new Material(_shader);
>>>>>>> 1f3912dfbbb6ad6eb0dbc49c6f22cb064233ad12
	}
	void OnRenderImage(RenderTexture source, RenderTexture dest) {
		Graphics.Blit(source, dest, _material);
	}
}
