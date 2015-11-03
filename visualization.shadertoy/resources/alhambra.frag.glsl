const float timeEffect=0.0;

//-----------------------------------------------------------------------------
// Maths utils
//-----------------------------------------------------------------------------
mat3 m = mat3( 0.00,  0.80,  0.60,
              -0.80,  0.36, -0.48,
              -0.60, -0.48,  0.64 );
float hash( float n )
{
    return fract(sin(n)*43758.5453);
}

float noise( in vec3 x )
{
    vec3 p = floor(x);
    vec3 f = fract(x);

    f = f*f*(3.0-2.0*f);

    float n = p.x + p.y*57.0 + 113.0*p.z;

    float res = mix(mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
                        mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y),
                    mix(mix( hash(n+113.0), hash(n+114.0),f.x),
                        mix( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
    return res*2.0-1.0;
}

float fbm( vec3 p )
{
    float f;
    f  = 0.5000*noise( p ); p = m*p*2.02;
    f += 0.2500*noise( p ); p = m*p*2.03;
    f += 0.1250*noise( p );
    return f;
}

vec2 noise2(vec2 p)
{
	return 
		vec2(
			noise(vec3(p, 1.9+sin(iGlobalTime*0.8)*1.3)), 
			noise(vec3(p, -1.2+sin(iGlobalTime*1.2)*1.0)));
}

vec2 noise2(vec2 p, float fudge)
{
	return 
		vec2(
			noise(vec3(p, fudge+sin(iGlobalTime*0.8)*1.3)), 
			noise(vec3(p, -fudge+sin(iGlobalTime*1.2)*1.0)));
}


float triangleWave(float value)
{
	float hval = value*0.5;
	return 2.0*abs(2.0*(hval-floor(hval+0.5)))-1.0;
}

vec4 triangleWave(vec4 col)
{
	return 
		vec4(
			triangleWave(col.x),
			triangleWave(col.y),
			triangleWave(col.z),
			triangleWave(col.w));
}

// Mattias' drawing functions ( http://sociart.net/ )
// Terminals
vec4 simplex_color(vec2 p) 
{
	const float offset=12.0;
	const float zoom = 2.45;
	float x = p.x*zoom;
	float y = p.y*zoom;
	vec4 col= vec4(
		fbm(vec3(x,y, offset)),
		fbm(vec3(x,y, offset*1.25)),
		fbm(vec3(x,y, offset*2.33)),
		fbm(vec3(x,y, offset*3.66)));
	
	return (col-0.5)*1.5;
}

vec4 bw_noise(vec2 p) 
{
	p *= 1.5;
	float val = 
		(noise(vec3(p.x*2.2+sin(iGlobalTime*0.6+0.23)*0.22, p.y*2.2, 1.4+sin(iGlobalTime)*0.22))*0.66+
		noise(vec3(p.x*3.2, p.y*3.2+sin(iGlobalTime*1.2-0.3)*0.36, 4.3+sin(iGlobalTime*1.1+1.5*0.12)))*0.33)*2.0;
	
	return vec4(val);
}

float ridged( vec3 p )
{
   	float f = abs(noise(p));				  
	f += abs(0.5000*noise( p )); p = m*p*2.02;
	f += abs(0.2500*noise( p )); p = m*p*2.03;
	f += abs(0.1250*noise( p ));
	return f;
}

vec4 ridged_color(vec2 p)
{
	const float offset=0.2;
	float x = p.x*2.5;
	float y = p.y*2.5;
	vec4 col= vec4(
		1.0-ridged(vec3(x,y, offset)),
		1.0-ridged(vec3(x,y, offset*2.0)),
		1.0-ridged(vec3(x,y, offset*3.0)),
		1.0-ridged(vec3(x,y, offset*4.0)));
	
	return col-0.55;
}

vec4 y(vec2 p)
{	
	float val=triangleWave(p.y);
	return vec4(val, val, val, val);
}

vec4 x(vec2 p)
{	
	float val=triangleWave(p.x);
	return vec4(val, val, val, val);
}

vec4 x_y_ang_dist(vec2 p)
{
	float ang = atan(p.y, p.x);
	return triangleWave(vec4(p.x*p.x+p.y*p.y, p.x, p.y, ang));
}

vec2 zoom2(vec2 a, vec4 b)
{
	return vec2(a.x*b.x, a.y*b.y);
}

// Functions
vec4 dist(vec2 pos)
{
	float d = triangleWave(length(pos));	
	return vec4(d, d, d, d);
}

vec4 rol(vec4 col)
{
	return
		vec4(col.w, col.x, col.y, col.z);
}

vec4 ror(vec4 col)
{
	return
		vec4(col.y, col.z, col.w, col.x);
}

const float pi=3.14159;
const float piDiv=1.0/pi;
const float pi2 = 2.0*pi;
vec4 ang(vec2 pos)
{
	float angle = atan(pos.y, pos.x)*piDiv;
	float val = triangleWave(angle);
	return vec4(val, val, val, val);
}

vec4 add(vec4 a, vec4 b)
{
	return triangleWave(a+b);
}
	

// Warpers
vec2 julia(vec2 p)
{
	float radius = pow(p.x*p.x+p.y*p.y,0.25);
	float angle = atan(p.y, p.x)*0.5;
	return vec2(radius * cos(angle), radius*sin(angle));
}

vec4 sinf(vec4 p)
{
	return vec4(sin(p.x*pi2), sin(p.y*pi2),sin(p.z*pi2),sin(p.w*pi2));
}

vec4 minf(vec4 a, vec4 b)
{
	return triangleWave(min(a,b));
}

vec4 maxf(vec4 a, vec4 b)
{
	return triangleWave(max(a,b));
}

vec2 zoom(vec2 pos, vec4 arg)
{
	float zoomFactor = (arg.x+arg.y+arg.z+arg.w)*0.25;
	return pos * zoomFactor;
}
	
vec2 zoomin(vec2 p)
{
	return p*piDiv;
}

vec2 zoomout(vec2 p)
{
	return p*pi;
}

vec2 swirl(vec2 p)
{
	float swirlFactor = 3.0+timeEffect*(sin(iGlobalTime+0.22)-1.5);
	float radius = length(p);
	float angle = atan(p.y, p.x);
	float inner = angle-cos(radius*swirlFactor);
	return vec2(radius * cos(inner), radius*sin(inner));
}

vec2 horseShoe(vec2 p)
{
	float radius = length(p);
	float angle = 2.0*atan(p.y, p.x);
	return vec2(radius * cos(angle), radius*sin(angle));
}

vec2 wrap(vec2 p)
{
	float zoomFactor = 1.5-timeEffect*(sin(iGlobalTime+0.36));
	float repeatFactor = 3.0;
	float radius = length(p)*zoomFactor;
	float angle = atan(p.y, p.x)*repeatFactor;
	return vec2(radius * cos(angle), radius*sin(angle));
}

vec2 array(vec2 p)
{
	const float zoomOutFactor=1.5;
	return vec2(triangleWave(p.x*zoomOutFactor), triangleWave(p.y*zoomOutFactor));
}

vec2 pan_rotate_zoom(vec2 pos, vec4 val)
{
	vec2 pan = vec2(val.w, val.x);
	float angle= pi*val.y+timeEffect*(sin(iGlobalTime+1.2)-1.0);
	float zoom = val.z;
	
	float sinAngle = sin(angle);
	float cosAngle = cos(angle);
	
	// Pan
	vec2 next = pos+pan;
	// Rotate
	next = 
		vec2(
			cosAngle*next.x-sinAngle*next.y,
			sinAngle*next.x+cosAngle*next.y);
	// Zoom
	next *= 1.0+zoom;
	return next;
}

vec4 blend(vec4 a, vec4 b, vec4 c)
{
	float blend = (a.x + a.y + a.z + a.w + 1.0)*0.5;
	blend = clamp(blend, 0.0, 1.0);
	return mix(b,c,blend);
}
	

vec2 rotate(vec2 pos, vec4 rotation)	
{
	float simpleSum = rotation.x + rotation.y + rotation.z + rotation.w;
	float angle = pi * simpleSum * 0.25;
	float sinAngle = sin(angle);
	float cosAngle = cos(angle);
	return
		vec2(
			cosAngle * pos.x - sinAngle * pos.y,
			sinAngle * pos.x + cosAngle * pos.y);
}

vec2 rotate(vec2 pos, float angle)	
{
	angle = pi * angle;
	float sinAngle = sin(angle);
	float cosAngle = cos(angle);
	return
		vec2(
			cosAngle * pos.x - sinAngle * pos.y,
			sinAngle * pos.x + cosAngle * pos.y);
}

/* (max
  (horseshoe
    (ror
      (ror
        (array
          (wrap y))))) [-0.022,-0.115,0.553,0.406]) */

vec4 imageFunction(vec2 pos)
{
	float p0 = texture2D( iChannel0, vec2(0.4,0.0) ).x;
	float p1 = texture2D( iChannel0, vec2(0.5,0.0) ).x;
	float p2 = texture2D( iChannel0, vec2(0.6,0.0) ).x;
	float p3 = texture2D( iChannel0, vec2(0.7,0.0) ).x;
	float p4 = texture2D( iChannel0, vec2(1.0,0.0) ).x;
		
	vec2 hs=horseShoe(pos);
	pos = wrap(rotate(array(hs)*p2, p4*0.2+iGlobalTime*0.05));
	return
		add(
		 y(rotate(pos, p1)),
		 x_y_ang_dist(rotate(hs, p0*0.2+iGlobalTime*0.1)));	
}

// RENDER
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 q = fragCoord.xy / iResolution.xy;
    vec2 pos = -1.0 + 2.0*q;
    pos.x *= iResolution.x/ iResolution.y;	
	vec4 res = imageFunction(pos);
	vec4 color = imageFunction(pos);
	color = (color+1.0)*0.5;
	color = ror(color);	
	color.w=1.0;
	fragColor = color;		
}
