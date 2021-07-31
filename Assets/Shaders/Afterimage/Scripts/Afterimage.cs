using UnityEngine;

public class Afterimage : MonoBehaviour
{
    [SerializeField]
    private Material _material;
    [SerializeField]
    private float _trailSpeed = 10f;
    
    private Vector3 _trailPos;
    private int _dirId;

    private void Awake()
    {
        _trailPos = transform.position;
        _dirId = Shader.PropertyToID("_TrailDir");
    }

    private void Update()
    {
        Trail();
        Rotate();
    }

    /// <summary>
    ///  原点を中心に回転させる
    /// </summary>
    private void Rotate()
    {
        var tr = transform;
        var angleAxis = Quaternion.AngleAxis(180 * Time.deltaTime, Vector3.forward);
        var pos = tr.position;
        tr.position = angleAxis * pos;
    }

    /// <summary>
    /// 軌跡
    /// </summary>
    private void Trail()
    {
        var time = Mathf.Clamp01(Time.deltaTime * _trailSpeed);
        var tr = transform.position;
        _trailPos = Vector3.Lerp(_trailPos, tr, time);
        _material.SetVector(_dirId, transform.InverseTransformDirection(_trailPos - tr));
    }
}
