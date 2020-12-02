using UnityEngine;

public class LODTest : MonoBehaviour {

	// 色を変更させるオブジェクトのレンダラー
	[SerializeField]
	private Renderer objRenderer;

	// カメラの位置
	[SerializeField]
	private Transform _cameraTransform;

	void Update() {
		// シェーダにLOD値を代入
		objRenderer.sharedMaterial.shader.maximumLOD = (int) Mathf.Abs(_cameraTransform.localPosition.z);
	}
}