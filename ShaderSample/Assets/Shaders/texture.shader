Shader "Custom/texture" {
	// プロパティ
	Properties {
		// テクスチャのデータ
		_MainTex("Texture", 2D) = "white" {}
	}
	// あとで理解する
	SubShader {
		// 一般的なシェーダーを使用
		Tags { "RenderType" = "Opaque"}
		// しきい値
		LOD 200

		// あとで理解する
		CGPROGRAM
		// フォワードレンダリング
		#pragma surface  surf Standard fullforwardshadows
		// あとで理解する
		#pragma target 3.0

		// inpur構造体
		struct Input {
			// テクスチャのデータ
			float2 uv_MainTex;
		};

		// テクスチャのデータ
		sampler2D _MainTex;

		// surf関数
		void surf(Input IN, inout SurfaceOutputStandard o) {
			// テクスチャのピクセルの色を返す
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex);
		}
		// あとで理解する
		ENDCG
	}
	// あとで理解する
	FallBack "Diffuse"
}