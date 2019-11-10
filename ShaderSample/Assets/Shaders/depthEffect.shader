Shader "Unlit/depthEffect" {
	SubShader {
		// 一般的なShaderを使用
		Tags { "RenderType" = "Opaque"}
		// しきい値
		LOD 200

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			// デプステクスチャを取得
			sampler2D _CameraDepthTexture;
			// TRANSFORM_TEXを使用するのに必要
			float4 _CameraDepthTexture_ST;

			struct appdata {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			v2f vert(appdata v) {
				v2f o;
				// クリップ座標に変換
				o.vertex = UnityObjectToClipPos(v.vertex);
				// テクスチャのスケールとオフセットを適応
				o.uv = TRANSFORM_TEX(v.uv, _CameraDepthTexture);
				return o;
			}

			fixed4 frag(v2f i) : COLOR{
				// 非線形深度データを線形スケールに変換
				return UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.uv));
			}
			ENDCG
		}
	}
}