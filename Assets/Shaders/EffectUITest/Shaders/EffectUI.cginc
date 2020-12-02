#ifndef UI_EFFECT_INCLUDED
#define UI_EFFECT_INCLUDED

#if GRAYSCALE
#define UI_TOPNE
#endif

// Unpack float to low-precision [0-1] half2.
half2 UnpackToVec2(float value) {
	const int PACKER_STEP = 4096;
	const int PRECISION = PACKER_STEP - 1;
	half2 unpacked;

	unpacked.x = (value % (PACKER_STEP)) / (PACKER_STEP - 1);
	value = floor(value / (PACKER_STEP));

	unpacked.y = (value % PACKER_STEP) / (PACKER_STEP - 1);
	return unpacked;
}

fixed4 ApplyToneEffect(fixed4 color, fixed factor) {
    #ifdef GRAYSCALE
    color.rbg = lerp(color.rbg, Luminance(color.rgb), factor)
    #endif
    return color;
}