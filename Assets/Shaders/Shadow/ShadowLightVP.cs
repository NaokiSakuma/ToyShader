using UnityEngine;

/// <summary>
/// 不要Classの認識
/// </summary>

[ExecuteInEditMode]
public class ShadowLightVP : MonoBehaviour {
    [SerializeField]
    private Material _material;

    void Update()
    {
        _material = GetComponent<Renderer>().material;
        OnWillRenderObject();
    }

    void OnWillRenderObject() {
        var camera = Camera.main;
        // if (camera.name != "Light") {
        //     return;
        // }
        var lightVMatrix = camera.worldToCameraMatrix;
        var lightPMatrix = GL.GetGPUProjectionMatrix(camera.projectionMatrix, false);
        var lightVP = lightPMatrix * lightVMatrix;

        var biasMat = new Matrix4x4(
            new Vector4(0.5f, 0.0f, 0.0f, 0.5f),
            new Vector4(0.0f, 0.5f, 0.0f, 0.5f),
            new Vector4(0.0f, 0.0f, 0.5f, 0.5f),
            new Vector4(0.0f, 0.0f, 0.0f, 1.0f)
        );
        _material.SetMatrix("_LightVP", biasMat * lightVP);
    }
}

//     [SerializeField]
//     Material m_mat;

//     void Update()
//     {
//         OnWillRenderObject ();
//     }
//     void OnWillRenderObject () 
//     {
//         Debug.Log(Camera.current.name);
//         var cam = Camera.current;
//         // ライトにくっつけたCameraでライトから見たDepthRenderTextureに焼き込む
//         if (cam.name == "Light")
//         {
//             var lightVMatrix = cam.worldToCameraMatrix;
//             var lightPMatrix = GL.GetGPUProjectionMatrix(cam.projectionMatrix, false);
//             var lightVP = lightPMatrix * lightVMatrix;

//             // [-1, 1] => [0, 1]に補正する行列
//             var biasMat = new Matrix4x4();
//             biasMat.SetRow(0, new Vector4(0.5f, 0.0f, 0.0f, 0.5f));
//             biasMat.SetRow(1, new Vector4(0.0f, 0.5f, 0.0f, 0.5f));
//             biasMat.SetRow(2, new Vector4(0.0f, 0.0f, 0.5f, 0.5f));
//             biasMat.SetRow(3, new Vector4(0.0f, 0.0f, 0.0f, 1.0f));
//             // ライトから見た射影変換行列をシェーダい渡す
//             m_mat.SetMatrix("_LightVP", biasMat * lightVP);
//         }
//     }
// }