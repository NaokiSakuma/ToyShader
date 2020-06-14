Shader "Unlit/Figure" {
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
            static const float PI = 3.14159265;

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            // 円
            // uv : uv値
            // r : 半径
            float circle(float2 uv, float r) {
                return length(uv) - r;
            }

            // 楕円
            // uv : uv値
            // r : 縦横の長さ
            float ellipse(float2 uv, float2 r) {
                return length(uv / r);
            }

            // 四角形
            // uv : uv値
            // r : 縦横の長さ
            float square(float2 uv, float2 r) {
                return max(abs(uv.x) - r.x, abs(uv.y) - r.y);
            }

            // ひし形
            // uv : uv値
            // r : 縦横の長さ
            float rhombus(float2 uv, float2 r) {
                return abs(uv.x) + abs(uv.y) - r;
            }

            // 多角形
            // uv : uv値
            // r : 縦横の長さ
            // sideNum : 辺の数
            float polygon(float2 uv, float2 r, int sideNum) {
                float atan = atan2(uv.x, uv.y);
                float rad = 2 * PI / sideNum;
                return cos(floor(0.5 + atan / rad) * rad - atan) * length(uv) - r;
            }

            // ハート
            // uv : uv値
            // r : 縦横の長さ
            float heart(float2 uv, float2 r) {
                uv.x = 1.2 * uv.x + sign(uv.x) * uv.y * 0.55;
                return length(uv) - r;
            }

            fixed4 frag (v2f i) : SV_Target {
                fixed2 uv = i.uv - fixed2(0.5,0.5);
                fixed4 col = step(0.4, heart(uv, float2(0.001,0.001)));
                return col;
            }
            ENDCG
        }
    }
}
