Shader "Unlit/ShadowDef" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader {

        // 通常の描画
        Pass {
            Tags { "RenderType"="Opaque" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }

        // 影の描画
        Pass {
            Tags { "LightMode"="ShadowCaster" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_shadowcaster

            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                // 深度テクスチャではないキューブマップの場合
                // float3 vec : TEXCOORD0;
                // float4 pos : SV_POSITION
                // それ以外の場合
                // float4 pos : SV_POSITION
                V2F_SHADOW_CASTER;
            };

            v2f vert (appdata v) {
                v2f o;
                // 深度テクスチャではないキューブマップの場合
                // o.vec = mul(unity_ObjectToWorld, v.vertex).xyz - _LightPositionRange.xyz;
                // o.pos = UnityObjectToClipPos(v.vertex);
                // それ以外の場合
                // o.pos = UnityClipSpaceShadowCasterPos(v.vertex, v.normal);
                // o.pos = UnityApplyLinearShadowBias(o.pos);
                TRANSFER_SHADOW_CASTER_NORMALOFFSET(o);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                // 深度テクスチャではないキューブマップの場合
                // UnityEncodeCubeShadowDepth ((length(i.vec) + unity_LightShadowBias.x) * _LightPositionRange.w);
                // それ以外の場合
                // return 0
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
}
