shader_type canvas_item;

uniform sampler2D dust_mask;

void fragment() {
    vec4 base = texture(TEXTURE, UV);
    float dust = texture(dust_mask, UV).r;

    vec3 dusty_color = mix(base.rgb, vec3(0.6, 0.6, 0.6), dust);

    COLOR = vec4(dusty_color, base.a);
}