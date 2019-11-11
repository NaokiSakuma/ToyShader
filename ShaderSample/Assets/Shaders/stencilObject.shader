Shader "Custom/stencilObject" {
    // プロパティ
    Properties {
        // テクスチャ
        _MainTex ("Base(RGB)", 2D) = "white" {}
    }
    // Shaderの中身を記述
    SubShader {
        // 一般的なShaderを使用
        Tags { "RenderType" = "Opaque" "Queue" = "Transparent+1"}
        // ステンシル
        Stencil {
            // バッファに書き込む値
            Ref 1
			ReadMask 1
            // バッファが等しいか
            Comp equal
            // バッファに保持
            //Pass replace
        }
        // cg言語記述
        CGPROGRAM
        // 拡散
        #pragma surface surf Lambert
        // テクスチャ
        sampler2D _MainTex;
        // Input構造体
        struct Input {
            // テクスチャ
            float2 uv_MainTex;
        };
        // surf関数
        void surf (Input IN, inout SurfaceOutput o) {
            // テクスチャのピクセルの色を返す
            half4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        // Shaderの記述終了
        ENDCG
    }
    // SubShaderが失敗した時に呼ばれる
    FallBack "Diffuse"
}