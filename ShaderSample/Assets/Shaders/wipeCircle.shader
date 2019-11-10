Shader "Unlit/wipeCircle" {
	Properties {
		_Radius("Radius", Range(0, 2)) = 0
	}
	SubShader {
		Pass {
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"

			float _Radius;

			fixed4 frag(v2f_img i) : COLOR {
				// これ＋じゃない？
				i.uv -= fixed2(0.5f, 0.5f);
				i.uv.x *= 16.0f / 9.0f;
				if(distance(i.uv, fixed2(0, 0)) < _Radius) {
					discard;
				}
				return fixed4(0.0f, 0.0f, 0.0f, 1.0f);
			}
			ENDCG
		}
	}
}