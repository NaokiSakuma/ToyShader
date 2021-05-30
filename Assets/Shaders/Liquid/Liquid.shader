Shader "Unlit/Liquid" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        [Header(Shape)]
        _HeightMax ("Height Max", Float) = 1.0
        _HeightMin ("Height Min", Float) = 0.0
        _TopColor ("Top Color", Color) = (0.5, 0.75, 1,1)
        _BottomColor ("Bottom Color", Color) = (0, 0.25, 1, 1)
        [Header(Wave)]
        _WaveSpeed ("Wave Speed", Float) = 1.0
        _WavePower ("Wave Power", Float) = 0.1
        _WaveLength ("Wave Length", Float) = 1.0
        [Header(Rim)]
        _RimColor ("Rim Light Color", Color) = (1, 1, 1, 1)
        _RimPower("Rim Light Power", Float) = 3
        [Header(Surface)]
        _SurfaceColor ("Surface Color", Color) = (1, 1, 1, 1)
        [HideInInspector]
        _TransformPositionY ("Transform Position Y", float) = 0
    }
    SubShader {
        Tags { "RenderType"="Opaque"}
        LOD 100

        // 波の全面の描画
        Pass {
            ZWrite On
            ZTest LEqual
            Blend Off
            Cull Back

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float3 viewDir : TEXCOORD1;
                float4 worldPos : TEXCOORD2;
                float3 normal : NORMAL;
                float4 vertex : POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            half4 _TopColor;
            half4 _BottomColor;
            half4 _RimColor;
            float _RimPower;
            float _HeightMax;
            float _HeightMin;
            float _WaveSpeed;
            float _WavePower;
            float _WaveLength;
            float _TransformPositionY;

            v2f vert (appdata v) {
                v2f o;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                // o.worldPosでモデル行列を出している
                // 最適化として、UnityObjectToClipPos()を使用せずに頂点を計算
                o.vertex = mul(UNITY_MATRIX_VP,o.worldPos);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.viewDir = normalize(_WorldSpaceCameraPos - o.worldPos.xyz);
                return o;
            }

            half4 frag (v2f i) : SV_Target {
                // Script側からオブジェクトのローカル座標を渡す
                float heightMax = _HeightMax + _TransformPositionY;
                float heightMin = _HeightMin + _TransformPositionY;
                // sin(i.worldPos.x + i.worldPos.z)で波ｗ表現
                float height = heightMax + sin((i.worldPos.x + i.worldPos.z) * _WaveLength + _Time.w * _WaveSpeed) * _WavePower;
                // 0以下は描画しない
                clip(height - i.worldPos.y);
                half4 col = tex2D(_MainTex, i.uv);
                //グラデーション
                float rate = saturate((i.worldPos.y - heightMin) / (heightMax - heightMin));
                col.rgb *= lerp(_BottomColor.rgb, _TopColor.rgb, rate);
                //リムライト
                float rim = 1 - saturate(dot(i.normal, i.viewDir));
                col.rgb += pow(rim, _RimPower) * _RimColor;
                return col;
            }
            ENDCG
        }

        // 波の背面の描画
        Pass {
            ZWrite On
            ZTest LEqual
            Blend Off
            Cull Front

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
            };

            struct v2f {
                UNITY_FOG_COORDS(0)
                float4 worldPos : TEXCOORD3;
                float4 vertex : SV_POSITION;
            };

            half4 _SurfaceColor;
            float _HeightMax;
            float _WaveSpeed;
            float _WavePower;
            float _WaveLength;
            float _TransformPositionY;

            v2f vert (appdata v) {
                v2f o;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex );
                o.vertex = mul(UNITY_MATRIX_VP,o.worldPos);
                return o;
            }

            half4 frag (v2f i) : SV_Target {
                float heightMax = _HeightMax + _TransformPositionY;
                float height = heightMax + sin( (i.worldPos.x + i.worldPos.z) * _WaveLength + _Time.w * _WaveSpeed) * _WavePower;
                clip(height - i.worldPos.y);
                half4 col = _SurfaceColor;
                return col;
            }
            ENDCG
        }
    }
}