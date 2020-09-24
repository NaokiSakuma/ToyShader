using System.Collections.Generic;
using UnityEngine;
using System;

namespace SerializedObject {
    public class ListParam : MonoBehaviour {
        public List<Status> _list = new List<Status>();
    }
    [Serializable]
    public class Status {
        public string _name;
        public int _hp;
        public int _mp;

        public Status(string name, int hp, int mp) {
            _name = name;
            _hp = hp;
            _mp = mp;
        }
    }
}