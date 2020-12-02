using System.Collections;
using System.Collections.Generic;
using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;

namespace SerializedObject {
    // 任意のエディタをする属性
    // UnityEditor.Editorを継承する必要があるので注意
    [CustomEditor(typeof(HogeParam))]
    public class SerializedObjectTest : Editor {
        /// <summary>
        /// inspectorのuGUIを制御する
        /// </summary>
        public override void OnInspectorGUI() {
            // 内部のキャッシュから最新のデータを取得する
            serializedObject.Update();
            // プロパティを取得する
            SerializedProperty hpProperty = serializedObject.FindProperty("_hp");
            // 取得したプロパティをinspectorから編集できるようにする
            EditorGUILayout.PropertyField(hpProperty);
            // 内部キャッシュに変更した値を適応させる
            serializedObject.ApplyModifiedProperties();
        }
    }
}
#endif