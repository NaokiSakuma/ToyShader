Shader "Custom/stainedGlass" {
	// プロパティ
	Properties {
		// テクスチャのデータ
		_MainTex("Texture", 2D) = "white" {}
	}
	// Shaderの中身の記述
	SubShader {
			// 半透明オブジェクトを一番最後に描画する
			Tags { "Queue" = "Transparent" }
			// しきい値
			LOD 200

			// cg言語記述
			CGPROGRAM
			// 透過させる
			#pragma surface surf Standard alpha:fade
			// Shader Model
			#pragma target 3.0
			// input構造体
			struct Input {
				// テクスチャのデータ
				float2 uv_MainTex;
			};

			// テクスチャのデータ
			sampler2D _MainTex;

			// surf関数
			void surf (Input IN, inout SurfaceOutputStandard o) {
				// テクスチャのピクセルの色
                fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
				// ベースカラー
                o.Albedo = c.rgb;
				// グレースケールから透明度を決める
                o.Alpha = ((c.r * 0.3f + c.g * 0.59f + c.b * 0.11f) < 0.2) ? 1 : 0.4f;

				// グレースケール用
				// fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
				// グレースケールにする
				// o.Albedo = dot(c.rgb, float3(0.3f, 0.59f, 0.11f));
				// o.Alpha = 1;
			}
	// Shaderの記述終了
	ENDCG
	}
	// SubShaderに失敗した時に呼ばれる
	FallBack "Diffuse"
}
