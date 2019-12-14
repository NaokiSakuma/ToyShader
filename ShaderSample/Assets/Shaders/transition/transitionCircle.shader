Shader "Unlit/transitionCircle" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _CircleSideNum ("Circle Side Num", int) = 16
        _CircleValue ("Circle Value", Range(0, 1)) = 0
        _Threshold ("Threshold", Range(0, 1)) = 0
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
            int _CircleSideNum;
            float _CircleValue;
            float _Threshold;

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
                float2 div = float2(_CircleSideNum, _CircleSideNum * _ScreenParams.y / _ScreenParams.x);
                float2 st = i.uv * div;
                float i_st = floor(st);
                float value = _CircleValue - i_st.x * _Threshold;
                float2 f_st = frac(st) * 2.0 - 1.0;
                float ci = circle(f_st);
                fixed4 col = 0.0;
                col.a = step(value, ci);
                return col;
            }
            ENDCG
        }
    }
}
