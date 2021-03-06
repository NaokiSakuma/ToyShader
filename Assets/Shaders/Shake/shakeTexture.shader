﻿Shader "Unlit/shakeTexture" {
    Properties {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)
        [MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
        [HideInInspector] _RendererColor ("RendererColor", Color) = (1,1,1,1)
        [HideInInspector] _Flip ("Flip", Vector) = (1,1,1,1)
        [PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
        [PerRendererData] _EnableExternalAlpha ("Enable External Alpha", Float) = 0

        _SinWave("SinWave", Range(0, 1)) = 0.2
        _SinWidth("SinWidth", Range(0, 1)) = 0.5
        _SinSpeed("SinSpeed", Range(0, 1)) = 0.2
        _SinColorDistant("SinColorDistant", Range(0, 3)) = 0.2
		[Toggle] _IsHorizontal ("Is Horizontal", int) = 0
    }

    SubShader {
        Tags {
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "RenderType"="Transparent"
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
        }

        Cull Off
        Lighting Off
        ZWrite Off
        Blend One OneMinusSrcAlpha

        Pass {
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
            #pragma multi_compile_instancing
            #pragma multi_compile _ PIXELSNAP_ON
            #pragma multi_compile _ ETC1_EXTERNAL_ALPHA

			#include "UnityCG.cginc"

			#ifdef UNITY_INSTANCING_ENABLED
				UNITY_INSTANCING_BUFFER_START(PerDrawSprite)
                fixed4 unity_SpriteRendererColorArray[UNITY_INSTANCED_ARRAY_SIZE];
                float4 unity_SpriteFlipArray[UNITY_INSTANCED_ARRAY_SIZE];
				UNITY_INSTANCING_BUFFER_END(PerDrawSprite)
				#define _RendererColor unity_SpriteRendererColorArray[unity_InstanceID]
				#define _Flip unity_SpriteFlipArray[unity_InstanceID]
			#endif

			CBUFFER_START(UnityPerDrawSprite)
			#ifndef UNITY_INSTANCING_ENABLED
				fixed4 _RendererColor;
				float4 _Flip;
			#endif
			float _EnableExternalAlpha;
			CBUFFER_END

			fixed4 _Color;

			struct appdata_t {
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f {
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_OUTPUT_STEREO
			};

			v2f vert(appdata_t v) {
				v2f o;
				UNITY_SETUP_INSTANCE_ID (v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                #ifdef UNITY_INSTANCING_ENABLED
                    v.vertex.xy *= _Flip.xy;
                #endif
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = v.texcoord;
				o.color = v.color * _Color * _RendererColor;
				#ifdef PIXELSNAP_ON
                    o.vertex = UnityPixelSnap (o.vertex);
				#endif
				return o;
			}

			sampler2D _MainTex;
			sampler2D _AlphaTex;
			float _SinWave;
			float _SinWidth;
			float _SinSpeed;
			float _SinColorDistant;
			int _IsHorizontal;

			float _wave;
			float _speed;
			float _width;
			float _clrDis;

			/// <summary>
			/// UV値を係数に応じてズラす
			/// </summary>
			/// <param name="inUV">UV値</param>
			/// <param name="n">指数</param>
			float2 posColor(float2 inUV, float n) {
				float waveValueX = sin(inUV.y * _wave + _speed + _clrDis * n) * _width;
				float waveValueY = sin(inUV.x * _wave + _speed + _clrDis * n) * _width;
				// stepで縦に揺れるか横に揺れるかを決める
				return inUV + float2(waveValueX * step(1, _IsHorizontal), waveValueY * step(_IsHorizontal, 0));
			}

			fixed4 frag(v2f i) : SV_Target {
				fixed4 color = fixed4(0, 0, 0, 0);
				float2 inUV = i.texcoord;

				_wave = _SinWave * 100;
				_speed = _Time.y * _SinSpeed * 20.0;
				_width = _SinWidth * 0.2;
				_clrDis = _SinColorDistant * _SinWidth * 5;

				// 各色をズラす
				color.r = tex2D(_MainTex, posColor(inUV, 2)).r;
				color.g = tex2D(_MainTex, posColor(inUV, 1)).g;
				color.b = tex2D(_MainTex, posColor(inUV, 0)).b;
				// 透過画像対策でアルファ値もズレに合わせる
				color.a = (
						tex2D(_MainTex, posColor(inUV, 2)).a +
						tex2D(_MainTex, posColor(inUV, 1)).a +
						tex2D(_MainTex, posColor(inUV, 0)).a
					) / 3;

				color *= i.color;
				color.rgb *= color.a;
				return color;
			}
        ENDCG
        }
    }
}