// See: https://www.shadertoy.com/view/ltB3zw

vec3 calcSine(vec2 uv, 
              float frequency, float amplitude, float shift, float offset,
              vec3 color, float width)
{
    float y = sin(uv.x*frequency + shift) * amplitude + offset;
    float scale = smoothstep(width, 0.0, distance(y, uv.y));
    return color * scale;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord.xy / iResolution.xy;
    vec3 color = vec3(0.0);
    
    float beat1 = 0.2*smoothstep(0.2,0.8,texture2D(iChannel0,vec2(0.11,0.0)).x);
    float beat2 = 0.2*smoothstep(0.2,0.8,texture2D(iChannel0,vec2(0.23,0.0)).x);
    float beat3 = 0.2*smoothstep(0.2,0.8,texture2D(iChannel0,vec2(0.40,0.0)).x);
    
    color += calcSine(uv, 11.0, beat1, iGlobalTime*4.41+0.0, 0.3, vec3(0.0, 0.0, 1.0), 0.1);
    color += calcSine(uv, 23.0, beat2, iGlobalTime*3.17+1.0, 0.5, vec3(0.0, 1.0, 0.0), 0.1);
    color += calcSine(uv, 40.0, beat3, iGlobalTime*2.19+1.5, 0.7, vec3(1.0, 0.0, 0.0), 0.1);

    fragColor = vec4(color,1.0);
}
