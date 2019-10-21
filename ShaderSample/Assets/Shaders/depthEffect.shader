﻿Shader "Unlit/depthEffect" {
	SubShader {
		Tags { "RenderType" = "Opaque"}

		LOD 200

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _CameraDepthTexture;
			float4 _CameraDepthTexture_ST;

			struct appdata {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			v2f vert(appdata v) {
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _CameraDepthTexture);
				return o;
			}

			fixed4 frag(v2f i) : COLOR{
				return (tex2D(_CameraDepthTexture, i.uv));
			}
			ENDCG
		}
	}
}