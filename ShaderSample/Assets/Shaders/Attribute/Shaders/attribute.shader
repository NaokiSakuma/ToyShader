Shader "Unlit/attribute" {
Properties {
    _MainTex ("Texture", 2D) = "white" {}
}

// 一覧用

// HideInInspector
// inspectorから値を非表示にする
// Properties {
//     _MainTex ("Texture", 2D) = "white" {}
//     [HideInInspector] _HideValue ("HideValue", int) = 0
//     _ShowValue ("ShowValue", int) = 0
// }

// NoScaleOffset
// ScaleとOffsetを非表示にする
// Properties {
//     [NoScaleOffset]_MainTex ("Texture", 2D) = "white" {}
// }

// Normal
// 法線マップかを判断する
// Properties {
//     [Normal]_MainTex ("Texture", 2D) = "white" {}
// }

// HDR
// HDRテクスチャかを確認する
// Properties {
//     [HDR]_MainTex ("Texture", 2D) = "white" {}
// }

// Gamma
// float,Vectorを色空間変換に適応させる
// Properties {
//     _MainTex ("Texture", 2D) = "white" {}
//     [Gamma] _GammaFloat ("Gamma Float", float) = 0
//     [Gamma] _GammaVector ("Gamma Vector", Vector) = (0, 0, 0, 0)
// }

// PerRendererData
// MaterialPropertyBlockクラスのインスタンス時の値で初期化
// Properties {
//     [PerRendererData]_MainTex ("Texture", 2D) = "white" {}
// }

// MainTexture
// 対象のプロパティをメインテクスチャとする
// Properties {
//     _MainTex ("Texture", 2D) = "white" {}
//     [MainTexture]_SubTex1 ("Sub Texture1", 2D) = "white" {}
//     // MainTextureと見なされない
//     [MainTexture]_SubTex2 ("Sub Texture2", 2D) = "white" {}
// }

// MainColor
// 対象のプロパティをメインカラーとする
// Properties {
//     _MainTex ("Texture", 2D) = "white" {}
//     _Color ("Color", Color) = (1, 1, 1, 1)
//     [MainColor]_SubColor1 ("Sub Color1", Color) = (1, 1, 1, 1)
//     // MainColorと見なされない
//     [MainColor]_SubColor2 ("Sub Color2", Color) = (1, 1, 1, 1)
// }

// Space
// 対象のプロパティの上にスペースを入れる
// Properties {
//     _MainTex ("Texture", 2D) = "white" {}
//     _NotSpace ("Not Space", int) = 0
//     [Space] _SpaceA ("Space A", int) = 0
//     [Space(50)] _SpaceB ("Space B", int) = 0
//     [Space(100)] _SpaceC ("Space C", int) = 0
// }

// Toggle
// int,floatをチェックボックスにする
// Properties {
//     _MainTex ("Texture", 2D) = "white" {}
//     [Toggle] _ToggleFlag ("Toggle Flag", int) = 0
// }

// MaterialToggle
// int,floatをチェックボックスにする
// Properties {
//     _MainTex ("Texture", 2D) = "white" {}
//     [MaterialToggle] _MaterialToggleFlag ("MaterialToggle Flag", int) = 0
// }

// Enum
// int,floatを列挙する
// Properties {
//     _MainTex ("Texture", 2D) = "white" {}
//     [Enum (ZERO, 0, ONE, 1, TWO, 2)] _Value ("Value", int) = 0
//     // namespace名.enum名でC#のenumを設定できる
//     [Enum (EnumTest.COLOR)] _Color ("Color", float) = 0
// }

// KeywordEnum
// キーワードにすることができるEnum
// Properties {
//     _MainTex ("Texture", 2D) = "white" {}
//     [KeywordEnum (RED, GREEN, BLUE)] _Color ("Color", float) = 0
// }

// IntRange
// 指定された範囲のint型のスライダーを表示
// Properties {
//     _MainTex ("Texture", 2D) = "white" {}
//     _RangeValue (" Range Value", Range(0, 1)) = 0
//     [IntRange] _IntRangeValue ("Int Range Value", Range(0, 1)) = 0
// }

// PowerSlider
// スライダーを指数関数的にする
// Properties {
//     _MainTex ("Texture", 2D) = "white" {}
//     [PowerSlider(0.1)] _SliderA ("Slider A", Range(0, 1)) = 0
//     [PowerSlider(1.0)] _SliderB ("Slider B", Range(0, 1)) = 0
//     [PowerSlider(2.0)] _SliderC ("Slider C", Range(0, 1)) = 0
// }

// Header
// ヘッダーを表示
// Properties {
//     _MainTex ("Texture", 2D) = "white" {}
//     [Header(Hoge Massage)]
//     _Bar ("Bar", int) = 0
//     [Header(Fuga Massage)]
//     _Doo ("Foo", int) = 0
// }

    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
