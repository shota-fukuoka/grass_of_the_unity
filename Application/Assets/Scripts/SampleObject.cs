using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SampleObject : MonoBehaviour
{
    [SerializeField]
    private ComputeShader m_ComputeShader = null;

    [SerializeField]
    private Transform m_SampleGameObject = null;

    private ComputeBuffer m_Buffer = null;

    // Start is called before the first frame update
    void Start()
    {
        m_Buffer = new ComputeBuffer(1, sizeof(float));

        m_ComputeShader.SetBuffer(0, "Result", m_Buffer);
    }

    // Update is called once per frame
    void Update()
    {
        m_ComputeShader.SetFloat("positionX", m_SampleGameObject.position.x);

        m_ComputeShader.Dispatch(0, 8, 8, 1);

        var data = new float[1];

        m_Buffer.GetData(data);

        float positionX = data[0];

        var boxPosition = m_SampleGameObject.position;
        boxPosition.x = positionX;
        m_SampleGameObject.position = boxPosition;
    }

    private void OnDestroy()
    {
        m_Buffer.Release();
    }
}
