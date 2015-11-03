// by Nikos Papadopoulos, 4rknova / 2014
// Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

#ifdef GL_ES
precision highp float;
#endif

#define EPS .001

#define ANIMATE

#define FLAG_GR_PROP      3./2.
#define FLAG_GR_COL_BLUE  vec3(.14117647058, .25098039215, .94901960784)
#define FLAG_GR_COL_WHITE vec3(1)

vec3 flag_gr(in vec2 p) {
    if (p.x > FLAG_GR_PROP || p.x < 0. ||
        p.y > 1. || p.y <0.) return vec3(0.);
    
    float f = texture2D( iChannel0, vec2(p.x*(2.0/3.0),0.75) ).x;
    
    vec3 c = FLAG_GR_COL_BLUE;

    if (abs(f-p.y) < 0.05)
        c = FLAG_GR_COL_WHITE;
    
	return c;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    float ar = iResolution.x/iResolution.y;
	vec2 uv = (fragCoord.xy / iResolution.xy) * vec2(ar, 1);
    
    float zoom = 1.4;
    vec2  pos  = vec2(.5,.25);
    
    uv = uv * zoom - pos; // Position the flag
    vec2 pv = uv;

    // Wave animation    
    vec2 cv = uv;    
	pv.y = uv.y + (.3 + cv.x) * pow(sin(cv.x * 6. - iGlobalTime * 6.0), 2.) * .032;
    pv.x = uv.x + cv.y * cos(cv.x - cv.y * 2. - iGlobalTime * .5) * .05;
    
    vec3 col = vec3(0);

    col = flag_gr(pv);
    
    float s = 1.;
    
    s = pow(dot(normalize(vec3(pv - uv, 1)), normalize(vec3(0, 25, 4))), .4);
    
	fragColor = vec4(col * s, 1);
}
