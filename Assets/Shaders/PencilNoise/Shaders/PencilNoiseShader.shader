Shader "Unlit/PencilNoiseShader" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _Brightness ("Brightness", Range(-1.0, 1.0)) = 0.2
        _OutlineThick ("OutlineThick", Range(0.0, 1.0)) = 0.1
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
            float4 _MainTex_TexelSize;
            float _Brightness;
            float _OutlineThick;

            // 乱数生成
            float rand(float3 value) {
                return frac(sin(dot(value.xyz, float3(12.9898, 78.233, 56.787))) * 43758.5453);
            }

            // ノイズ
            float noise(float3 pos) {
                float3 floorPos = floor(pos);
                float3 stepPos = smoothstep(0, 1, frac(pos));
                float4 a = float4(
                    rand(floorPos + float3(0, 0, 0)),
                    rand(floorPos + float3(1, 0, 0)),
                    rand(floorPos + float3(0, 1, 0)),
                    rand(floorPos + float3(1, 1, 0)));
                float4 b = float4(
                    rand(floorPos + float3(0, 0, 1)),
                    rand(floorPos + float3(1, 0, 1)),
                    rand(floorPos + float3(0, 1, 1)),
                    rand(floorPos + float3(1, 1, 1)));
                a = lerp(a, b, stepPos.z);
                a.xy = lerp(a.xy, a.zw, stepPos.y);
                return lerp(a.x, a.y, stepPos.x);
            }

            // パーリンノイズ
            float perlin(float3 pos) {
                return
                    (noise(pos) * 32 +
                    noise(pos * 2 ) * 16 +
                    noise(pos * 4) * 8 +
                    noise(pos * 8) * 4 +
                    noise(pos * 16) * 2 +
                    noise(pos * 32) ) / 63;
            }

            // モノクロ
            float monochrome(float3 col) {
                return 0.299 * col.r + 0.587 * col.g + 0.114 * col.b;
            }

            // ソーベルフィルタ
            half3 Sobel(float2 uv) {
                // 自身を中心とした上下左右8方向のピクセルをサンプリング
                float diffU = _MainTex_TexelSize.x * _OutlineThick;
                float diffV = _MainTex_TexelSize.y * _OutlineThick;
                half3 col00 = tex2D(_MainTex, uv + half2(-diffU, -diffV));
                half3 col01 = tex2D(_MainTex, uv + half2(-diffU, 0.0));
                half3 col02 = tex2D(_MainTex, uv + half2(-diffU, diffV));
                half3 col10 = tex2D(_MainTex, uv + half2(0.0, -diffV));
                half3 col12 = tex2D(_MainTex, uv + half2(0.0, diffV));
                half3 col20 = tex2D(_MainTex, uv + half2(diffU, -diffV));
                half3 col21 = tex2D(_MainTex, uv + half2(diffU, 0.0));
                half3 col22 = tex2D(_MainTex, uv + half2(diffU, diffV));

                // 横方向カーネル
                half3 horizontalColor = 0;
                horizontalColor += col00 * -1.0;
                horizontalColor += col01 * -2.0;
                horizontalColor += col02 * -1.0;
                horizontalColor += col20;
                horizontalColor += col21 * 2.0;
                horizontalColor += col22;

                // 縦方向カーネル
                half3 verticalColor = 0;
                verticalColor += col00;
                verticalColor += col10 * 2.0;
                verticalColor += col20;
                verticalColor += col02 * -1.0;
                verticalColor += col12 * -2.0;
                verticalColor += col22 * -1.0;

                // 色の差を求める
                half3 outline = sqrt(horizontalColor * horizontalColor + verticalColor * verticalColor);
                return outline;
            }


            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                // 手ぶれのようにする
                float2 screenUV = i.uv * _ScreenParams.xy;
                i.uv += (float2(perlin(float3(screenUV, _Time.y)), perlin(float3(screenUV, _Time.y)))) * 0.01;
                // モノクロ
                float col = monochrome(tex2D(_MainTex, i.uv)) + _Brightness;
                // ソーベルフィルタ
                col -= Sobel(i.uv);
                // パーリンノイズで鉛筆風を強める
                col *= perlin(float3(screenUV, _Time.y * 10)) * 0.5f + 0.8f;
                return float4(col, col, col, 1);
            }
            ENDCG
        }
    }
}
