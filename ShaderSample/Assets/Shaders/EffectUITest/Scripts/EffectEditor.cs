// using System.Collections;
// using System.Collections.Generic;
// using UnityEngine;
// using UnityEditor;

// namespace uGUIEffect {
//     public class EffectEditor : Editor {

//         SerializedProperty _spEffectMode;
//         SerializedProperty _spEffectFactor;

//         void OnEnable() {
//             _spEffectMode = serializedObject.FindProperty("_effectMode");
//             _spEffectFactor = serializedObject.FindProperty("_effectFactor");
//         }

//         public override void OnInspectorGUI() {
//             using(new MaterialDirtyScope(targets)) {
//                 // EditorGUI
//             }
//         }
//     }
// }

// inspectorのレイアウトの変更なので、後回しでおｋ