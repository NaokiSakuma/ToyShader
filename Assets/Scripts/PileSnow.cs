using UnityEngine;

public class PileSnow : MonoBehaviour {
	private float _snow;
	void Update() {
		_snow += 0.005f;
		var renderer = GetComponent<Renderer>();
		_snow = Mathf.Clamp(_snow, 0, 3);
		renderer.material.SetFloat("_SnowPileValue", _snow);
	}
}
