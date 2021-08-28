using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Metaball : MonoBehaviour
{
    [SerializeField] private Camera _metaballCamera;
    [SerializeField] private Material _quadMaterial;


    private RenderTexture _renderTexture;
}
