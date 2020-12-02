using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace CommandBuff {
    public class MoveObject : MonoBehaviour {
        private int _counter;
        private int _rotate = 1;
        void Update() {
            _counter++;
            transform.Translate(_rotate * Vector3.right * Time.deltaTime);
            if (_counter >= 100) {
                _counter = 0;
                _rotate *= -1;
            }
        }
    }
}