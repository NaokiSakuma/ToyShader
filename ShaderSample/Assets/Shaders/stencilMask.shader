Shader "Custom/stencilMask" {
    // プロパティ
    Properties {
        // テクスチャ
        _MainTex ("Base(RGB)", 2D) = "white" {}
    }
    // Shaderの中身を記述
    SubShader {
        // 不透明なオブジェクト
        Tags { "RenderType" = "Transparent" "Queue" = "Transparent"}
        // ステンシル
        Stencil {
            // バッファに書き込む値
            Ref 1
            // 常に
            Comp always
            // バッファに書き込む
            Pass replace
        }
        // cg言語記述
        CGPROGRAM
        // 拡散、透過
        #pragma surface surf Lambert alpha
        // Input構造体
        struct Input {
            // テクスチャ
            float2 uv_MainTex;
        };
        // surf関数
        void surf (Input IN, inout SurfaceOutput o) {
            o.Albedo = fixed3(0, 0, 0);
            o.Alpha = 0.5f;
        }
        // Shaderの記述終了
        ENDCG
    }
    // SubShaderが失敗した時に呼ばれる
    FallBack "Diffuse"
}