using UnityEngine;

namespace SerializedObject {
    public class FugaParam : MonoBehaviour {
        [SerializeField]
        private int _hp;
        void Awake() {
            Debug.Log("FugaParam _hp : " + _hp);
        }
    }
}