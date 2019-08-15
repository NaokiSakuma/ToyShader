Shader "Custom/perlinNoise" {
	Properties {
		_MainTex("Albedo(RBG)", 2D) = "white" {}
		_SideBlockNum("SideBlockNum", int) = 0
	}
	SubShader {
		Tags { "RenderType" = "Opaque"}
		LOD 200

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		struct Input {
			float2 uv_MainTex;
		};

		int _SideBlockNum;

		float random(fixed2 uv) {
			return frac(sin(dot(uv, fixed2(12.9898f, 78.233f))) * 43758.5453);
		}

		float noise(fixed2 uv) {
			fixed2 uv_integer = floor(uv);
			return random(uv_integer);
		}

		// 変更点
		float valueNoise(fixed2 uv) {
			fixed2 uv_integer = floor(uv);
			fixed2 uv_decimal = frac(uv);

			float v00 = random(uv_integer + fixed2(0, 0));
			float v10 = random(uv_integer + fixed2(1, 0));
			float v01 = random(uv_integer + fixed2(0, 1));
			float v11 = random(uv_integer + fixed2(1, 1));
			fixed2 lerpResult = (- 2.0f * pow(uv_decimal, 3)) + (3.0f * pow(uv_decimal, 2));

			float v0010 = lerp(v00, v10, lerpResult.x);
			float v0111 = lerp(v01, v11, lerpResult.x);
			return lerp(v0010, v0111, lerpResult.y);
		}

		void surf(Input IN, inout SurfaceOutputStandard o) {
			float randomNum = valueNoise(IN.uv_MainTex * _SideBlockNum);
			// ここまで
			o.Albedo = fixed4(randomNum, randomNum, randomNum, 1);
		}
		ENDCG
	}
	Fallback "Diffuse"
}