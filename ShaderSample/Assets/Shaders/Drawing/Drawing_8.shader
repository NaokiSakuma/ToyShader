Shader "Unlit/Drawing_8" {
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

            // 四角形を描画する
            float box (float2 uv, float size) {
                size = 0.5 + size * 0.5;
                uv = step(uv, size) * step(1.0 - uv, size);
                return uv.x * uv.y;
            }

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                int num = 10;
                float2 repeat = frac(i.uv * num);
                // sinカーブでアニメーション
                return box(repeat, abs(sin(_Time.y * 3)));
            }
            ENDCG
        }
    }
}
