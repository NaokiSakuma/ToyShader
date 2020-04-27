Shader "Unlit/rotateOutline" {
    Properties {
        _MainTex ("Base (RGB), Alpha (A)", 2D) = "white" {}
        _BlurColor ("Blur Color", Color) = (1, 1, 1, 1)
        _BlurSize ("Blur Size", float) = 1

        _Speed ("Speed", float) = 1
        _Angle ("Angle", Range(0, 1)) = 1
        _OffSet("xy : offset, zw : notUseing", Vector) = (0.5,0.5,0,0)
    }

    CGINCLUDE
    // passで共通処理をまとめる
    struct appdata {
        float4 vertex   : POSITION;
        float2 texcoord : TEXCOORD0;
    };

    struct v2f {
        float4 vertex   : SV_POSITION;
        half2 texcoord  : TEXCOORD0;
        float4 worldPosition : TEXCOORD1;
    };

    #include "UnityCG.cginc"

    sampler2D _MainTex;
    // MainTexのサイズを扱う
    // x : 1.0 / width
    // y : 1.0 / height
    // z : width
    // w : height
    float4 _MainTex_TexelSize;
    fixed4 _BlurColor;
    float _BlurSize;
    half _Speed;
    half _Angle;
    fixed4 _OffSet;

    static const float PI = 3.14159265;

    v2f vert (appdata v) {
        v2f o;
        o.worldPosition = v.vertex;
        o.vertex = UnityObjectToClipPos(o.worldPosition);
        o.texcoord = v.texcoord;
        return o;
    }

    fixed4 frag(v2f v) : SV_Target {
        half4 color = (tex2D(_MainTex, v.texcoord));
        return color;
    }

    fixed4 frag_blur (v2f v) : SV_Target {
        // -1 ~ 1でforを回す
        int k = 1;
        float2 blurSize = _BlurSize * _MainTex_TexelSize.xy;
        float blurAlpha = 0;
        float2 tempCoord = float2(0,0);
        float tempAlpha;
        // xy方向にblurSize分ズラし、アルファ値を計算
        for (int px = -k; px <= k; px++) {
            for (int py = -k; py <= k; py++) {
                tempCoord = v.texcoord;
                tempCoord.x += px * blurSize.x;
                tempCoord.y += py * blurSize.y;
                tempAlpha = tex2D(_MainTex, tempCoord).a;
                blurAlpha += tempAlpha;
            }
        }
        half4 blurColor = _BlurColor;
        half timeAngle = _Time.y * _Speed;
        // 回転座標
        half2x2 rotate = half2x2(cos(timeAngle), -sin(timeAngle), sin(timeAngle), cos(timeAngle));
        // 回転の中心座標
        float2 offsetUv = v.texcoord - _OffSet.xy;
        // timeAngle回転させたときの座標
        offsetUv = mul(rotate, offsetUv);
        // アルファ値を0or1に
        offsetUv = step(offsetUv, 0);
        blurColor.a *= offsetUv;
        return blurColor;
    }
    ENDCG

    SubShader {
        Tags {
            "Queue"="Transparent"
            // プロジェクターの影響を受けないように
            "IgnoreProjector"="True"
            "RenderType"="Transparent"
            // マテリアルのincpecterでの表示をplaneに
            "PreviewType"="Plane"
            // spriteに不具合がある場合にfalseになる
            "CanUseSpriteAtlas"="True"
        }

        Cull Off
        Lighting Off
        ZWrite Off
        // CanvasのRenderModeによって動的に変化
        // Screen Space - Overlay : Always
        // Screen Space - Camera : LEqual
        // World Space : LEqual
        ZTest [unity_GUIZTestMode]
        Blend SrcAlpha OneMinusSrcAlpha

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag_blur
            ENDCG
        }
    }
}





        // half uvAngle = atan2(offsetUv.y, offsetUv.x);
        // half tolerance = (-_Angle + 0.5) * 2 * PI;
        // int angleStep = step(uvAngle, tolerance);
        // offsetUv *= (offsetUv.xy * angleStep);
        // offsetUv = offsetUv * step(0.001, blurAlpha);

        // Pass {
        //     CGPROGRAM
        //     #pragma vertex vert
        //     #pragma fragment frag
        //     ENDCG
        // }
