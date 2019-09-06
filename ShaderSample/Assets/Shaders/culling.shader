Shader "Unlit/culling" {
	// プロパティ
	Properties {
		// テクスチャ
		_MainTex ("Texture", 2D) = "white" {}
	}
	// Shaderの中身を記述
	SubShader{
		// 不透明なオブジェクト
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
		// しきい値
		LOD 200
		// カリングをoffに
		Cull off
		// 透過処理
		Blend SrcAlpha OneMinusSrcAlpha
		// レンダリングの方式
		Pass {
			// cg言語記述
			CGPROGRAM
			// vertexShaderの宣言
			#pragma vertex vert
			// fragmentShaderの宣言
			#pragma fragment frag

			// インクルード
			#include "UnityCG.cginc"

			// appdata構造体
			struct appdata {
				// pos
				float4 vertex : POSITION;
				// uv値
				float2 uv : TEXCOORD0;
			};

			// vertex to fragment構造体
			struct v2f {
				// pos
				float4 vertex : SV_POSITION;
				// uv値
				float2 uv : TEXCOORD0;
			};

			// テクスチャ
			sampler2D _MainTex;
			// TRANSFORM_TEXの定数
			float4 _MainTex_ST;

			// vert関数
			v2f vert (appdata v) {
				v2f o;
				// クリップ座標に変換
				o.vertex = UnityObjectToClipPos(v.vertex);
				// テクスチャのスケールとオフセット
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			// frag関数
			fixed4 frag (v2f i) : SV_Target {
				// テクスチャのピクセルの色を返す
				fixed4 col = tex2D(_MainTex, i.uv);
				return col;
			}
			ENDCG
		}
	}
}