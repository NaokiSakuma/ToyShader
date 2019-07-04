Shader "Custom/rimlighting" {
	// あとで理解する
	SubShader {
		// 一般的なシェーダーを使用
		Tags { "RenderType" = "Opaque"}
		// しきい値
		LOD 200

		// あとで理解する
		CGPROGRAM
		// あとで理解する
		#pragma surface surf Standard
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
			fixed4 baseColor = fixed4(0.05f,0.1f,0,1.0f);
			// リムライティングの色を決める
			fixed4 rimColor = fixed4(0.5f,0.7f,0.5f,1.0f);

			o.Albedo = baseColor;
			// リムライティングの度合いを法線と視線の2つのベクトルから取得
			float rim = 1 - saturate(dot(IN.viewDir,IN.worldNormal));
			// 発行度合いを調整する
			o.Emission = rimColor * pow(rim, 2);
		}
		// あとで理解する
		ENDCG
	}
	// あとで理解する
	FallBack "Diffuse"
}