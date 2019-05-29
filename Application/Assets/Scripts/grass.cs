using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class grass : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        Mesh mesh = new Mesh();
        mesh.vertices = new Vector3[] {
            new Vector3(-0.25f, -1.0f, 0),
            new Vector3(0.0f, 1.0f, 0),
            new Vector3(0.25f, -1.0f, 0),
        };

        mesh.triangles = new int[] { 0, 1, 2 };



        mesh.colors = new Color[] {
            new Color(0.0f, 0.0f, 0.0f),
            new Color(0.0f, 1.0f, 0.0f),
            new Color(0.0f, 0.0f, 0.0f),
        };

        GetComponent<MeshFilter>().sharedMesh = mesh;
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
