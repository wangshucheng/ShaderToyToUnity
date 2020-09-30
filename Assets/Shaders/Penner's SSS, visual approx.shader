// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "ShaderToy/Penner's SSS, visual approx"{
	Properties{
		_Mouse("MousepPos", Range(0,1)) = 0
	}
	SubShader{

		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 screenCoord : TEXCOORD1;
			};

			v2f vert (appdata v){
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				o.screenCoord.xy = ComputeScreenPos(o.vertex);
				return o;
			}
			
			float _Mouse;
			
			// Enable the one bellow to show the LUT
			//#define SHOW_LUT


			// simpler approximation
			//#define SIMPLE_APPROX


			float3 sss(float ndl, float ir)
			{
				float pndl = clamp(ndl, 0.0, 1.0);
				float nndl = clamp(-ndl, 0.0, 1.0);

				return float3(pndl, pndl, pndl) +
			#ifndef SIMPLE_APPROX
					float3(1.0, 0.1, 0.01)*0.2*(1.0 - pndl)*(1.0 - pndl)*pow(1.0 - nndl, 3.0 / (ir + 0.001))*clamp(ir - 0.04, 0.0, 1.0);
			#else
					float3(1.0, 0.1, 0.01)*0.7*pow(clamp(ir*0.75 - nndl, 0.0, 1.0), 2.0);
			#endif
			}

			fixed4 frag(v2f i) : SV_Target
			{
			#ifdef SHOW_LUT
				float2 p = fragCoord / _ScreenParams.xy;
				float3 col = sss(-1.0 + 2.0*p.x, p.y);
			#else    
				float2 p = (-_ScreenParams.xy + 2.0*i.screenCoord.xy * _ScreenParams.xy) / _ScreenParams.y;

				float an = 2.0 + 0.5*_Time.y;

				float3 ww = float3(cos(an), 0.0, sin(an));
				float3 uu = float3(-ww.z, 0.0, ww.x);
				float3 vv = float3(0.0, 1.0, 0.0);
				float3 ro = -2.5*ww;

				float3 rd = normalize(p.x*uu + p.y*vv + 1.5*ww);

				float3 col = float3(0.0, 0.0, 0.0);

				float b = dot(rd, ro);
				float c = dot(ro, ro) - 1.0;
				float h = b*b - c;
				if (h>0.0)
				{
					float t = -b - sqrt(h);
					float3 pos = ro + t*rd;
					float3 nor = normalize(pos);
					const float r = 0.5;  // curvature
					col = float3(1.0, 0.9, 0.8) * sss(dot(nor, float3(0.57703, 0.57703, 0.57703)), r);
				}
			#endif

				col = pow(col, float3(0.4545,0.4545,0.4545));


				return float4(col, 1.0);
			}
				
			ENDCG
		}
	}
}
