using UnityEngine;

public class MaterialPropertyBlockTest : MonoBehaviour {
    [SerializeField]
    private Color _color;

    void Start() {
        MeshRenderer renderer = GetComponent<MeshRenderer>();
        MaterialPropertyBlock materialPropertyBlock = new MaterialPropertyBlock();
        materialPropertyBlock.SetColor("_Color", _color);
        renderer.SetPropertyBlock(materialPropertyBlock);
    }
}
