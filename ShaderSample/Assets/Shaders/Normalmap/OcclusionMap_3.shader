Shader "Unlit/OcclusionMap_2" {
	Properties {
		_MainTex ("Main Texture", 2D) = "white" {}
		_HeightMap("Height Map", 2D) = "white" {}
		_HeightScale("Height", Float) = 0.5
	}

	SubShader {
		Tags {
			"RenderType"="Opaque"
		}

		LOD 200

		Pass {
			CGPROGRAM
			#include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag

			sampler2D _MainTex;
			sampler2D _HeightMap;
			float _HeightScale;

			struct Vertex {
				float4 position : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct Vertex2Fragment {
				float4 position : SV_POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
				float3 objectViewDir : TEXCOORD1;
				float4 objectPos : TEXCOORD2;
			};

			Vertex2Fragment vert(Vertex i) {
				Vertex2Fragment o;
				o.objectPos = mul(unity_ObjectToWorld, i.position);
				o.normal = i.normal;
				o.uv = i.uv;
				o.objectViewDir = o.objectPos - _WorldSpaceCameraPos.xyz;
				o.position = mul(UNITY_MATRIX_VP, o.objectPos);
				return o;
			}

			float4 frag(Vertex2Fragment i) : SV_TARGET {
				float2 uv = i.uv;
				float2 uvStart = i.uv;
				float3 rayDir = normalize(i.objectViewDir);
				float3 rayPos = i.objectPos;
				float3 rayPosStart = i.objectPos;
				float rayHeight = 0.0;
				float objHeight = -_HeightScale;
				const int HeightSamples = 32;
				const float HeightPerSample = 1.0 / HeightSamples;
				// 最底面の位置
				float rayScale = (-_HeightScale / rayDir.y);
				// 1回のstep
				float3 rayStep = rayDir * rayScale * HeightPerSample;
				// HeightSamples以上だと最底面
				// objHeight < rayHeightだと衝突
				for (int i = 0; i < HeightSamples && objHeight < rayHeight; ++i) {
					// rayを進める
					rayPos += rayStep;
					// 進めた分のuv値のずれを修正
					uv = uvStart + rayPos.xz - rayPosStart.xz;
					// ハイトマップの高さ情報(0~1)
					objHeight = tex2D(_HeightMap, uv).r;
					// ハイトマップの高さ情報を-_HeightScale~0に変換
					objHeight = objHeight * _HeightScale - _HeightScale;
					rayHeight = rayPos.y;
				}
				// 衝突したstepと、その1つ前のstepで補間する
				float2 nextObjPoint = uv;
				float2 prevObjPoint = uv - rayStep.xz;
				float nextHeight = objHeight;
				float prevHeight = tex2D(_HeightMap, prevObjPoint).r * _HeightScale - _HeightScale;
				nextHeight -= rayHeight;
				prevHeight -= rayHeight - rayStep.y;
				float weight = nextHeight / (nextHeight - prevHeight);
				uv = lerp(nextObjPoint, prevObjPoint, weight);
				return tex2D(_MainTex, uv);
			}
			ENDCG
		}
	}
}

