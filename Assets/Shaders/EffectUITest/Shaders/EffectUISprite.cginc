#ifndef UI_EFFECT_SPRITE_INCLUDED
#define UI_EFFECT_SPRITE_INCLUDED

fixed4 _Color;
fixed4 _TextureSampleAdd;
float4 _ClipRect;
sampler2D _MainTex;
float4 _MainTex_TexelSize;

struct appdata_t {
	float4 vertex   : POSITION;
	float4 color    : COLOR;
	float2 texcoord : TEXCOORD0;
	UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct v2f {
	float4 vertex   : SV_POSITION;
	fixed4 color    : COLOR;
	half2 texcoord  : TEXCOORD0;
	float4 worldPosition : TEXCOORD1;
	half eParam	: TEXCOORD2;
	UNITY_VERTEX_OUTPUT_STEREO
};

v2f vert(appdata_t IN) {
	v2f OUT;
	UNITY_SETUP_INSTANCE_ID(IN);
	UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
	OUT.worldPosition = IN.vertex;
	OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

	OUT.texcoord = UnpackToVec2(IN.texcoord.x) * 2 - 0.5;

	OUT.color = IN.color * _Color;
	OUT.eParam = IN.texcoord.y;

	return OUT;
}

#endif
