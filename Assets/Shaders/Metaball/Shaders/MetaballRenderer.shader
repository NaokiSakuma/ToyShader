Shader "Unlit/MetaballRenderer"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
        _Cutoff ("Cutoff", Range(0,1)) = 0.5
        _Stroke ("Storke", Range(0,1)) = 0.1
        _StrokeColor ("StrokeColor", Color) = (1,1,1,1)
    }

    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "RenderType"="Transparent"
        }

        Cull Off//裏も描画する
        ZWrite Off //transparentで使用する部分
        Blend One OneMinusSrcAlpha

        Pass
        {
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
            };


            sampler2D _MainTex;
            half4 _Color;
            fixed _Cutoff;
            fixed _Stroke;
            half4 _StrokeColor;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord = v.texcoord;
                o.color = v.color * _Color;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 color = tex2D(_MainTex, i.texcoord);
                clip(color.a - _Cutoff);
                // TODO リファクタ
                color = color.a < _Stroke ? _StrokeColor : _Color;
                return color;
            }
        ENDCG
        }
    }
}
