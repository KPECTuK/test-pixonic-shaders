Shader "test/test-lit-outline"
{
	Properties
	{
		_outline ("_outline", Color) = (0.5, 0.0, 1.0, 1.0)
		_distance ("_distance", float) = 0.05

		_MainTex ("Albedo (RGB)", 2D) = "white" {}
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

		struct Input
		{
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;

		sampler2D _MainTex;

		UNITY_INSTANCING_BUFFER_START(Props)
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o)
		{
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG

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
	FallBack "Diffuse"
}
