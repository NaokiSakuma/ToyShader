Shader "Custom/dissolve" {
	Properties {
		_Color("Color", Color) = (1, 1, 1, 1)
		_MainTex("MainTex", 2D) = "white" {}
		_DissolveTex("DissolveTex", 2D) = "white" {}
		_Glossiness("Glossiness", Range(0, 1)) = 0.5
		_Metallic("Metallic", Range(0, 1)) = 0.0
		_Threshold("Threshold", Range(0, 1)) = 0.0
	}
	SubShader {
		Tags { "RenderType" = "Opaque"}
		LOD 200

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _DissolveTex;

		struct Input {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		half _Threshold;
		fixed4 _Color;

		// UNITY_INSTANCING_BUFFER_START(Props)
		// UNITY_INSTANCING_BUFFER_END(Props)

		void surf(Input IN, inout SurfaceOutputStandard o) {
			fixed4 m = tex2D(_DissolveTex, IN.uv_MainTex);
			half g = m.r * 0.3f + m.g * 0.59f + m.b * 0.11f;
			if (g <= _Threshold) {
				discard;
			}
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	Fallback "Diffuse"
}
