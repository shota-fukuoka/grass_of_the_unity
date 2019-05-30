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

			struct Grass
			{
				float3 pos;
			};

			StructuredBuffer<Grass> GrassLand;

			struct VSOut {
				float4 pos : SV_POSITION;
				float2 tex : TEXCOORD0;
				float4 col : COLOR;
			};

			VSOut vert(uint id : SV_VertexID)
			{
				VSOut output;
				output.pos = float4(GrassLand[id].pos, 1);
				output.tex = float2(0, 0);
				output.col = float4(0,0,0,1);

				return output;
			}

			// ジオメトリシェーダ
			[maxvertexcount(3)]
			void geom(point VSOut input[1], inout TriangleStream<VSOut> outStream)
			{
				VSOut output;

				// 全ての頂点で共通の値を計算しておく
				float4 pos[3];
				pos[0] = float4(input[0].pos);
				pos[1] = float4(input[0].pos.x+0.5f, input[0].pos.y + 1, input[0].pos.z, input[0].pos.w);
				pos[2] = float4(input[0].pos.x + 1, input[0].pos.y, input[0].pos.z, input[0].pos.w);

				float4 col[3];
				col[0] = float4(0,0,0,1);
				col[1] = float4(0,1,0,1);
				col[2] = float4(0,0,0,1);


				// ビルボード用の行列
				float4x4 billboardMatrix = UNITY_MATRIX_V;
				billboardMatrix._m03 =
					billboardMatrix._m13 =
					billboardMatrix._m23 =
					billboardMatrix._m33 = 0;

				// テクスチャ座標
				float2 tex = float2(1, 1);
				output.tex = tex;

				// 頂点位置を計算
				output.pos = pos[0];
				output.pos = mul(UNITY_MATRIX_VP, output.pos);

				// 色
				output.col = col[0];

				// ストリームに頂点を追加
				outStream.Append(output);

				// 頂点位置を計算
				output.pos = pos[1];
				output.pos = mul(UNITY_MATRIX_VP, output.pos);

				// 色
				output.col = col[1];

				// ストリームに頂点を追加
				outStream.Append(output);

				// 頂点位置を計算
				output.pos = pos[2];
				output.pos = mul(UNITY_MATRIX_VP, output.pos);

				// 色
				output.col = col[2];

				// ストリームに頂点を追加
				outStream.Append(output);
				
				

				// トライアングルストリップを終了
				outStream.RestartStrip();
			}

			// ピクセルシェーダー
			fixed4 frag(VSOut i) : COLOR
			{
				// 出力はテクスチャカラーと頂点色
				float4 col = i.col;

				// アルファが一定値以下なら中断
				if (col.a < 0.3) discard;

				// 色を返す
				return col;
			}

			ENDCG
	
		}

    }
}
