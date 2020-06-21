Shader "Unlit/MoveFigure" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
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
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float square(float2 uv, float2 r) {
                return max(abs(uv.x) - r.x, abs(uv.y) - r.y);
            }
            float circle(float2 uv, float r) {
                return length(uv) - r;
            }

            float2 rotation(float2 uv, float theta){
                half2x2 rotate = half2x2(cos(theta), -sin(theta), sin(theta), cos(theta));
                return mul(rotate, uv);
            }

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            // 往復移動
            // fixed4 frag (v2f i) : SV_Target {
            //     float2 uv = frac(i.uv) * 2 - 1;
            //     float2 pos = sin(_Time.y);
            //     uv += pos;
            //     float rect = square(uv, float2(-0.38, -0.38));
            //     fixed4 col = smoothstep(0.5, 0.51, rect);
            //     return col;
            // }

            // その場で回転
            // fixed4 frag (v2f i) : SV_Target {
            //     float2 uv = frac(i.uv) * 2 - 1;
            //     float theta = _Time.y * 2;
            //     uv = rotation(uv + rotation(0.5, theta), theta);
            //     float rect = square(uv, float2(-0.38, -0.38));
            //     fixed4 col = smoothstep(0.5, 0.51, rect);
            //     return col;
            // }

            // 原点を中心に回転
            // fixed4 frag (v2f i) : SV_Target {
            //     float2 uv = frac(i.uv) * 2 - 1;
            //     float2 radius = float2(0.4, 0.4);
            //     uv += float2(radius.x * cos(_Time.y * 2), radius.y * sin(_Time.y * 2));
            //     float rect = square(uv, float2(-0.38, -0.38));
            //     fixed4 col = smoothstep(0.5, 0.51, rect);
            //     return col;
            // }

            // モーフィング
            fixed4 frag (v2f i) : SV_Target {
                float2 uv = frac(i.uv) * 2 - 1;
                float ci = circle(uv, 0);
                float rect = square(uv, 0);
                float time = (sin(_Time.y * 1.5) + 1) * 0.5;
                float morph = lerp(ci, rect, time);
                fixed4 col = smoothstep(0.5, 0.51, morph);
                return col;
            }

            ENDCG
        }
    }
}


