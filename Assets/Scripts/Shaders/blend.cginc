#ifndef TEST_BLEND
#define TEST_BLEND

inline float4 BlendMtx(float4 b0, float4 b1, float4 b2, float4 b3, float4 color)
{
	matrix<float, 4, 4> sp =
	{
		b0.r, b1.r, b2.r, b3.r,
		b0.g, b1.g, b2.g, b3.g,
		b0.b, b1.b, b2.b, b3.b,
		b0.a, b1.a, b2.a, b3.a
	};
	return mul(sp, color);
}

inline float4 BlendOps(float4 b0, float4 b1, float4 b2, float4 b3, float4 color)
{
	return
		b0 * color.r +
		b1 * color.g +
		b2 * color.b +
		b3 * (1.0 - color.r - color.g - color.b);

}

#endif // TEST_BLEND
