shader_type canvas_item;

uniform sampler2D screen_txt: hint_screen_texture, filter_linear_mipmap;
uniform float blur: hint_range(0, 5);

void fragment() {
	vec4 color = texture(screen_txt, SCREEN_UV, blur);
	COLOR = color;
}
