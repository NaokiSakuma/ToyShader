Shader "Unlit/GaussianBlur" {
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
            // 可能な限り精度を下げて実行時間を最小限に抑えるオプション
            #pragma fragmentoption ARB_precision_hint_fastest

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
            half4 _Offset;
            static const int samplingCount = 10;
            half _Weights[samplingCount];

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                fixed4 col = 0;

                // メモリサイズを大きくする代わりに高速にする
                [unroll]
                // 左右へのサンプリング
                for (int j = samplingCount - 1; j > 0; j--) {
                    col += tex2D(_MainTex, i.uv - (_Offset.xy * j)) * _Weights[j];
                }

                [unroll]
                // 上下へのサンプリング
                for (int j = 0; j < samplingCount; j++) {
                    col += tex2D(_MainTex, i.uv + (_Offset.xy * j)) * _Weights[j];
                }
                return col;
            }
            ENDCG
        }
    }
}
