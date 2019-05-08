Shader "Outlined/Silhouette Only Uniform" {
	Properties {
		_OutlineColor ("Outline Color", Color) = (0,0,0,1)
		_OutlineWidth ("Outlines width", Range (0.0, 2.0)) = 1.1
	}
 
CGINCLUDE
#include "UnityCG.cginc"
 
struct appdata {
	float4 vertex : POSITION;
	float3 normal : NORMAL;
};
 
struct v2f {
	float4 pos : POSITION;
	float4 color : COLOR;
};
 
uniform float _OutlineWidth;
uniform float4 _OutlineColor;
 
ENDCG
 
	SubShader {
		Tags { "Queue" = "Transparent" }
 
		Pass {
			Name "BASE"
			Cull Back
			Blend Zero One
 
			// uncomment this to hide inner details:
			//Offset -8, -8
 
			SetTexture [_OutlineColor] {
				ConstantColor (0,0,0,0)
				Combine constant
			}
		}
 
		// note that a vertex shader is specified here but its using the one above
		Pass {
			Name "OUTLINE"
			Tags { "LightMode" = "Always" }
			Cull Front
 
			// you can choose what kind of blending mode you want for the outline
			//Blend SrcAlpha OneMinusSrcAlpha // Normal
			//Blend One One // Additive
			Blend One OneMinusDstColor // Soft Additive
			//Blend DstColor Zero // Multiplicative
			//Blend DstColor SrcColor // 2x Multiplicative
 
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            v2f vert(appdata v) {
                appdata original = v;
                v.vertex.xyz += _OutlineWidth * normalize(v.vertex.xyz);

                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.color = _OutlineColor;
                return o;
            }

            half4 frag(v2f i) :COLOR {
                return i.color;
            }
            ENDCG
		}
 
 
	}
 
	Fallback "Diffuse"
}
