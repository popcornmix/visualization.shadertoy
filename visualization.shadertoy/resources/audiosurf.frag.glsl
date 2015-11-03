//See: https://www.shadertoy.com/view/Mss3Dr

// by nikos papadopoulos, 4rknova / 2013
// Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

#ifdef GL_ES
precision highp float;
#endif

#define P 3.14159
#define E .001

#define T .03 // Thickness
#define W 2.  // Width
#define A .09 // Amplitude
#define V 1.  // Velocity

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
	vec2 c = fragCoord.xy / iResolution.xy;
	vec4 s = texture2D(iChannel0, c * .5);
	c = vec2(0, A*s.y*sin((c.x*W+iGlobalTime*V)* 2.5)) + (c*2.-1.);
	float g = max(abs(s.y/(pow(c.y, 2.1*sin(s.x*P))))*T,
				  abs(.1/(c.y+E)));
	fragColor = vec4(g*g*s.y*.6, g*s.w*.44, g*g*.7, 1);
}
