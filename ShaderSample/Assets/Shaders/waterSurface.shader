Shader "Custom/waterSurface" {
	Properties {
		_MainTex("Texture", 2D) = "white" {}
	}

	SubShader {
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {
			fixed2 uv = IN.uv_MainTex;
			fixed speed = 1.0f;
			uv.x += speed * _Time;
			uv.y += speed * _Time;
			o.Albedo = tex2D (_MainTex, uv);
		}
		ENDCG
	}
	FallBack "Diffuse"
}
