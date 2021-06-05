﻿Shader "Unlit/BloomTexture" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
    }

    SubShader {
        Cull Off
        ZWrite Off
        ZTest Always

        Pass {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment fragBright
            ENDCG
        }

        Pass {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment fragGauss
            ENDCG
        }

        CGINCLUDE
        #include "UnityCG.cginc"
        sampler2D _MainTex;
        sampler2D _Tmp;
        float _Strength;
        float _Blur;
        float _Threshold;
        half4 _Offset;
        static const int samplingCount = 10;
        half _Weights[samplingCount];

        fixed4 fragBright (v2f_img i) : SV_Target {
            fixed4 col = tex2D(_MainTex, i.uv);
            // ピクセルの明るさ
            float bright = (col.r + col.g + col.b) / 3;
            // しきい値によって明るさを決める
            float tmp = step(_Threshold, bright);
            return col * tmp * _Strength;
        }

        fixed4 fragGauss (v2f_img i) : SV_Target {
            fixed4 col = 0;
            // メモリサイズを大きくする代わりに高速にする
            [unroll]
            // 左右へのサンプリング
            for (int j = samplingCount - 1; j > 0; j--) {
                col += tex2D(_Tmp, i.uv - (_Offset.xy * j)) * _Weights[j];
            }

            [unroll]
            // 上下へのサンプリング
            for (int j = 0; j < samplingCount; j++) {
                col += tex2D(_Tmp, i.uv + (_Offset.xy * j)) * _Weights[j];
            }
            return col + tex2D(_MainTex, i.uv);
        }

        ENDCG
    }
}