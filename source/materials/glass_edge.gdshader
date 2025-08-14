shader_type spatial;
render_mode unshaded;

uniform vec3 color: source_color = vec3(1.0, 1.0, 1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if ((UV.x <= 0.04) || (UV.x >= 0.96) || (UV.y <= 0.04) || (UV.y >= 0.96))
	{
		ALBEDO = color;
	}
	else
	{
		ALPHA = 0.0;
	}
}
