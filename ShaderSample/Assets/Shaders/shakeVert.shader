Shader "Unlit/shakeVert" {
	Properties{
		_Color("Color", Color) = (1, 1, 1, 1)
	}
		SubShader{
			Tags{
			"Queue" = "Geometry"
			"RenderType" = "Opaque"
		}

		Pass {

			CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag

			fixed4 _Color;

struct appdata {
	float4 vertex : POSITION;
};

struct v2f {
	float4 vertex : SV_POSITION;
};

v2f vert(appdata v) {
	v2f o;
	o.vertex = UnityObjectToClipPos(v.vertex);
	float amp = 0.5f * sin(_Time * 100 + v.vertex.x * 100);
	o.vertex.xyz = float3(v.vertex.x, v.vertex.y + amp, v.vertex.z);
	return o;
}

fixed4 frag(v2f i) :SV_Target {
	return _Color;
}
ENDCG
}
}
}