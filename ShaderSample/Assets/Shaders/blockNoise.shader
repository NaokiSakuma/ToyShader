Shader "Custom/blockNoise" {
	Properties {
		_MainTex("Albedo(RBG)", 2D) = "white" {}
		// 変更点
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

		float noise(fixed2 a) {
			fixed2 uv = floor(a);
			return random(uv);
		}

		void surf(Input IN, inout SurfaceOutputStandard o) {
			float randomNum = noise(IN.uv_MainTex * _SideBlockNum);
			// ここまで
			o.Albedo = fixed4(randomNum, randomNum, randomNum, 1);
		}
		ENDCG
	}
	Fallback "Diffuse"
}