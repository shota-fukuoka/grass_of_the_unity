using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class grass_land : MonoBehaviour
{
    [SerializeField]
    GameObject m_grassObject;

    [SerializeField]
    int GRASS_MAX = 0;

    [SerializeField]
    float m_fGrassPos = 0;

    // Start is called before the first frame update
    void Awake()
    {
        for (int i = 0; i < GRASS_MAX; i++)
        {
            //float nPosX = Random.RandomRange(-m_fGrassPos, m_fGrassPos);
            //float nPosZ = Random.RandomRange(-m_fGrassPos, m_fGrassPos);

            float nPosX = Hulton(i, 2) * 100;
            float nPosZ = Hulton(i, 3) * 66;

            Instantiate(m_grassObject, new Vector3(nPosX, 0, nPosZ), Quaternion.identity);
        }
    }

    // Update is called once per frame
    void Update()
    {
        
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
