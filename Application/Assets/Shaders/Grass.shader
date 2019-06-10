// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/Grass"
{
    SubShader
    {
		ZWrite On
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM
			
			#pragma target 5.0

			#pragma vertex vert
			#pragma geometry geom
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct VSIn
			{
				float4 pos : POSITION;
				float3 nor : NORMAL;
				float4 tan : TANGENT;
			};

			float DeltaTime;

			StructuredBuffer<VSIn> VSInput;

			struct VSOut {
				float4 pos : SV_POSITION;
				float3 nor : NORMAL;
				float4 tan : TANGENT;
			};

			VSOut vert(uint id : SV_VertexID)
			{
				VSOut output;
				output.pos = VSInput[id].pos;
				output.nor = VSInput[id].nor;
				output.tan = VSInput[id].tan;
			
				return output;
			}

			struct GSOut
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCODE0;
			};

			GSOut VertexOutput(float3 pos, float2 uv)
			{
				GSOut output;
				output.pos = UnityObjectToClipPos(pos);
				output.uv = uv;
				return output;
			}

			// ジオメトリシェーダ
			[maxvertexcount(3)]
			void geom(point VSOut input[1], inout TriangleStream<GSOut> outStream)
			{
				GSOut output;

				float3 pos = input[0].pos;

				float3 vNormal = input[0].nor;
				float4 vTangent = input[0].tan;
				float3 vBinormal = cross(vNormal, vTangent) * vTangent.w;

				float3x3 tangentToLocal = float3x3(
					vTangent.x, vBinormal.x, vNormal.x,
					vTangent.y, vBinormal.y, vNormal.y,
					vTangent.z, vBinormal.z, vNormal.z
					);

				outStream.Append(VertexOutput(pos + mul(tangentToLocal, float3(-0.5, 0, 0)), float2(0,0)));
				outStream.Append(VertexOutput(pos + mul(tangentToLocal, float3(0, 0, 1)), float2(0.5, 1)));
				outStream.Append(VertexOutput(pos + mul(tangentToLocal, float3(0.5, 0, 0)),float2(1, 0)));
				outStream.RestartStrip();
			}

			// ピクセルシェーダー
			fixed4 frag(GSOut i, fixed facing : VFACE) : SV_Target
			{
				return lerp(float4(0,1,0,1), float4(1,1,0,1), i.uv.y);
			}

			ENDCG
	
		}

    }
}
