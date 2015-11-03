// see: https://www.shadertoy.com/view/4df3R8

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
	float off = texture2D(iChannel0, vec2(0.0, 0.25)).x;
	off += texture2D(iChannel0, vec2(0.2, 0.25)).x+0.000001;
	off += 0.000001;

	float time = iChannelTime[0] / 3.0;
	vec3 p = (vec3(fragCoord,0.) / iResolution - 0.5) * abs(sin(time/10.0)) * 50.0;
	float 
		d = sin(length(p)+time), 
		a = sin(mod(atan(p.y, p.x) + time + sin(d+time), 3.1416/3.)*3.0), 
		v = a + d, 
		m = sin(length(p)*4.0-a+time);
	fragColor = vec4(-v*sin(m*sin(-d)+time*.1), v*m*sin(tan(sin(-a*off*5.0))*sin(-a/off*3.)*3.+time*.5), mod(v,m)*off, time);
}

