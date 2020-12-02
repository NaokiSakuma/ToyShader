Shader "Unlit/Normalmap" {
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _NormalMap ("Normal map", 2D) = "bump" {}
        _Shininess ("Shininess", Range(0.0, 1.0)) = 0.078125
    }
    SubShader {
        Tags { "Queue"="Geometry" "RenderType"="Opaque"}

        Pass {
            Tags { "LightMode"="ForwardBase" }

            CGPROGRAM
            #include "UnityCG.cginc"

            #pragma vertex vert
            #pragma fragment frag

            float4 _LightColor0;
            sampler2D _MainTex;
            sampler2D _NormalMap;
            half _Shininess;

            struct appdata {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
            };

            struct v2f {
                float4 pos : SV_POSITION;
                half2 uv : TEXCOORD0;
                half3 lightDir : TEXCOORD1;
                half3 viewDir : TEXCOORD2;
            };

            v2f vert(appdata v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv  = v.texcoord.xy;
                // 接空間の行列を取得
                TANGENT_SPACE_ROTATION;
                // ライトの方向ベクトルを接空間に変換
                o.lightDir = mul(rotation, ObjSpaceLightDir(v.vertex));
                // カメラの方向ベクトルを接空間に変換
                o.viewDir = mul(rotation, ObjSpaceViewDir(v.vertex));
                return o;
            }

            float4 frag(v2f i) : COLOR {
                i.lightDir = normalize(i.lightDir);
                i.viewDir = normalize(i.viewDir);
                half3 halfDir = normalize(i.lightDir + i.viewDir);
                half4 tex = tex2D(_MainTex, i.uv);
                half3 normal = UnpackNormal(tex2D(_NormalMap, i.uv));
                // 拡散反射光
                half4 diff = saturate(dot(normal, i.lightDir)) * _LightColor0;
                // 鏡面反射光
                half3 spec = pow(max(0, dot(normal, halfDir)), _Shininess * 128.0) * _LightColor0.rgb * tex.rgb;
                fixed4 color;
                color.rgb  = tex.rgb * diff + spec;
                return color;
            }
            ENDCG
        }
    }
}