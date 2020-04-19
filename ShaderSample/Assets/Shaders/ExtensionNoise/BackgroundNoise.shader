Shader "Unlit/BackgroundNoise" {
    Properties {
        _NoiseTilingOffset ("NoiseTex Tiling(x,y)/Offset(z,w)", Vector) = (0.1, 0.1, 0,0)
        _NoiseSizeScroll ("NoiseTex Size(x,y)/Scroll(z,w)", Vector) = (16, 16, 0, 0)
        _DistortionPower ("Distortion Power", Float) = 0
    }
    SubShader {
        Tags { "RenderType"="Transparent" "Queue"="Transparent"}
        LOD 100
        Blend SrcAlpha OneMinusSrcAlpha

        // 直前のレンダリング結果を取得
        GrabPass { "_BackgroundTexture" }

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "extensionNoiseUtil.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                float4 grabuv : TEXCOORD0;
                float2 noiseuv : TEXCOORD1;
            };

            // GrabPassで取得した結果を格納
            sampler2D _BackgroundTexture;
            fixed4 _NoiseTilingOffset;
            fixed4 _NoiseSizeScroll;
            float _DistortionPower;

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.grabuv = ComputeGrabScreenPos(o.vertex);
                o.noiseuv = TRANSFORM_NOISE_TEX(v.uv, _NoiseTilingOffset, _NoiseSizeScroll);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                fixed3 dist = normalNoise(i.noiseuv, _NoiseSizeScroll.xy);
                dist = dist * 2 - 1;
                dist *= _DistortionPower;
                i.grabuv.xy += dist.xy;
                // tex2Dproj : i.grabuvを除算
                // UNITY_PROJ_COORD : 投影されたテクスチャ座標を正しい座標に変換
                fixed4 col = tex2Dproj(_BackgroundTexture, UNITY_PROJ_COORD(i.grabuv));
                return col;
            }
            ENDCG
        }
    }
}
