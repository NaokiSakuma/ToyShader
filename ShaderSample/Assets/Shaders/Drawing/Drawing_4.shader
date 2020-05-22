Shader "Unlit/Drawing_4" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader {
        Tags { "RenderType"="Opaque" }

        Pass {
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
                float2 uv = i.uv;
                float heart;
                uv = (uv - float2(0.5, 0.38)) * float2(2.1, 2.8);
                heart = pow(uv.x, 2) + pow(uv.y - sqrt(abs(uv.x)), 2);
                heart = step(heart, abs(sin(heart * 8 - _Time.w * 2)));
                return heart;
            }
            ENDCG
        }
    }
}