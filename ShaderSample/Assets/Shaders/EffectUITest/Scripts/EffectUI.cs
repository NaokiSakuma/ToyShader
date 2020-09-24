using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace uGUIEffect {
    public class EffectUI : MonoBehaviour {

        // エフェクトの種類
        [SerializeField]
        private EffectMode _effectMode;
        // エフェクトの値
        [SerializeField, Range(0, 1)]
        private float _effectFactor;

        /// <summary>
        /// inspectorから値を変更した時
        /// </summary>
        void OnValidate() {

        }
    }

    // エフェクトの種類
    public enum EffectMode {
        NONE = 0,
        GRAYSCALE = 1,
    }
}