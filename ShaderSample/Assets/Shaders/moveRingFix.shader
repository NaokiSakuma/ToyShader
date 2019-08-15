Shader "Custom/moveRingFix" {
	Properties {
		_Color ("Color" , Color) = (1, 1, 1, 1)
	}
	SubShader {
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Standard
		#pragma target 3.0

		struct Input {
			float3 worldPos;
		};

		fixed4 _Color;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			float3 localPos = IN.worldPos -  mul(unity_ObjectToWorld, float4(0, 0, 0, 1)).xyz;
 			float dist = distance(fixed3(0, 0, 0), localPos);
			float radius = 2.0f;
			if (radius < dist ) {
				o.Albedo = _Color;
			} else {
				o.Albedo = fixed4(1, 1, 1, 1);
			}
		}
		ENDCG
	}
	FallBack "Diffuse"
}
