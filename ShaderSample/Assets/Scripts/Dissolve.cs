using UnityEngine;

public class Dissolve : MonoBehaviour {
	private float _threshold;

	void Update() {
		_threshold += 0.01f;
		var renderer = GetComponent<Renderer>();
		_threshold = Mathf.Clamp(_threshold, 0, 3);
		renderer.material.SetFloat("_Threshold", _threshold);
	}
}