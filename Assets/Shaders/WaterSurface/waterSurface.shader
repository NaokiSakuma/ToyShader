Shader "Custom/waterSurface" {
	// プロパティ
	Properties {
		// テクスチャのデータ
		_MainTex("Texture", 2D) = "white" {}
	}
	// Shaderの中身の記述
	SubShader {
		// 一般的なShaderを使用
		Tags { "RenderType" = "Opaque" }
		// しきい値
		LOD 200

		// cg言語記述
		CGPROGRAM
		// フォワードレンダリング
		#pragma surface surf Standard fullforwardshadows
		// Shader Model
		#pragma target 3.0

		// Input構造体
		struct Input {
			// テクスチャのuv座標
			float2 uv_MainTex;
		};

		// テクスチャのデータ
		sampler2D _MainTex;

		// surf関数
		void surf (Input IN, inout SurfaceOutputStandard o) {
			// uv値の取得
			fixed2 uv = IN.uv_MainTex;
			// uvスクロールの速度
			fixed speed = 1.0f;
			// x軸の移動
			uv.x += speed * _Time.x;
			// y軸の移動
			uv.y += speed * _Time.x;
			// ズレを適応させる
			o.Albedo = tex2D (_MainTex, uv);
		}
		// Shaderの記述終了
		ENDCG
	}
	// SubShaderが失敗した時に呼ばれる
	FallBack "Diffuse"
}
