//ShaderToy默认背景
Shader "taecg/ShaderToy/Default"
{
	SubShader
	{
		Pass
		{
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
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float3 col = 0.5 + 0.5*cos(_Time.y + i.uv.xyx + float3(0, 2, 4));
				float4 finalCol = float4(col, 1.0);
				return finalCol;
			}
			ENDCG
		}
	}
}