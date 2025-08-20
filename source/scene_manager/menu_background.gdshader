shader_type canvas_item;

uniform float Speed = 10.0;
uniform float LineThickness = 2.0;
uniform float Spacing = 55.0;
uniform vec4 LineColor:source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 BackgroundColor:source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment()
{
	float a = mod(FRAGCOORD.x-TIME*Speed, Spacing);
	float b = mod(FRAGCOORD.y+TIME*Speed, Spacing);

	COLOR = BackgroundColor;

	if ((a >= 0.0 && a <= LineThickness) || (b >= 0.0 && b <= LineThickness))
	{
		COLOR = LineColor;
	}
}