shader_type sky;
render_mode use_half_res_pass;

void fragment() {
    if (AT_CUBEMAP_PASS) {
        COLOR = vec3(1.0); // Reflections will be all white.
    } else if (AT_HALF_RES_PASS) {
        vec4 col = generate_fancy_clouds(EYEDIR, TIME); // Clouds will be rendered to half res texture.
        COLOR = col.rgb;
        ALPHA = col.a; // Subpasses can use alpha.
    } else {
        COLOR = HALF_RES_COLOR; // Background will read from HALF_RES_PASS.
    }
}
