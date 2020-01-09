Shader "Unlit/softShadowRaymarching" {
	Properties {
		_Radius("Radius", Range(0.0, 1.0)) = 0.3
		_BlurShadow("BlurShadow", Range(0.0, 50.0)) = 16.0
	}
	SubShader {
		Tags{ "Queue" = "Transparent" "LightMode"="ForwardBase"}
		LOD 100

		Pass {
			ZWrite On
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f {
				float2 uv : TEXCOORD0;
				float4 pos : POSITION1;
				float4 vertex : SV_POSITION;
			};

			float _Radius;
			float _BlurShadow;

			float sphere(float3 pos) {
                return length(pos) - _Radius;
            }

			float plane(float3 pos) {
				float4 n = float4(0.0, 0.8, 0.0, 1.0);
				return dot(pos, n.xyz) + n.w;
			}

			float getDist(float3 pos) {
				return min(plane(pos), sphere(pos));
			}

			float3 getNormal(float3 pos) {
				float d = 0.001;
				return normalize(float3(
					getDist(pos + float3(d, 0, 0)) - getDist(pos + float3(-d, 0, 0)),
					getDist(pos + float3(0, d, 0)) - getDist(pos + float3(0, -d, 0)),
					getDist(pos + float3(0, 0, d)) - getDist(pos + float3(0, 0, -d))
				));
			}

			// 光源に向かってレイを飛ばす
			float genShadow(float3 pos, float3 lightDir) {
				float marchingDist = 0.0;
				float c = 0.001;
				float r = 1.0;
				float shadowCoef = 0.5;
				for (float t = 0.0; t < 50.0; t++) {
					marchingDist = getDist(pos + lightDir * c);
					if (marchingDist < 0.001) {
						return shadowCoef;
					}
					r = min(r, marchingDist * _BlurShadow / c);
					c += marchingDist;
				}
				return 1.0 - shadowCoef + r * shadowCoef;
			}

			v2f vert(appdata v) {
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.pos = mul(unity_ObjectToWorld, v.vertex);
				o.uv = v.uv;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target {
				float3 pos = i.pos.xyz;
				float3 rayDir = normalize(pos.xyz - _WorldSpaceCameraPos);
				const int StepNum = 30;

				for (int j = 0; j < StepNum; j++) {
					float marchingDist = getDist(pos);
					if (marchingDist < 0.001) {
						float3 lightDir = _WorldSpaceLightPos0.xyz;
						float3 normal = getNormal(pos);
						float3 lightColor = _LightColor0;
						float shadow = genShadow(pos + normal * 0.001, lightDir);
						fixed4 col = fixed4(lightColor * max(dot(normal, lightDir), 0) * max(0.5, shadow), 1.0);
						col.rgb += fixed3(0.2f, 0.2f, 0.2f);
						return col;
					}
				    pos.xyz += marchingDist * rayDir.xyz;
				}
			    return 0;
			}
			ENDCG
		}
	}
}