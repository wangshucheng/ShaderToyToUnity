using System;
using UnityEngine;

[ExecuteInEditMode]
public class ShaderToyController : MonoBehaviour
{
    public Shader shaderToy;    //要显示的Shader
    private Material shaderToyMaterial = null;      //显示Shader的材质球

    public Material Material
    {
        get
        {
            shaderToyMaterial = GetMat(shaderToy, shaderToyMaterial);
            return shaderToyMaterial;
        }
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, Material);
    }

    Material GetMat(Shader shader, Material material)
    {
        //如果Shader为空，返回空
        if (shader == null)
        {
            return null;
        }

        //如果Shader不被支持，则返回空
        if (!shader.isSupported)
        {
            return null;
        }
        else
        {   //用此Shader创建临时材质，并返回
            material = new Material(shader)
            {
                hideFlags = HideFlags.DontSave
            };
            return material;
        }
    }
	
	private bool _isDragging = false;
	
	void Start () {
		_isDragging = false;
    }
	
	void Update () {
        Vector3 mousePosition = Vector3.zero;
        if (_isDragging) {
            mousePosition = new Vector3(Input.mousePosition.x, Input.mousePosition.y, 1.0f);
        } else {
            mousePosition = new Vector3(Input.mousePosition.x, Input.mousePosition.y, 0.0f);
        }

        if (shaderToyMaterial != null) {
            shaderToyMaterial.SetVector("iMouse", mousePosition);
        }
    }

    void OnMouseDown() {
        _isDragging = true;
    }

    void OnMouseUp() {
        _isDragging = false;
    }
}