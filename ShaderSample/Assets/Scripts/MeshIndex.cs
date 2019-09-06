using UnityEngine;
using UnityEditor;


[RequireComponent(typeof (MeshFilter))]
[RequireComponent(typeof (MeshRenderer))]
public class MeshIndex : MonoBehaviour {

	void Start () {
		Mesh mesh = GetComponent<MeshFilter>().mesh;
		for(int i = 0; i < mesh.uv.Length; i++) {
			Debug.Log("vertices : " + i + ": " + mesh.uv[i]);
		}

		// var meshfilter = gameObject.GetComponent<MeshFilter>();
		// Vector2[] uv = new Vector2[4];

		// uv[0] = new Vector2(0.5f, 1.0f);
		// uv[1] = new Vector2(0.0f, 0.5f);
		// uv[2] = new Vector2(0.0f, 1.0f);
		// uv[3] = new Vector2(0.5f, 0.5f);

		// meshfilter.mesh.uv = uv;


		// Cloth cloth = GetComponent<Cloth>();
		// for(int i = 0; i < cloth.vertices.Length; i++) {
		// 	Debug.Log("cloth : " + i + ": " + cloth.vertices[i]);
		// }

	}
}
