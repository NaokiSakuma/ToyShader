using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

namespace SerializedObject {

    [CustomEditor(typeof(ListParam))]
    public class SerializedObjectListTest : Editor {
        private bool _isInitialized;
        // Listの折りたたみ用
        private bool _isFold;
        // Listの要素の折りたたみ用
        private bool[] _isFoldings;

        /// <summary>
        /// inspectorのuGUIを制御する
        /// </summary>
        public override void OnInspectorGUI() {
            ListParam param = target as ListParam;
            List<Status> statusList = param._list;

            if (_isInitialized == false) {
                // 初期化
                InitializeList(statusList.Count);
            }
            // Listの折りたたみ表示
            if (_isFold = EditorGUILayout.Foldout(_isFold, "StatusList")) {
                EditorGUI.indentLevel++;
                for (int i = 0; i < statusList.Count; i++) {
                    EditorGUI.indentLevel++;
                    // Listの要素の折りたたみ表示
                    if (_isFoldings[i] = EditorGUILayout.Foldout(_isFoldings[i], "Status" + i)) {
                        statusList[i]._name = EditorGUILayout.TextField("Name", statusList[i]._name);
                        statusList[i]._hp = EditorGUILayout.IntField("HP", statusList[i]._hp);
                        statusList[i]._mp = EditorGUILayout.IntField("MP", statusList[i]._mp);
                        EditorGUILayout.BeginHorizontal();
                        GUILayout.FlexibleSpace();
                        // ステータスの削除
                        if (GUILayout.Button("Delete")) {
                            statusList.RemoveAt(i);
                            InitializeList(i, statusList.Count);
                        }
                        EditorGUILayout.EndHorizontal();
                    }
                    EditorGUI.indentLevel--;
                }
                // 新しいステータスの追加
                if (GUILayout.Button("Add")) {
                    statusList.Add(new Status("New", 0, 0));
                    InitializeList(-1, statusList.Count);
                }
                EditorGUI.indentLevel--;
            }
        }

        /// <summary>
        /// リスト初期化
        /// </summary>
        /// <param name="count"></param>
        private void InitializeList(int count) {
            _isFoldings = new bool[count];
            _isInitialized = true;
        }

        /// <summary>
        /// 指定したindex以外をキャッシュして初期化
        /// indexが-1の場合のみ全てキャッシュして初期化
        /// </summary>
        /// <param name="index"></param>
        /// <param name="count"></param>
        private void InitializeList(int index, int count) {
            bool[] tmp = _isFoldings;
            _isFoldings = new bool[count];
            for (int i = 0, j = 0; i < count; i++) {
                if (index == j) {
                    j++;
                }
                if (tmp.Length - 1 < j) {
                    break;
                }
                _isFoldings[i] = tmp[j++];
            }
        }
    }
}