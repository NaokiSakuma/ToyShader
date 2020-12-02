Shader "Unlit/Matcap" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _MatCapTex ("MatCap Texture", 2D) = "white" {}
    }
    SubShader {
        Tags { "RenderType"="Opaque" "LightMode"="ForwardBase"}
        LOD 100

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MatCapTex;
            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                float3 normal = UnityObjectToWorldNormal(v.normal);
                normal = mul((float3x3)UNITY_MATRIX_V, normal);
                o.uv = normal * 0.5 + 0.5;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                return tex2D(_MatCapTex, i.uv);
            }
            ENDCG
        }
    }
}