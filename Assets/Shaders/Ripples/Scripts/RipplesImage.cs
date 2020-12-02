using UnityEngine;
using UnityEngine.UI;

namespace onMouseMove {
    [RequireComponent(typeof(Image))]
    public class RipplesImage : MonoBehaviour {
        [SerializeField]
        private Shader _shader;
        [SerializeField]
        private float _speed;
        [SerializeField, Range(0, 1)]
        private float _strength;
        [SerializeField]
        private float _effectRadius;

        private Material _material;
        private Image _image;
        private RectTransform _rectTrans;
        private int _touchPosPropertyId;
        private int _speedPropertyId;
        private int _strengthPropertyId;
        private int _radiusPropertyId;
        private bool _isInitialized;

        /// <summary>
        /// 初期化
        /// </summary>
        void Start () {
            _image = GetComponent<Image>();
            _rectTrans = GetComponent<RectTransform>();
            _material = new Material(_shader);
            _image.material = _material;
            _touchPosPropertyId = Shader.PropertyToID("_TouchPos");
            _speedPropertyId = Shader.PropertyToID("_Speed");
            _strengthPropertyId = Shader.PropertyToID("_Strength");
            _radiusPropertyId = Shader.PropertyToID("_EffectRadius");
            _isInitialized = true;
            UpdateRipplesValue();
        }

        /// <summary>
        /// 更新
        /// </summary>
        void Update () {
            // ワールド空間からローカル空間へマウス座標を変換
            Vector2 localPos = _rectTrans.InverseTransformPoint(Input.mousePosition);
            // shaderに設定
            _image.material.SetVector(_touchPosPropertyId, localPos);
        }

        /// <summary>
        /// inspector操作時
        /// </summary>
        void OnValidate() {
            UpdateRipplesValue();
        }

        /// <summary>
        /// 波紋の値の更新
        /// </summary>
        private void UpdateRipplesValue() {
            if (_isInitialized == false) {
                return;
            }
            _image.material.SetFloat(_speedPropertyId, _speed);
            _image.material.SetFloat(_strengthPropertyId, _strength);
            _image.material.SetFloat(_radiusPropertyId, _effectRadius);
        }
    }
}