Shader "Unlit/shake" {
	// プロパティ
	Properties {
		// テクスチャ
		_MainTex("Texture", 2D) = "white" {}
	}
	// Shaderの中身を記述
	SubShader {
		// 一般的なShaderを使用
		Tags { "RenderType" = "Opaque" }
		// しきい値
		LOD 200

		// cg言語記述
		CGPROGRAM
		// vertex shaderをフックする
		#pragma surface surf Lambert vertex:vert
		// Shader Model
		#pragma target 3.0

		// テクスチャ
		sampler2D _MainTex;
		//float4 _MainTex_ST;

		// Input構造体
		struct Input {
			float2 uv_MainTex;
			float3 debug;
		};

		// vert関数
		void vert(inout appdata_base v, out Input IN) {
			// 波の揺れをsin関数を用いて表現
			float amp = 0.5f * sin(_Time * 100 + v.vertex.x * 100);
			v.vertex.xyz = float3(v.vertex.x, v.vertex.y , v.vertex.z);
			v.normal = float3(0,1,0);
			UNITY_INITIALIZE_OUTPUT(Input, IN);
			IN.debug = v.vertex.xyz;
		}

		// surf関数
		void surf(Input IN, inout SurfaceOutput o) {
			// テクスチャのピクセルの色を返す
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = c.xyz;
			// デバッグ用
			o.Albedo = IN.debug;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}