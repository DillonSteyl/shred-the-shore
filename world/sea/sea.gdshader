shader_type spatial;
render_mode depth_prepass_alphas;

uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;
uniform vec4 color: source_color;
uniform float roughness = 0.2;

uniform sampler2D normalmap_a : hint_normal;
uniform sampler2D normalmap_b : hint_normal;
uniform sampler2D height_texture;
uniform sampler2D uv_sampler;

uniform float normalmap_a_strength = 0.3;
uniform float normalmap_b_strength = 0.4;
uniform float uv_sampler_scale = 0.3;
uniform float noise_scale = 0.1;
uniform float height_strength = 1.0;

varying vec3 world_position;


void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	vec4 height = texture(
		height_texture,
		(world_position.xz * 0.003) + 0.005 * TIME * vec2(1.0, 1.0)
	);
	VERTEX.y += height.r * height_strength;
}

void fragment() {
	vec2 uv = 0.01 * world_position.xz;
	vec2 uv_movement = vec2(1, 1) * TIME * 0.01;
	vec3 normalmap = texture(normalmap_a, uv + uv_movement).rgb * normalmap_a_strength;
	normalmap += texture(normalmap_b, uv - uv_movement).rgb * normalmap_b_strength;

	ALBEDO = color.rgb;
	ALPHA = 0.5;
	ROUGHNESS = roughness;
	NORMAL = normalmap;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
