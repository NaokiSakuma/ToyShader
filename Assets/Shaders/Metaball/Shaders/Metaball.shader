Shader "Unlit/Metaball"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Scale ("Scale", Range(0,0.05)) = 0.01
        _Cutoff ("Cutoff", Range(0,05)) = 0.01
    }

    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "RenderType"="Transparent"
            "PreviewType"="Plane"
        }

        Cull Off//裏も描画する
        Lighting Off
        ZWrite Off//transparentで使用する部分
        Blend One OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex   : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
                float2 texcoord : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed _Scale;
            fixed _Cutoff;

            v2f vert(appdata v)
            {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.texcoord = v.texcoord;
                    return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                fixed2 uv = i.texcoord - 0.5;
                fixed a = 1 / (uv.x * uv.x + uv.y * uv.y);
                a *= _Scale;
                fixed4 color = 1 * a;
                clip(color.a - _Cutoff);
                return color;
            }
         ENDCG
         }
    }
}
