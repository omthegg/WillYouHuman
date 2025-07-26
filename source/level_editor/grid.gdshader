shader_type spatial;
render_mode cull_disabled;

// source: https://godotshaders.com/shader/simple-world-triplanar-grid-allows-transparency/

uniform float line_width : hint_range(0.0, 1.0) = 0.04;
uniform float grid_size : hint_range(0.0, 10.0) = 1.0;
uniform vec4 line_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 fill_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
	// Calculate world position
	vec3 world_pos = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;

	// Apply grid effect
	vec2 grid_pos = mod(world_pos.xz + grid_size * 0.5, grid_size) / grid_size - 0.5;
	grid_pos = abs(grid_pos) * 2.0;
	float line = min(step(line_width, grid_pos.x), step(line_width, grid_pos.y));

	// Apply color and transparency
	ALBEDO = mix(line_color.rgb, fill_color.rgb, line);
	ALPHA = mix(line_color.a, fill_color.a, line);
}