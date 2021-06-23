Shader "Unlit/ShadowDefault" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader {

        // 通常の描画
        Pass {
            Tags { "RenderType"="Opaque" "LightMode"="ForwardBase" }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlights

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                fixed4 diff : COLOR0;
                // 変数名は"pos"固定
                float4 pos : SV_POSITION;
                // unityShadowCoord4型(float4)を定義
                // 影の情報を入れる
                SHADOW_COORDS(1)
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                half3 worldNormal = UnityObjectToWorldNormal(v.normal);
                half NdotL = saturate(dot(worldNormal, _WorldSpaceLightPos0.xyz));
                o.diff = NdotL * _LightColor0;
                // SHADOW_COORDSにスクリーンスペース座標を入れる
                TRANSFER_SHADOW(o)
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                fixed4 col = tex2D(_MainTex, i.uv);
                // シャドウマップのテクセルを反映
                fixed4 shadow = SHADOW_ATTENUATION(i);
                return col * i.diff * shadow;
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
