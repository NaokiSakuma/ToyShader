Shader "Unlit/shakeVert" {
	Properties{
		_MainTex("Texture", 2D) = "white" {}
	}
	SubShader{
			Tags{
				"Queue" = "Geometry"
				"RenderType" = "Opaque"
				//"LightMode" = "ForwardBase"
			}
	Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;

			struct v2f {
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 rgb : NORMAL;
			};

			v2f vert(appdata_base v) {
				v2f o;
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				float amp = 0.5f * sin(_Time * 100 + v.vertex.x * 100);
				v.vertex.xyz = float3(v.vertex.x, v.vertex.y + amp, v.vertex.z);
				o.rgb = float3(v.vertex.x / 10, v.vertex.y / 10, v.vertex.z / 10);
				o.rgb.x = clamp(o.rgb.x, 0, 1);
				o.rgb.y = clamp(o.rgb.y, 0, 1);
				o.rgb.z = clamp(o.rgb.z, 0, 1);
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}

			fixed4 frag(v2f i) :Color {
				fixed4 c = tex2D(_MainTex, i.uv);
				//c.xyz = i.rgb.xyz;
				return c;
			}
			ENDCG
		}
	}
}