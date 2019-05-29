using System.Collections;
using System.Collections.Generic;
using UnityEngine;

class grass
{
    private Vector3 m_pos;

    public Vector3 Position
    {
        get { return this.m_pos; }
        set { this.m_pos = value; }
    }

    public grass(Vector3 pos)
    {
        this.m_pos = pos;
    }

}
