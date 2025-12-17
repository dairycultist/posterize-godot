shader_type spatial;

uniform sampler2D albedo : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = texture(albedo, UV).rgb;
}

void light() {
    DIFFUSE_LIGHT += step(0.3, clamp(dot(NORMAL, LIGHT), 0.0, 1.0) * ATTENUATION * LIGHT_COLOR / PI);
}
