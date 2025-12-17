shader_type spatial;
render_mode unshaded;

uniform float resolution = 800.0;
uniform float outline_darkness : hint_range(0.0, 1.0) = 0.8;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D depth_texture : hint_depth_texture, repeat_disable, filter_nearest;

vec2 pixel_to_uv_space(vec2 pixel, vec2 viewport_size) {
	
	pixel /= resolution;
	pixel /= normalize(viewport_size);
	return pixel;
}

void fragment() {
	
	vec2 uv = SCREEN_UV * resolution * normalize(VIEWPORT_SIZE);
	uv = floor(uv);
	
	// now UV is in pixel space
	
	// if area around is cumutively significantly more behind than us, become black
	vec3 color;
	
	float d = texture(depth_texture, pixel_to_uv_space(uv, VIEWPORT_SIZE)).r;
	
	d -= texture(depth_texture, pixel_to_uv_space(uv + vec2(1.0, 0.0), VIEWPORT_SIZE)).r / 4.0;
	d -= texture(depth_texture, pixel_to_uv_space(uv - vec2(1.0, 0.0), VIEWPORT_SIZE)).r / 4.0;
	d -= texture(depth_texture, pixel_to_uv_space(uv + vec2(0.0, 1.0), VIEWPORT_SIZE)).r / 4.0;
	d -= texture(depth_texture, pixel_to_uv_space(uv - vec2(0.0, 1.0), VIEWPORT_SIZE)).r / 4.0;
	
	color = vec3(1.0 - step(0.00002, d) * outline_darkness) * texture(screen_texture, pixel_to_uv_space(uv, VIEWPORT_SIZE)).rgb;
	
    ALBEDO = color;
}