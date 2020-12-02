Shader "Unlit/Drawing_5" {
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

            // 花
            // fixed4 frag (v2f i) : SV_Target {
            //     float2 uv = i.uv;
            //     uv = 0.5 - uv;
            //     float a = atan2(uv.y, uv.x);
            //     // 花が大きく描画されすぎてしまうので*0.4で微調整
            //     float d = abs(cos(a * 3)) * 0.4;
            //     d = step(length(uv), d);
            //     return d;
            // }

            // 雪
            // fixed4 frag (v2f i) : SV_Target {
            //     float2 uv = i.uv;
            //     uv = 0.5 - uv;
            //     float a = atan2(uv.y, uv.x);
            //     float d = abs(cos(a * 12) * sin(a * 3)) * 0.4 + 0.1;
            //     d = step(length(uv), d);
            //     return d;
            // }

            // 桜
            fixed4 frag (v2f i) : SV_Target {
                float2 uv = i.uv;
                uv = 0.5 - uv;
                float a = atan2(uv.y, uv.x);
                float d = min(abs(cos(a * 2.5)) + 0.4, abs(sin(a * 2.5)) + 1.1) * 0.32;
                d = step(length(uv), d);
                return d;
            }
            ENDCG
        }
    }
}