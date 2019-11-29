﻿Shader "Unlit/transitionBlock" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader {
        Tags { "RenderType" = "Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha

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

            float circle(float2 p) {
                return dot(p, p);
            }

            fixed4 frag (v2f i) : SV_Target {
                float2 f_st = frac(i.uv) * 2.0 - 1.0;
                float ci = circle(f_st);
                fixed4 col = 0.0;
                col.a = step(0.1, ci);
                return col;
            }
            ENDCG
        }
    }
}
