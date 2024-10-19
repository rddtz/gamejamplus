shader_type canvas_item;
render_mode unshaded, skip_vertex_transform;

const float curvature = 7.0; //7.0
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
const float height = 180.0;
const float width = 1280.0;
const float vignette_multipllier = 0.3;

void fragment() {
	//Distorcao
	vec2 centered_uv = SCREEN_UV * 2.0 - 1.0;
	vec2 uv_offset = centered_uv.yx / curvature;
	vec2 warped_uv = centered_uv + centered_uv * uv_offset * uv_offset;
	vec3 cutoof = vec3(step(abs(warped_uv.x), 1.0) * step(abs(warped_uv.y), 1.0));
	
	//Scanlines
	vec3 scanlines = vec3(sin(2.0 * warped_uv.y * height) * 0.25 + .5);//.1 + .8
	
	//Vinheta
	vec3 vignette = vec3(length(pow(abs(centered_uv), vec2(4.0)) / 3.0));
	
	vec3 screen_color = textureLod(screen_texture, (warped_uv + 1.0) / 2.0, .1).rgb * cutoof * scanlines;
	screen_color -= vignette * vignette_multipllier;
	
	COLOR = vec4(screen_color, 1.0);
	
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
