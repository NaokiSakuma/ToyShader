using UnityEngine;

public class MeshTopologyPoints : MonoBehaviour {
	private Material _material;
	private float _normalPow;
	void Start() {
                _material = GetComponent<Renderer>().material;
                MeshFilter meshFilter = GetComponent<MeshFilter>();
                // メッシュのインデックスをセット 各メッシュの1番目(要素番号なので0)を頂点にする
                meshFilter.mesh.SetIndices(meshFilter.mesh.GetIndices(0), MeshTopology.Points, 0);
	}
	void Update() {
		_normalPow += Time.deltaTime * 3;
		_material.SetFloat("_NormalPow", _normalPow);
	}
}