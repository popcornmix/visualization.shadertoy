// Based on https://www.shadertoy.com/view/4lSGDc

const float speed = 13.0;

const float radius = 5.7;
const float thresholdFactor = 0.008;
const int ballCount = 6;

const vec3 backgroundColor = vec3(0.0);

const float capDistance = 0.8;

float dstMetaball(vec2 pos, vec2 center, float radius)
{
  vec2 diff = pos - center;
  return radius / dot(diff, diff);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) 
{ 
  // create centered local positions
  float aspect = iResolution.x / iResolution.y;
  vec2 tex = fragCoord.xy / iResolution.xy;
  tex.x *= aspect;
  tex -= clamp(vec2(aspect, 1.0 / aspect) - 1.0, 0.0, 1.0)  * 0.5;
    
  vec3 color = backgroundColor;

    
  float dst = 0.0;
  // add a fat ball in the middle
  dst += dstMetaball(tex, vec2(0.5, 0.5), radius) * 20.0;

  // init the vars for the other balls
  vec2 ballPos = vec2(0.0);
  //float sinTime = sin(iGlobalTime * speed * 0.1);
    float sinTime = 0.0;
    sinTime += texture2D(iChannel0,vec2(0.1,0.0)).x;
    sinTime += texture2D(iChannel0,vec2(0.2,0.0)).x;
    sinTime += texture2D(iChannel0,vec2(0.4,0.0)).x;
    sinTime += texture2D(iChannel0,vec2(0.8,0.0)).x;
    
  float m = sinTime * 0.25 * capDistance;
  vec2 f1 = m * vec2(0.0         ,  1.0);
  vec2 f2 = m * vec2(0.8660254038,  0.5);
  vec2 f3 = m * vec2(0.8660254038, -0.5);

    dst += dstMetaball(tex, -f1 + 0.5/*center*/, radius);   
    dst += dstMetaball(tex, -f2 + 0.5/*center*/, radius);
    dst += dstMetaball(tex, -f3 + 0.5/*center*/, radius);
    dst += dstMetaball(tex,  f1 + 0.5/*center*/, radius);   
    dst += dstMetaball(tex,  f2 + 0.5/*center*/, radius);
    dst += dstMetaball(tex,  f3 + 0.5/*center*/, radius);

  // scale down the distance, don't forget the middle ball
  dst /= float(ballCount) + 2.0;
  
  vec3 ballColor = vec3(sin(iGlobalTime * speed * 0.08), 
                        sin(iGlobalTime * speed * 0.07), 
                        sin(iGlobalTime * speed * 0.06));
  ballColor = normalize(ballColor);
  ballColor = ballColor * 0.5 + 0.5;
  // blend between colors
  color = mix(color, ballColor, dst * thresholdFactor);

  fragColor = vec4(color, 1.0);
}

