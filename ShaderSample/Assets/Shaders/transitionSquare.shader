Shader "Unlit/transitionSquare" {
// 	Properties {
// 		_MainTex("Texture", 2D) = "white" {}
// 		_Div("Division Size", int) = 10
// 	}
// 	SubShader {
// 		Tags { "RenderType"="Transparent" "Queue" = "Transparent"}

// 		Pass {
// 			CGPROGRAM
// 			#pragma vertex vert
// 			#pragma fragment frag
// 			#include "UnityCG.cginc"

// 			struct appdata {
// 				float4 vertex : POSITION;
// 				float2 uv : TEXCOORD0;
// 			};

// 			struct v2f {
// 				float2 uv : TEXCOORD0;
// 				float4 vertex : SV_POSITION;
// 			};

// 			sampler2D _MainTex;
// 			// これいる？
// 			float4 _MainTex_ST;
// 			int _Div;

// 			v2f vert (appdata v) {
// 				v2f o;
// 				o.vertex = UnityObjectToClipPos(v.vertex);
// 				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
// 				return o;
// 			}

// 			float rectangle(float2 p, float2 size) {
// 				return max(abs(p.x) - size.x, abs(p.y) - size.y);
// 			}

// 			fixed4 frag (v2f i) : SV_Target {
// 				float div = _Div;
// 				float2 f_st = i.uv * 2.0 - 1.0;
// 				f_st *= div;
// 				float rect = rectangle(f_st, float2(0, 0));
// 				float a = 0.0;
// 				a = 1 - step(1.0, rect);

// 				fixed4 col = 0.0;
// 				col.a = a;
// 				return col;
// 			}
// 			ENDCG
// 		}
// 	}
// }

	// 途中
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Div ("Division Size", Int) = 10
		_Size ("Size", Range(0.01, 2)) = 1
		_Value ("Value", Range(0, 100)) = 0
		_Rotation ("Rotation", Range(0, 360)) = 0
		[MaterialToggle] _Direction ("Rotation Direction", Float) = 0
		[MaterialToggle] _Aspect ("Aspect Ratio", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "RenderType"="Transparent" }

		Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

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
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

			int _Div;
			float _Size;
			float _Value;
			float _Rotation;
			int _Direction;
			int _Aspect;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

			//rectangle
			float rectangle(float2 p, float2 size){
				return max(abs(p.x) - size.x, abs(p.y) - size.y);
			}

			float2 rotation(float2 p, float theta){
				return float2((p.x) * cos(theta) - p.y * sin(theta), p.x * sin(theta) +  p.y * cos(theta));
			}

			float trs(float2 p, float val, float div, float t)
			{
				float mn = 0.0001;
				float u = 1.0;
				for(int i = 0; i < t; i++){
					u += (div * 2.0 - 4.0 * i - 2.0) * 4.0;
				}

				float r = (div * 2.0 - 4.0 * t - 2.0);
				float sc = val - u;

				float a = 1;

				float rect = rectangle(p - float2(-div + t * 2.0, -div + t * 2.0 + 1.0), float2(sc, mn));
				a = 1 - step(1.0, rect);

				rect = rectangle(p - float2(div - t * 2.0 - 1.0, -div + (t + 1.0) * 2.0), float2(mn, sc - r - 2.0));
				a = max(a, 1 - step(1.0, rect));

				rect = rectangle(p - float2(div - (t + 1) * 2.0, div - t * 2.0 - 1.0), float2(sc - r * 2.0 - 2.0, mn));
				a = max(a, 1 - step(1.0, rect));

				rect = rectangle(p - float2(-div + t * 2.0 + 1.0, div - (t + 1) * 2.0), float2(mn, sc - r * 3.0 - 2.0));
				a = max(a, 1 - step(1.0, rect));

				return a;
			}

            fixed4 frag (v2f i) : SV_Target
            {
				float div = _Div;
				int dir = _Direction;
				int asp = _Aspect;
				float ratio = _ScreenParams.x / _ScreenParams.y;
				float val = _Value * div * div * 2.0;

				float2 f_st = i.uv * 2.0 - 1.0;

				//アスペクト比で調整
				f_st.x *= (ratio * asp + (1.0 - asp));

				//座標の回転
				f_st = rotation(f_st, radians(_Rotation));

				//回転方向
				f_st.x = f_st.x * (1.0 - 2.0 * dir);

				f_st *= div;
				f_st *= _Size;

				float a = 0.0;

				for(int i = 0; i < div * 0.5; i++){
					a = min(a + trs(f_st, val, div, i), 1);
				}

                fixed4 col = 0.0;
				col.a = a;
				return col;
            }
            ENDCG
        }
    }
}