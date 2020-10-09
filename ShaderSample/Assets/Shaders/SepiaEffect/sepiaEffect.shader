Shader "Unlit/sepiaEffect" {
    // Properties {
    //     _Darkness("Dark", Range(0, 0.1f)) = 0.04f
    //     _Strength("Strength", Range(0.05f, 0.15f)) = 0.05f
    //     _MainTex("MainTex", 2D) = "" {}
    // }
    Properties {
    	_Darkness("Dark", Range(0, 0.1)) = 0.04
    	_Strength("Strength", Range(0.05, 0.15)) = 0.05
        _MainTex("MainTex", 2D) = ""{}
    }
    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            half _Darkness;
            half _Strength;

            fixed4 frag(v2f_img i) : COLOR {
                fixed4 c = tex2D(_MainTex, i.uv);
                half gray = c.r * 0.3f + c.g * 0.6f + c.b * 0.1 - _Darkness;
                gray = (gray < 0) ? 0 : gray;

                half r = gray + _Strength;
                half b = gray - _Strength;

                r = (r > 1.0f) ? 1.0f : r;
                b = (b < 0) ? 0 : b;
                c.rgb = fixed3(r, gray, b);
                return c;
            }
            ENDCG
        }
    }
}