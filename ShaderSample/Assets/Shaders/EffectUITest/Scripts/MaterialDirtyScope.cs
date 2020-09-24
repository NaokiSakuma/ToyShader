using UnityEditor;
using UnityEngine;
using System.Linq;

namespace uGUIEffect {
    public class MaterialDirtyScope : EditorGUI.ChangeCheckScope {
        readonly Object[] targets;

        public MaterialDirtyScope(Object[] targets) {
            this.targets = targets;
        }

        // BaseMaterialEffectのclassを作っていないためコメントアウト
        // protected override void CloseScope() {
        //     if (changed) {
        //         foreach (var effect in targets.OfType<BaseMaterialEffect>()) {
        //             effect.SetMaterialDirty();
        //         }
        //     }
        //     base.CloseScope();
        // }
     }
}