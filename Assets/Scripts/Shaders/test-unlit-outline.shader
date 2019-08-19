Shader "test/test-unlit-outline"
{
	Properties
	{
		[NoScaleOffset] _base ("_base", 2D) = "white" {}
		_outline ("_outline", Color) = (0.5, 0.0, 1.0, 1.0)
		_distance ("_distance", float) = 0.01
	}

	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		
		Pass
		{
			Name "base"

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			sampler2D _base;
			float4 _base_ST;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _base);
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_base, i.uv);
				return col;
			}
			ENDCG
		}

		Pass
		{
			Name "cutout"

			Cull Back
			Zwrite On
			ZTest Greater
			Blend One One

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
			};

			float _distance;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				//discard;
				return fixed4(0.0, 0.0, 0.0, 0.0);
			}
			ENDCG
		}

		Pass
		{
			Name "outline"

			ZWrite Off
			ZTest GEqual

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float4 normal : NORMAL;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
			};

			float4 _outline;
			float _distance;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex + v.normal * _distance);
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				//discard;
				return _outline;
			}
			ENDCG
		}
	}
}
