Shader "Custom/sample" {
	SubShader{

		// 後で理解する
		Tags{ "RenderType" = "Opaque" }
		LOD 200

		// 後で理解する
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		// input構造体
		struct Input {
			// 必要ないが、surf関数を使うために仕方なく使用
			float2 uv_MainTex;
		};

		// surf関数
		void surf(Input IN, inout SurfaceOutputStandard o) {
			// ベースカラーを赤にする
			o.Albedo = fixed4(1.0f, 0, 0, 1);
		}
		// 後で理解する
		ENDCG
	}
	// 後で理解する
	FallBack "Diffuse"
}
