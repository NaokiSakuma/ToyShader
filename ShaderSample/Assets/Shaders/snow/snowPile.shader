Shader "Unlit/snowPile" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _SnowPileValue("SnowPileValue", Range(0, 3)) = 0.0
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            half _SnowPileValue;

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                // オブジェクトの法線ベクトルと上方向のベクトルでの内積で積もる場所を計算
                float d = dot(i.normal, fixed3(0, 1, 0));
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 white = fixed4(1, 1, 1, 1);
                col = lerp(col, white, d * _SnowPileValue);
                return col;
            }
            ENDCG
        }
		Pass {
			Name "CastShadow"
            // シャドウマップや深度テクスチャに描画
			Tags { "LightMode" = "ShadowCaster" }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
            // シャドウマップに書き込む
			#pragma multi_compile_shadowcaster

			#include "UnityCG.cginc"

			struct v2f {
                // SV_POSITION
				V2F_SHADOW_CASTER;
			};

			v2f vert( appdata_base v ) {
				v2f o;
                // lightのbiasをワールド座標と計算
				TRANSFER_SHADOW_CASTER(o)
				return o;
			}

			float4 frag( v2f i ) : COLOR {
                // viewの深度
				SHADOW_CASTER_FRAGMENT(i)
			}
			ENDCG
		}
    }
}
