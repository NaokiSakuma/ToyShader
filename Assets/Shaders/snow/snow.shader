Shader "Custom/snow" {
	Properties {
		_Color("Color", Color) = (1, 1, 1, 1)
		_MainTex("MainTex", 2D) = "white" {}
		_Smoothness("Smoothness", Range(0, 1)) = 0.5
		_Metallic("Metallic", Range(0, 1)) = 0.0
		_Snow("Snow", Range(0, 3)) = 0.0
	}
	SubShader {
		// 何もないならopaque入れた方が良さそう
		Tags { "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
		//#pragma surface surf Standard fullforwardshadows
		#pragma surface surf Standard vertex:vert
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float3 worldNormal;
		};

		half _Smoothness;
		half _Metallic;
		fixed4 _Color;
		half _Snow;

		void vert(inout appdata_base v, out Input IN) {
			UNITY_INITIALIZE_OUTPUT(Input, IN);
			//float d = dot(IN.worldNormal, fixed3(0, 1, 0));
			//saturate(d);
			//d = d * 1000;
			half3 normal = UnityObjectToWorldNormal(v.normal);
			float d = dot(normal, fixed3(0, 1, 0));
			//v.vertex.xyz = float3(v.vertex.x , v.vertex.y, v.vertex.z + (normal.z * d));
		}

		void surf(Input IN, inout SurfaceOutputStandard o) {
			float d = dot(IN.worldNormal, fixed3(0, 1, 0));
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			fixed4 white = fixed4(1, 1, 1, 1);
			c = lerp(c, white, d * _Snow);

			o.Albedo = c.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}
		ENDCG
	}
	Fallback "Diffuse"
}
