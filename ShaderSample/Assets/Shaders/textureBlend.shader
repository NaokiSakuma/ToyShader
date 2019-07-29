Shader "Custom/textureBlend" {
	// プロパティ
	Properties {
		// メインtexture
		_MainTex ("Main Texture", 2D) = "white" {}
		// サブtexture
		_SubTex ("Sub Texture", 2D) = "white" {}
		// マスク画像
		_MaskTex ("Mask Texture", 2D) = "white" {}
	}
	// Shaderの中身の記述
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

		// Input構造体
		struct Input {
			// テクスチャのuv座標
			float2 uv_MainTex;
		};

		// メインtexture
		sampler2D _MainTex;
		// サブtexture
		sampler2D _SubTex;
		// マスクtexture
		sampler2D _MaskTex;

		// surf関数
		void surf (Input IN, inout SurfaceOutputStandard o) {
			// メインtextureのピクセルの色
			fixed4 mainPixel = tex2D (_MainTex, IN.uv_MainTex);
			// サブtextureのピクセルの色
			fixed4 subPixel = tex2D (_SubTex, IN.uv_MainTex);
			// マスクtextureのピクセルの色
			fixed4 mask = tex2D (_MaskTex, IN.uv_MainTex);
			// マスクの色から時間で変化するテクスチャブレンドをする
			o.Albedo = lerp (mainPixel, subPixel, mask * abs(_SinTime.w));
		}
		// Shaderの記述終了
		ENDCG
	}
	// SubShaderが失敗した時に呼ばれる
	FallBack "Diffuse"
}
