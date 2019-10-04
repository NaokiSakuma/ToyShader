Shader "Unlit/outline" {
	SubShader {
		Tags { "RenderType" = "Opaque" }
		LOD 100

		Pass {
			Cull Front
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
			};

			v2f vert(appdata v) {
				v2f o;
				float3 n = UnityObjectToWorldNormal(v.normal);
				v.vertex += float4(v.normal * 0.05f, 0);
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}

			fixed4 frag(v2f i ) : COLOR {
				fixed4 col = fixed4(0.1f, 0.1f, 0.1f, 1);
				return col;
			}
			ENDCG
		}

		Pass {
			Cull Back
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float4 normal : NORMAL;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
			};

			v2f vert(appdata v) {
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.normal = UnityObjectToWorldNormal(v.normal);
				return o;
			}

			fixed4 frag(v2f i) : COLOR {
				// ここ逆かも見直す

				half nl = max(0, dot(i.normal, _WorldSpaceLightPos0.xyz));
				// ここが逆、他でベクトルの取得方法が違うかも
				// 白
				if (nl <= 0.01f) nl = 0.1f;
				else if (nl <= 0.3f) nl = 0.3f;
				// 黒
				else nl = 1.0f;
				fixed4 col = fixed4(nl, nl, nl, 1);
				//fixed4 col = fixed4(0,0,0,1);
				return col;
			}
			ENDCG
		}
	}
}