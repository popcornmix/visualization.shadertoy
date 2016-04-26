// Taken from https://www.shadertoy.com/view/4s3XDr

/*
	Disco Transforms 
	03/2016
	seb chevrel
*/

vec3 textDots(vec2 p,float size,float size2,vec3 col1,vec3 col2) { 
    return ( length(mod(p,size)-size/2.0)*size2/size >0.5) ? col1 : col2; 
}    

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xx - vec2(0.5,0.5*iResolution.y/iResolution.x);

    // audio params
    float BASS = texture2D(iChannel0,vec2(0.0, 0.25)).x*-0.4;
    float LOMID = texture2D(iChannel0,vec2(0.3, 0.25)).x*-0.4;
    float MID = texture2D(iChannel0,vec2(0.6, 0.25)).x*-0.4;
    float HIGH = texture2D(iChannel0,vec2(0.8, 0.25)).x*-0.4; 
	
    // UV transforms
    float dist=length(uv);
    vec2 uv2 = uv/pow(dist,BASS*2.0);
    vec2 uv3 = uv/log(dist+LOMID*1.6);
    vec2 uv4 = uv*log(dist+MID*0.5);
    vec2 uv5 = uv*tan(dist+HIGH)*50.;
    
    // layers
    vec3 color= 
        clamp(1.0-dist*3.0,0.0,1.0)*vec3(0.5,0.5,0.5)
        -textDots(uv2,0.1,1.2,vec3(0),vec3(0.1))
		+textDots(uv3,0.05,1.3,vec3(0),vec3(0.2))
        +textDots(uv4,0.2,1.5,vec3(0),vec3(0.2))
       	+textDots(uv5,0.2,1.8,vec3(0),vec3(0.1))	
     ;
	// output
	fragColor = vec4(color,1.0);
}
