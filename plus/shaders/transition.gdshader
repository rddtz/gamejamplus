shader_type canvas_item;

uniform float progress : hint_range(0,1);
uniform float pixel_size = 15.0;



void fragment()
{
	//Tipo Diamante Pixel
	float xFraction = fract(FRAGCOORD.x / pixel_size);
	float yFraction = fract(FRAGCOORD.y / pixel_size);

	float xDistance = abs(xFraction - 0.5);
	float yDistance = abs(yFraction - 0.5);

	if (xDistance + yDistance + UV.x + UV.y > progress * 4.0)
	{
		discard;
	}
}
