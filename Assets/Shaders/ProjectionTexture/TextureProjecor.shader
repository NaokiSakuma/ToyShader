Shader "Unlit/TextureProjecor"
{
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
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 projectorSpacePos : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float3 worldNormal : TEXCOORD2;
            };
            
            sampler2D _ProjectorTexture;
            float4x4 _ProjectorMatrixVP;
            float4 _ProjectorPos;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.projectorSpacePos = ComputeScreenPos(mul(mul(_ProjectorMatrixVP, unity_ObjectToWorld), v.vertex));
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Projection座標に変換
                // tex2DProj(_ProjectorTexture, i.projectorSpacePos)と同義
                i.projectorSpacePos.xyz /= i.projectorSpacePos.w;
                float4 projectorTex = tex2D(_ProjectorTexture, i.projectorSpacePos.xy);
                // カメラの範囲外(0 ~ 1)は描画しない
                fixed3 isOut = step((i.projectorSpacePos - 0.5) * sign(i.projectorSpacePos), 0.5);
                float alpha = isOut.x * isOut.y * isOut.z;
                // プロジェクターから見て、裏側の面には描画しない
                // Perspective  : _ProjectorPos.xyz - i.worldPos
                // Orthographic : -_ProjectorPos.xyz
                alpha *= step(-dot(lerp(-_ProjectorPos.xyz, _ProjectorPos.xyz - i.worldPos, _ProjectorPos.w), i.worldNormal), 0);
                return projectorTex * alpha;
            }
            ENDCG
        }
    }
}
