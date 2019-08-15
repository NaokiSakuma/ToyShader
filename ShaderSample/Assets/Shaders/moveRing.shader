Shader "Custom/moveRing" {
	// プロパティ
	Properties {
		// 波紋の色
		_Color ("Color" , Color) = (1 ,1 ,1 ,1)
	}
	// Shaderの中身の記述
	SubShader {
		// 一般的なShaderを使用
		Tags { "RenderType" = "Opaque" }
		// しきい値
		LOD 200

		// cg言語記述
		CGPROGRAM
		// 指定しないとフォワードレンダリング
		#pragma surface surf Standard
		// Shader Model
		#pragma target 3.0

		// input構造体
		struct Input {
			// ワールド座標
			float3 worldPos;
		};

		// 波紋の色
		fixed4 _Color;

		// surf関数
		void surf (Input IN, inout SurfaceOutputStandard o) {
			// 原点からの距離
 			float dist = distance(fixed3(0, 0, 0), IN.worldPos);
			// 波紋の感覚
			float interval = 3.0f;
			// 波紋のスピード
			float speed = 10.0f;
			// sin波
			float val = abs(sin(dist * interval + _Time.y * speed));
			// リングの幅(0 ~ 1)
			float ringWidth = 0.98f;
			// ベースカラーを変化させる
			if (val > ringWidth) {
				o.Albedo = fixed4(1,1,1,1);
			} else {
				o.Albedo = _Color;
			}
		}
		// Shaderの記述終了
		ENDCG
	}
	// SubShaderが失敗した時に呼ばれる
	FallBack "Diffuse"
}