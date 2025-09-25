shader_type canvas_item;

uniform sampler2D noise_texture;
uniform sampler2D gradient;
uniform vec2 scroll_speed;
uniform float alpha_gate: hint_range(0.0, 1.0, 0.05) = 0.5;

void fragment() {
	vec2 scroll_offset = TIME * scroll_speed;
	vec2 noise_uv = mod(UV + scroll_offset, vec2(1,1));
	float new_alpha = mix(texture(noise_texture, noise_uv).r, texture(gradient, UV).a, 0.5);
	COLOR.a = mix(0,1, float(new_alpha > alpha_gate));
}