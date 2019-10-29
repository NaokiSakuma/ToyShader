Shader "Unlit/wipeEffect" {
	Properties {
		_Radius("Radius", Range(0, 2)) = 2
		_MainTex("MainTex", 2D) = "" {}
	}
	SubShader {
		Pass {
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"

			float _Radius;
			sampler2D _MainTex;

			fixed4 frag(v2f_img i) : COLOR {
				fixed4 c = tex2D(_MainTex, i.uv);
				i.uv -= fixed2(0.5f, 0.5f);
				i.uv.x *= 16.0f / 9.0f;
				if(distance(i.uv, fixed2(0, 0)) < _Radius) {
					return c;
					//discard;
				}
				return fixed4(0, 0, 0, 1);
			}
			ENDCG
		}
	}
}
