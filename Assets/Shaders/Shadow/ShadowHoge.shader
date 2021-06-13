Shader "Unlit/ShadowHoge" {
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        // 光源視点からのDepthTexture(RenderTexture)
        _LightDepthTex("LightDepth",2D) = "white" {}
        // 影の濃さ
        _ShadowValue("ShadowValue",Range(0.001,1)) = 1
    }
    SubShader
    {
        CGINCLUDE
        #include "UnityCG.cginc"

        struct appdata
        {
            float4 vertex : POSITION;
            float2 uv : TEXCOORD0;
        };

        struct v2f
        {
            float2 uv : TEXCOORD0;
            float4 vertex : SV_POSITION;            
            float4 shadowVertex : TEXCOORD1;
        };

        sampler2D _MainTex;
        float4 _MainTex_ST;
        // 光源視点からのDepthTexture(RenderTexture)
        sampler2D _LightDepthTex;
        // 光源視点から射影変換行列
        float4x4 _LightVP;
        // 影の濃さ
        float _ShadowValue;
        
        v2f vert (appdata v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            // 光源視点の変換座標
            o.shadowVertex = mul(_LightVP, v.vertex);

            // debug
            //o.vertex = mul(_LightVP, v.vertex);
            o.uv = TRANSFORM_TEX(v.uv, _MainTex);
            return o;
        }
        
        fixed4 frag (v2f i) : SV_Target
        {
            float shadowRatio = 1;
            // ライトから見た時のDepth
            float4 lightDepth = tex2D(_LightDepthTex, i.shadowVertex.xy);

            // Debug Code
            // return lightDepth.r;

            // Debug Code
            // return i.shadowVertex.z;

            // DepthTextureのDepthとライトから見た時のライトからの距離を比べてDepthTextureのDepthの方が小さかったら影と判断
            float diff = i.shadowVertex.z - lightDepth.r;
            if (diff >= 0)
            {
                shadowRatio = _ShadowValue;
            }
            return tex2D(_MainTex, i.uv.xy) * shadowRatio;
        }

        ENDCG

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag         
            ENDCG
        }
    }
}