using System.Collections;
using UnityEngine;

public class ChangeColor : MonoBehaviour{
    void Start(){
        // shaderで定義した、_BaseColor変数の色を変更する
        GetComponent<Renderer>().material.SetColor("_BaseColor",Color.yellow);
    }
}
