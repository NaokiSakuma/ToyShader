using UnityEngine;

public class Liquid : MonoBehaviour {
    [SerializeField]
    private Material _material;
    private int _propertyId;
    void Start() {
        _propertyId = Shader.PropertyToID("_TransformPositionY");
    }

    void Update() {
        _material.SetFloat(_propertyId, transform.localPosition.y);
        // 上下させることも可能
        // transform.localPosition = new Vector3(transform.position.x, (Mathf.Sin((Time.time)) * 2), transform.position.z);
    }
}
