Shader "Unlit/cgincludePass" {
    Properties {
        _Color ("Color", Color) = (0, 0, 0, 0)
    }
    CGINCLUDE
    #include "UnityCG.cginc"
    struct appdata {
        float4 vertex : POSITION;
    };

    struct v2f {
        float4 vertex : SV_POSITION;
    };

    float4 _Color;

    v2f vertFirst (appdata v) {
        v2f o;
        o.vertex = UnityObjectToClipPos(v.vertex);
        return o;
    }

    fixed4 fragFirst (v2f i) : SV_Target {
        return _Color;
    }

    v2f vertSecond (appdata v) {
        v2f o;
        o.vertex = UnityObjectToClipPos(v.vertex - 1);
        return o;
    }

    fixed4 fragSecond (v2f i) : SV_Target {
        return _Color + 1;
    }
    ENDCG

    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 100
        Pass {
            CGPROGRAM
            #pragma vertex vertFirst
            #pragma fragment fragFirst
            ENDCG
        }
        Pass {
            CGPROGRAM
            #pragma vertex vertSecond
            #pragma fragment fragSecond
            ENDCG
        }
    }
}
