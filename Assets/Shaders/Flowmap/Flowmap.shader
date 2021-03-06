﻿Shader "Unlit/Flowmap" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _FlowMap ("Flow Map", 2D) = "white" {}
        _FlowSpeed ("Flow Speed", float) = 1.0
        _FlowPower ("Flow Power", float) = 1.0
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
            sampler2D _FlowMap;
            float _FlowSpeed;
            float _FlowPower;

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                // フローマップのuv値を-0.5~0.5に
                float2 flowDir = tex2D(_FlowMap, i.uv) - 0.5;
                flowDir *= _FlowPower;
                // timeを0~1間でループ
                float progress1 = frac(_Time.x * _FlowSpeed);
                // 補間用に0.5ズラす
                float progress2 = frac(_Time.x * _FlowSpeed + 0.5);
                // uv + 0~flowDir
                float2 uv1 = i.uv + flowDir * progress1;
                float2 uv2 = i.uv + flowDir * progress2;

                // progress1が0か1に近づく時(ループの切れ目)にlerpRateが1に近づくように
                float lerpRate = abs((0.5 - progress1) / 0.5);
                fixed4 col1 = tex2D(_MainTex, uv1);
                fixed4 col2 = tex2D(_MainTex, uv2);
                // ループの切れ目を補間する
                return lerp(col1, col2, lerpRate);
            }
            ENDCG
        }
    }
}
