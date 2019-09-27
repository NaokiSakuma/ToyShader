Shader "Custom/dissolve" {
	// プロパティ
	Properties {
		// 色
		_Color("Color", Color) = (1, 1, 1, 1)
		// メインテクスチャ
		_MainTex("MainTex", 2D) = "white" {}
		// 溶ける模様テクスチャ
		_DissolveTex("DissolveTex", 2D) = "white" {}
		// 滑らかさ
		_Glossiness("Glossiness", Range(0, 1)) = 0.5
		// 金属度
		_Metallic("Metallic", Range(0, 1)) = 0.0
		// しきい値
		_Threshold("Threshold", Range(0, 1)) = 0.0
	}

	// Shaderの中身を記述
	SubShader {
		// 一般的なShaderを使用
		Tags { "RenderType" = "Opaque"}
		// しきい値
		LOD 200

		// cg言語記述
		CGPROGRAM
		// フォワードレンダリング
		#pragma surface surf Standard fullforwardshadows
		// Shader Model
		#pragma target 3.0

		// メインテクスチャ
		sampler2D _MainTex;
		// 溶ける模様テクスチャ
		sampler2D _DissolveTex;

		// Input構造体
		struct Input {
			float2 uv_MainTex;
		};

		// 滑らかさ
		half _Glossiness;
		// 金属度
		half _Metallic;
		// しきい値
		half _Threshold;
		// 色
		fixed4 _Color;

		void surf(Input IN, inout SurfaceOutputStandard o) {
			fixed4 dissolveTex = tex2D(_DissolveTex, IN.uv_MainTex);
			// グレースケール
			half gray = dissolveTex.r * 0.3f + dissolveTex.g * 0.59f + dissolveTex.b * 0.11f;
			// しきい値以下の場合、レンダリングしない
			if (gray <= _Threshold) {
				discard;
			}
			fixed4 mainTex = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = mainTex.rgb;
			o.Alpha = mainTex.a;
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
		}
		// Shaderの記述終了
		ENDCG
	}
	// SubShaderが失敗した時に呼ばれる
	Fallback "Diffuse"
}