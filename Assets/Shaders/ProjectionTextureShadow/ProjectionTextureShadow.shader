﻿Shader "Unlit/ProjectionTextureShadow"
{
    Properties 
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float4 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 projectorSpacePos : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float3 worldNormal : TEXCOORD2;
                float2 uv : TEXCOORD3;
            };
            
            sampler2D _ShadowProjectorTexture1;
            float4x4 _ShadowProjectorMatrixVP1;
            float4 _ShadowProjectorPos1;
            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.projectorSpacePos = ComputeScreenPos(mul(mul(_ShadowProjectorMatrixVP1, unity_ObjectToWorld), v.vertex));
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Projection座標に変換
                // tex2DProj(_ProjectorTexture, i.projectorSpacePos)と同義
                i.projectorSpacePos.xyz /= i.projectorSpacePos.w;
                float4 projectorTex = tex2D(_ShadowProjectorTexture1, i.projectorSpacePos.xy);
                // カメラの範囲外(0 ~ 1)は描画しない
                fixed3 isOut = step((i.projectorSpacePos - 0.5) * sign(i.projectorSpacePos), 0.5);
                float alpha = isOut.x * isOut.y * isOut.z;
                // プロジェクターから見て、裏側の面には描画しない
                // Perspective  : _ShadowProjectorPos.xyz - i.worldPos
                // Orthographic : -_ShadowProjectorPos.xyz
                alpha *= step(-dot(lerp(-_ShadowProjectorPos1.xyz, _ShadowProjectorPos1.xyz - i.worldPos, _ShadowProjectorPos1.w), i.worldNormal), 0);
                fixed4 col = tex2D(_MainTex, i.uv);
                return lerp(1, 1 - projectorTex.a, alpha) * col;
            }
            ENDCG
        }
    }
}
