Shader "Custom/ice" {
	SubShader {
		// 半透明オブジェクトを一番最後に描画する
		Tags { "Queue" = "Transparent"}
		// あとで理解する
		LOD 200

		// あとで理解する
		CGPROGRAM
		// 透過させる
		#pragma surface surf Standard alpha:fade
		// あとで理解する
		#pragma target 3.0

		// input構造体
		struct Input {
			// 1ピクセル毎の法線
			float3 worldNormal;
			// カメラからの視線
			float3 viewDir;
		};

		// surf関数
		void surf(Input IN, inout SurfaceOutputStandard o) {
			// ベースカラーの変更
			o.Albedo = fixed4(1,1,1,1);
			// アルファ値を法線と視線の2つのベクトルから取得
			float alpha = 1 - (abs(dot(IN.viewDir, IN.worldNormal)));
			// 見た目の調整で*1.5
			o.Alpha = alpha * 1.5f;
		}
		// あとで理解する
		ENDCG
	}
	// あとで理解する
	FallBack "Diffuse"
}