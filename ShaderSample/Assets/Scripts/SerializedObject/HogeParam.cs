using UnityEngine;

namespace SerializedObject {
    public class HogeParam : MonoBehaviour {
        [SerializeField]
        private int _hp;
        void Awake() {
            Debug.Log("HogeParam _hp : " + _hp);
        }
    }
}
