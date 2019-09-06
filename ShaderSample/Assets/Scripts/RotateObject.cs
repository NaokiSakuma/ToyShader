using UnityEngine;

public class RotateObject : MonoBehaviour {
	void Update () {
		transform.Rotate(new Vector3(0,0,90.0f) * Time.deltaTime);
	}
}