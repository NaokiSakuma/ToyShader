// LOD値の高い順からSubShaderを記述する必要がある
Shader "Custom/LOD" {
    Properties{}
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 10

        Pass {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #include "UnityCG.cginc"

            fixed4 frag (v2f_img i) : SV_Target {
                return fixed4(0, 0, 1, 1);
            }
            ENDCG
        }
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 5

        Pass {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #include "UnityCG.cginc"

            fixed4 frag (v2f_img i) : SV_Target {
                return fixed4(1, 0, 0, 1);
            }
            ENDCG
        }
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 3

        Pass {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #include "UnityCG.cginc"

            fixed4 frag (v2f_img i) : SV_Target {
                return fixed4(0, 1, 1, 1);
            }
            ENDCG
        }
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 1

        Pass {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #include "UnityCG.cginc"

            fixed4 frag (v2f_img i) : SV_Target {
                return fixed4(0, 1, 0, 1);
            }
            ENDCG
        }
    }
}
