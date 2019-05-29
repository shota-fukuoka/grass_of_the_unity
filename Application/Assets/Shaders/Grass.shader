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
			[maxvertexcount(4)]
			void geom(point VSOut input[1], inout TriangleStream<VSOut> outStream)
			{
				VSOut output;

				// 全ての頂点で共通の値を計算しておく
				float4 pos = input[0].pos;
				float4 col = input[0].col;

				// 四角形になるように頂点を生産
				for (int x = 0; x < 2; x++)
				{
					for (int y = 0; y < 2; y++)
					{
						// ビルボード用の行列
						float4x4 billboardMatrix = UNITY_MATRIX_V;
						billboardMatrix._m03 =
							billboardMatrix._m13 =
							billboardMatrix._m23 =
							billboardMatrix._m33 = 0;

						// テクスチャ座標
						float2 tex = float2(x, y);
						output.tex = tex;

						// 頂点位置を計算
						output.pos = pos + mul(float4((tex * 2 - float2(1, 1)) * 0.2, 0, 1), billboardMatrix);
						output.pos = mul(UNITY_MATRIX_VP, output.pos);

						// 色
						output.col = col;

						// ストリームに頂点を追加
						outStream.Append(output);
					}
				}

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
