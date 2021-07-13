using UnityEngine;

public class TextureProjector : MonoBehaviour
{
    [SerializeField, Range(0.0001f, 180)]
    private float _fieldOfView = 60;
    [SerializeField, Range(0.2f, 5.0f)]
    private float _aspect = 1.0f;
    [SerializeField, Range(0.0001f, 1000.0f)]
    private float _nearClipPlane = 0.01f;
    [SerializeField, Range(0.0001f, 1000.0f)]
    private float _farClipPlane = 100.0f;
    [SerializeField]
    private ProjectionType projectionType;
    [SerializeField]
    private float _orthographicSize = 1.0f;
    [SerializeField]
    private Texture2D _texture;
    [SerializeField]
    private Material _material;

    private enum ProjectionType
    {
        PERSPECTIVE,
        ORTHOGRAPHIC,
    }
    
    private int _matrixVpId;
    private int _textureId;
    private int _posId;
    
    private void Awake()
    {
        SetPropertyId();
    }

    /// <summary>
    /// PropertyIdの設定
    /// </summary>
    private void SetPropertyId()
    {
        _matrixVpId = Shader.PropertyToID("_ProjectorMatrixVP");
        _textureId = Shader.PropertyToID("_ProjectorTexture");
        _posId = Shader.PropertyToID("_ProjectorPos");
    }

    private void Update()
    {
        SetMaterialParam();
    }

    /// <summary>
    /// マテリアルのパラメータ設定
    /// </summary>
    private void SetMaterialParam()
    {
        if (_texture == null)
        {
            Debug.LogError("Not Setting Material.");
            return;
        }
        var viewMatrix = Matrix4x4.Scale(new Vector3(1, 1, -1)) * transform.worldToLocalMatrix;
        var projectionMatrix = GetProjectionMatrix();
        _material.SetMatrix(_matrixVpId, projectionMatrix * viewMatrix);
        _material.SetTexture(_textureId, _texture);
        // プロジェクターの位置を渡す
        // _ObjectSpaceLightPosのような感じでwに0が入っていたらOrthographicの前方方向とみなす
        _material.SetVector(_posId, GetProjectorPos());
    }

    /// <summary>
    /// Projection行列の取得
    /// </summary>
    /// <returns></returns>
    private Matrix4x4 GetProjectionMatrix()
    {
        Matrix4x4 projectionMatrix;
        switch (projectionType)
        {
            case ProjectionType.PERSPECTIVE :
                projectionMatrix = Matrix4x4.Perspective(_fieldOfView, _aspect, _nearClipPlane, _farClipPlane);
                break;
            case ProjectionType.ORTHOGRAPHIC :
               var orthographicWidth = _orthographicSize * _aspect;
               projectionMatrix = Matrix4x4.Ortho(-orthographicWidth, orthographicWidth, -_orthographicSize, _orthographicSize, _nearClipPlane, _farClipPlane);
               break;
           default :
               Debug.LogError("Not Expected CameraType");
               return Matrix4x4.identity;
        }
        return GL.GetGPUProjectionMatrix(projectionMatrix, true);
    }

    /// <summary>
    /// プロジェクターの座標取得
    /// </summary>
    /// <returns></returns>
    private Vector4 GetProjectorPos()
    {
        Vector4 projectorPos;
        switch (projectionType)
        {
            case ProjectionType.PERSPECTIVE :
                projectorPos = transform.position;
                projectorPos.w = 1;
                break;
            case ProjectionType.ORTHOGRAPHIC :
                projectorPos = transform.forward;
                projectorPos.w = 0;
                break;
            default :
                Debug.LogError("Not Expected CameraType");
                return Vector4.zero;
        }
        return projectorPos;
    }
    
    private void OnDrawGizmos()
    {
        var gizmosMatrix = Gizmos.matrix;
        Gizmos.matrix = Matrix4x4.TRS(transform.position, transform.rotation, Vector3.one);

        switch (projectionType)
        {
            case ProjectionType.ORTHOGRAPHIC :
                var orthographicWidth = _orthographicSize * _aspect;
                var length = _farClipPlane - _nearClipPlane;
                var start = _nearClipPlane + length / 2;
                Gizmos.DrawWireCube(Vector3.forward * start, new Vector3(orthographicWidth * 2, _orthographicSize * 2, length));
                break;
            case ProjectionType.PERSPECTIVE :
                Gizmos.DrawFrustum(Vector3.zero, _fieldOfView, _farClipPlane, _nearClipPlane, _aspect);
                break;
            default :
                Debug.LogError("Not Expected CameraType");
                break;
        }

        Gizmos.matrix = gizmosMatrix;
    }
}