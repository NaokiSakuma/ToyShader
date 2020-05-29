Shader "Unlit/Drawing_7" {
    Properties {
        // textureのオフセットとスケールを非表示にする
        [NoScaleOffset]_MainTex ("Texture", 2D) = "white" {}
        _LineColor ("Line Color", Color) = (1, 1, 1, 1)
        // rangeをintで調整できるように
        [IntRange] _SplitCount ("Split Count", Range(1, 30)) = 10
        _LineSize ("Line Size", Range(0.01, 1)) = 1
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
            fixed4 _LineColor;
            float _SplitCount;
            float _LineSize;

            // 左右に揺らす
            float2 LeftRightDist(float2 uv) {
                float x = 2 * uv.y + sin(_Time.y * 5);
                uv.x += sin(_Time.y * 10) * 0.1 * sin(5 * x) * (-(x - 1) * (x - 1) + 1);
                return uv;
            }

            // 膨らみを持たせて揺らす
            float2 BulgeDist(float2 uv) {
                return uv *= 1.0 + 0.1 * sin(uv.x * 5.0 + _Time.z) + 0.1 * sin(uv.y * 3.0 + _Time.z);
            }

            // 中央に膨らます
            float2 BulgeCenter(float2 uv) {
                float2 tempUv = uv - 0.5;
                tempUv *= 1.0 + 15 * pow(length(uv - 0.5), 2);
                return tempUv += 0.5;
            }

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                // ここの関数を変更することで歪みを変更できる
                float2 uv = BulgeCenter(i.uv);
                // グリット処理
                float4 grid = lerp(tex2D(_MainTex, uv),
                                   _LineColor,
                                   saturate(
                                       (frac(uv.x * (_SplitCount + _LineSize)) < _LineSize) +
                                       (frac(uv.y * (_SplitCount + _LineSize)) < _LineSize)
                                    )
                                );
                return grid;
            }


            ENDCG
        }
    }
}
