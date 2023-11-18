shader_type canvas_item;

uniform float inside_radius: hint_range(0.0, 1.0) = .6;
uniform float outside_radius: hint_range(0.0, 1.0) = .9;
uniform float lifetime: hint_range(0.0, 1.0);
uniform float power: hint_range(0.0, 1.0);

bool in_range(float x, float left, float right) {
	return x >= left && x <= right;
}

void fragment() {
	float mid_radius = (inside_radius + outside_radius) / 2.; // Middle ring
	float dist_to_origin = 2. * distance(UV, vec2(.5, .5));
	
	COLOR.a = float(in_range(dist_to_origin, inside_radius, outside_radius)) * (1. - pow(abs(dist_to_origin - mid_radius), power));
	COLOR.r = 1. - lifetime;
	COLOR.g = lifetime;
	COLOR.b = 0.;
}
