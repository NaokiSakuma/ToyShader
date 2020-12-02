Shader "Unlit/SimpleVertexFragment" {
	// Shaderの中身を記述
	SubShader {
		// レンダリングの方式
		Pass {
			// cg言語記述
			CGPROGRAM
			// vertexShaderの宣言
			#pragma vertex vert
			// fragmentShaderの宣言
			#pragma fragment frag

			// vert関数
			float4 vert(float4 v:POSITION) : SV_POSITION {
				// クリップ座標に変換
				return UnityObjectToClipPos(v);
			}

			// frag関数
			fixed4 frag() : COLOR {
				// 赤色にする
				return fixed4(1.0f, 0.0f, 0.0f, 1.0f);
			}
			// Shaderの記述終了
			ENDCG
		}
	}
}