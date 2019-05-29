using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Runtime.InteropServices;

public class grass_land : MonoBehaviour
{
    private grass m_grass;

    [SerializeField]
    private Shader m_grassShader;

    [SerializeField]
    private ComputeShader m_grassComputeShader;

    Material m_grassMaterial;

    ComputeBuffer m_grassComputeBuffer;

    [SerializeField]
    int GRASS_MAX = 0;

    [SerializeField]
    float m_fGrassPos = 0;

    struct Grass
    {

        private Vector3 m_pos;

        public Vector3 Position
        {
            get { return this.m_pos; }
            set { this.m_pos = value; }
        }

        public Grass(Vector3 pos)
        {
            this.m_pos = pos;
        }
    }

    // Start is called before the first frame update
    void Awake()
    {
        m_grassMaterial = new Material(m_grassShader);


        InitComputeBuffer();
        //for (int i = 0; i < GRASS_MAX; i++)
        //{
        //    //float nPosX = Random.RandomRange(-m_fGrassPos, m_fGrassPos);
        //    //float nPosZ = Random.RandomRange(-m_fGrassPos, m_fGrassPos);
        //
        //    float nPosX = Hulton(i, 2) * 100;
        //    float nPosZ = Hulton(i, 3) * 66;
        //
        //    Instantiate(m_grassObject, new Vector3(nPosX, 0, nPosZ), Quaternion.identity);
        //}
    }

    void OnDisable()
    {
        m_grassComputeBuffer.Release();
    }

    void InitComputeBuffer()
    {
        m_grassComputeBuffer = new ComputeBuffer(GRASS_MAX, Marshal.SizeOf(typeof(Vector3)));

        Grass[] grassland = new Grass[m_grassComputeBuffer.count];

        for (int i = 0; i < m_grassComputeBuffer.count; i++)
        {
            float nPosX = Hulton(i, 2) * m_fGrassPos;
            float nPosZ = Hulton(i, 3) * m_fGrassPos;

            grassland[i] = new Grass(new Vector3(nPosX, 0, nPosZ));
        }

        m_grassComputeBuffer.SetData(grassland);
    }

    // Update is called once per frame
    void Update()
    {
        //m_grassComputeShader.SetBuffer(0, "Grass", m_grassComputeBuffer);
        //m_grassComputeShader.SetFloat("DeltaTime", Time.deltaTime);
        //m_grassComputeShader.Dispatch(0, m_grassComputeBuffer.count / 8 + 1, 1, 1);
    }

    void OnRenderObject()
    {
        m_grassMaterial.SetBuffer("GrassLand", m_grassComputeBuffer);

        m_grassMaterial.SetPass(0);

        Graphics.DrawProceduralNow(MeshTopology.Points, m_grassComputeBuffer.count);
    }

    float Hulton(int X, int n)
    {
        float Y = 0;
        float digit = 0;

        float half = 1.0f / n;

        do
        {
            digit = X % n;

            Y = Y + digit * half;
            X = (int)((X - digit) / n);
            half = half / n;

        } while (X != 0);

        return Y;
    }

    int DecimalConversion(int nNumber, int nDecimal1, int nDecimal2)
    {
        int ans = 0;

        for (int i = 0; nNumber > 0; i++)
        {
            ans = (int)(ans + (nNumber % nDecimal1) * Mathf.Pow(nDecimal2, i));
            nNumber = nNumber / nDecimal1;
        }

        return ans;
    }

    int GetReverseNumber(int nNumber)
    {
        int nReverse = 0;

        while (nNumber > 0)
        {
            nReverse++;
            nNumber /= 10;
        }

        return nReverse;
    }
}
