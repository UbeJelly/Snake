shader_type canvas_item;


uniform vec2 circle_position = vec2(0.5);
uniform float progress : hint_range(0.0, 1.0, 0.01) = 0.5;
uniform float smoothness : hint_range(0.0, 0.1, 0.01) = 0.03;
uniform vec3 background : source_color;
const float ratio = 1.0;


void fragment()
{
	float r = ratio;
	vec2 position = circle_position * vec2(r, 1.0);
	vec2 new_uv = UV * vec2(r, 1.0);

	float far_x = float(circle_position.x < 0.5) * r;
	float far_y = float(circle_position.y < 0.5);
	float r_max = distance(position, vec2(far_x,far_y));

	float newprogress = r_max * (1.0 - progress);
	float f = mix(newprogress, newprogress + smoothness, newprogress);
	float mask = smoothstep(newprogress, f, distance(new_uv, position));

	COLOR = vec4(background, mask);
}
