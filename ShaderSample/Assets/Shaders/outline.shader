Shader "Unlit/outline" {
	// Shaderの中身を記述
	SubShader {
		Tags {
			// 一般的なShaderを使用
			"RenderType" = "Opaque"
			// materialにlightの情報を渡す
			"LightMode"="ForwardBase"
		}
		// しきい値
		LOD 200

		// 1Pass目
		Pass {
			// 視点と同じ側のポリゴンをレンダリングしない
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
				// 法線方向にモデルを膨らませる
				v.vertex += float4(v.normal * 0.04f, 0);
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}

			fixed4 frag(v2f i ) : COLOR {
				fixed4 col = fixed4(0.1f, 0.1f, 0.1f, 1);
				return col;
			}
			ENDCG
		}
		// 2Pass目
		Pass {
			// 視点と視点と反対側のポリゴンをレンダリングしない
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
				// ライトと法線の外積
				half nl = max(0, dot(_WorldSpaceLightPos0.xyz, i.normal));
				if (nl <= 0.01f) nl = 0.1f;
				else if (nl <= 0.3f) nl = 0.3f;
				else nl = 1.0f;
				fixed4 col = fixed4(nl, nl, nl, 1);
				return col;
			}
			ENDCG
		}
	}
}