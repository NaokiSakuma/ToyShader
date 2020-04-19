Shader "Unlit/DistortionNoise" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _BaseColor ("Base Color", Color) = (1, 1, 1, 1)
        _AddAlphaColor ("Add Alpha Color", Color) = (0, 0, 0, 1)
        _NoiseTilingOffset ("NoiseTex Tiling(x,y)/Offset(z,w)", Vector) = (0.1, 0.1, 0,0)
        _NoiseSizeScroll ("NoiseTex Size(x,y)/Scroll(z,w)", Vector) = (16, 16, 0, 0)
        _DistortionPower ("Distortion Power", Float) = 0
    }
    SubShader {
        Tags { "RenderType"="Transparent" "Queue"="Transparent"}
        LOD 100
        Blend SrcAlpha OneMinusSrcAlpha

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "extensionNoiseUtil.cginc"

            struct appdata {
                float4 vertex : POSITION;
                // テクスチャ用UV
                float2 texuv : TEXCOORD0;
                // ノイズ用UV
                float2 noiseuv : TEXCOORD1;
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                // テクスチャ用UV
                float2 texuv : TEXCOORD0;
                // ノイズ用UV
                float2 noiseuv : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _BaseColor;
            fixed4 _AddAlphaColor;
            fixed4 _NoiseTilingOffset;
            fixed4 _NoiseSizeScroll;
            float _DistortionPower;

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texuv = TRANSFORM_TEX(v.texuv, _MainTex);
                o.noiseuv = TRANSFORM_NOISE_TEX(v.noiseuv, _NoiseTilingOffset, _NoiseSizeScroll);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                // パーリンノイズの疑似乱数からフローマップに見立てた法線マップを生成
                fixed3 dist = normalNoise(i.noiseuv, _NoiseSizeScroll.xy);
                // distを-1 ~ 1の範囲に
                dist = dist * 2 - 1;
                dist *= _DistortionPower;
                i.texuv += dist.xy;
                fixed4 col = tex2D(_MainTex, i.texuv);
                col *= _BaseColor;
                col.rgb += _AddAlphaColor * col.a;
                return col;
            }
            ENDCG
        }
    }
}
