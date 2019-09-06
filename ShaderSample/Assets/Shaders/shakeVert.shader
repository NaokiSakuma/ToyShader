Shader "Unlit/shakeVert" {
	Properties{
		_MainTex("Texture", 2D) = "white" {}
	}
	SubShader{
			Tags{
				"Queue" = "Geometry"
				"RenderType" = "Opaque"
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
				float3 test : NORMAL;
			};

			v2f vert(appdata_base v) {
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				float amp = 20.5f * sin(_Time * 100 + v.vertex.x * 100);
				o.vertex.xyz = float3(o.vertex.x, o.vertex.y, o.vertex.z);
				o.test = float3(0,1,0);
				//o.test = o.vertex.xyz;
				return o;
			}

			fixed4 frag(v2f i) :SV_Target {
				fixed4 c = tex2D(_MainTex, i.uv);
				c.xyz = i.vertex.xyz;
				// デバッグ用
				//c = fixed4(c.x * i.vertex.x, c.w * i.vertex.y, c.z * i.vertex.z, c.a);//fixed4(i.vertex.xyz, 1);
				return c;
			}
			ENDCG
		}
	}
}