Shader "test/test-unlit-blend"
{
	Properties
	{
		[NoScaleOffset] _blend_00 ("_blend_00", 2D) = "white" {}
		[NoScaleOffset] _blend_01 ("_blend_01", 2D) = "white" {}
		[NoScaleOffset] _blend_02 ("_blend_02", 2D) = "white" {}
		[NoScaleOffset] _blend_03 ("_blend_03", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "blend.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float4 color : color0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float4 color : COLOR0;
			};

			sampler2D _blend_00;
			float4 _blend_00_ST;
			sampler2D _blend_01;
			float4 _blend_01_ST;
			sampler2D _blend_02;
			float4 _blend_02_ST;
			sampler2D _blend_03;
			float4 _blend_03_ST;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _blend_00);
				o.color = normalize(v.color);
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				float4 b0 = tex2D(_blend_00, i.uv);
				float4 b1 = tex2D(_blend_01, i.uv);
				float4 b2 = tex2D(_blend_02, i.uv);
				float4 b3 = tex2D(_blend_03, i.uv);
				return BlendMtx(b0, b1, b2, b3, i.color);
			}
			ENDCG
		}
	}
}
