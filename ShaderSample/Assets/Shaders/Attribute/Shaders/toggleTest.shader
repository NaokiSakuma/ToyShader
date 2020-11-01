Shader "Unlit/toggleTest" {
    Properties {
        [Toggle] _IsBlack ("Is Black", int) = 0
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // _IsBlackをキーワードとして定義
            // プロパティを定義する場合は、プロパティ名 + 「_ON」
            #pragma shader_feature _ _ISBLACK_ON

            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
            };

            struct v2f {
                float4 vertex : SV_POSITION;
            };

            fixed4 _Color;

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                #ifdef _ISBLACK_ON
                    return fixed4(0, 0, 0, 1);
                #else
                    return fixed4(1, 1, 1, 1);
                #endif
            }
            ENDCG
        }
    }
}