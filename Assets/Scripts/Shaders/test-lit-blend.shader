Shader "test/test-lit-blend"
{
	Properties
	{
		[NoScaleOffset] _MainTex ("_blend_00", 2D) = "white" {}
		[NoScaleOffset] _blend_01 ("_blend_01", 2D) = "white" {}
		[NoScaleOffset] _blend_02 ("_blend_02", 2D) = "white" {}
		[NoScaleOffset] _blend_03 ("_blend_03", 2D) = "white" {}

		_Glossiness ("Smoothness", Range(0.0, 1.0)) = 0.5
		_Metallic ("Metallic", Range(0.0, 1.0)) = 0.0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows

		//! Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		#include "blend.cginc"

		struct Input
		{
			float2 uv_MainTex;
			float4 color : COLOR;
		};

		half _Glossiness;
		half _Metallic;

		sampler2D _MainTex;
		sampler2D _blend_01;
		sampler2D _blend_02;
		sampler2D _blend_03;
		
		UNITY_INSTANCING_BUFFER_START(Props)
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o)
		{
			float4 b0 = tex2D(_MainTex, IN.uv_MainTex);
			float4 b1 = tex2D(_blend_01, IN.uv_MainTex);
			float4 b2 = tex2D(_blend_02, IN.uv_MainTex);
			float4 b3 = tex2D(_blend_03, IN.uv_MainTex);
			fixed4 c = BlendMtx(b0, b1, b2, b3, IN.color);

			o.Albedo = c.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
