Shader "Unlit/uvVertex" {
	SubShader {
		pass {
			Tags { "RenderType" = "Opaque" }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			struct appdata {
				float4 vertex : POSITION;
				float4 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			v2f vert(appdata v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord.xy;
				return o;
			}

			fixed4 frag(v2f v) : SV_TARGET {
				return fixed4(v.uv.x, v.uv.y, 0, 1.0f);
			}
			ENDCG
		}
	}
}
