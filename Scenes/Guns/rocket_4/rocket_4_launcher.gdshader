shader_type canvas_item;

uniform vec4 flame_start_color : source_color;
uniform vec4 flame_end_color : source_color;
uniform sampler2D noise; // OpenSimplexNoise in editor
uniform float speed=12.5;
uniform float flame_dir=0.0;
uniform float flame_size=0.2;
uniform float hardlight_treshold=0.9;
uniform float color_treshold=0.6;
const vec2 center = vec2(0.5,0.9);

vec2 rotateUV(vec2 uv, vec2 pivot, float rotation) {
    float sine = sin(rotation*0.9);
    float cosine = cos(rotation*0.7);

    uv -= pivot;
    uv.x = uv.x * cosine - uv.y * sine;
    uv.y = uv.x * sine + uv.y * cosine;
    uv += pivot;

    return uv;
}


float egg_shape(vec2 coord, float radius,float rotation){
	float ccdist =  distance(coord,center);
	//smoothstep(-2.0,0.9,rotation-(coord.y));
	coord = rotateUV(coord,center,ccdist*rotation);
	vec2 diff = abs(coord - center);

	if (coord.y < center.y){
		diff.y /= 3.0;
	} else {
		diff.y *= 1.3;
	}
	float dist = sqrt(diff.x * diff.x + diff.y * diff.y) / radius;
	float value = sqrt(1.0 - dist * dist);
//	value = clamp(value, 0.0, 1.0);
	value = smoothstep(0.2,1.2,value);
	return value;
}


float hardlight(float val) {
	val*=smoothstep(0.2,0.4,val);
	return val;
}

void fragment() {
	COLOR = mix(flame_start_color,flame_end_color,distance(UV,center)*color_treshold);
	vec2 uv = UV;
	vec4 n = texture(noise,uv+(vec2(0.0,1.0)*TIME*speed));
	COLOR.a = hardlight(egg_shape(uv,flame_size,flame_dir)*(n.x+n.y)/hardlight_treshold);
}