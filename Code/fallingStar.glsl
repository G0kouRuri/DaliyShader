// can be run in shadertoy

vec2 rotate(vec2 uv, float th) {
  return mat2(cos(th), sin(th), -sin(th), cos(th)) * uv;
}

vec2 translate(vec2 uv,float speed){
  return (uv-1.+mod(speed*iTime,2.));
}

vec3 getBackgroundColor(vec2 uv) {
  uv = uv * 0.5 + 0.5; // remap uv from <-0.5,0.5> to <0.25,0.75>
  vec3 gradientStartColor = vec3(0.4, 0.2, 0.9);
  vec3 gradientEndColor = vec3(0., 0., 0.);
  return mix(gradientStartColor, gradientEndColor, pow(uv.y,.4)); // gradient goes from bottom to top
}

float sdStar5(in vec2 p, in float r, in float rf)
{
  const vec2 k1 = vec2(0.809016994375, -0.587785252292);
  const vec2 k2 = vec2(-k1.x,k1.y);
  
  //p = rotate(vec2(p.x,p.y), iTime);
  
  p.x = abs(p.x);
  p -= 2.0*max(dot(k1,p),0.0)*k1;
  p -= 2.0*max(dot(k2,p),0.0)*k2;
  p.x = abs(p.x);
  p.y -= r;
  
  vec2 ba = rf*vec2(-k1.y,k1.x) - vec2(0,1);
  float h = clamp( dot(p,ba)/dot(ba,ba), 0.0, r );

  return length(p-ba*h) * sign(p.y*ba.x-p.x*ba.y);
}

vec3 drawScene(vec2 uv) {
  vec3 col = getBackgroundColor(uv);
  
  float star = sdStar5(rotate(translate(uv,.5),iTime), 0.12, 0.45);
  float star1= sdStar5(rotate(translate(uv-0.1,.5),iTime*.7), 0.06, 0.45);
  float star2= sdStar5(rotate(translate(uv-0.15,.5),iTime*.5), 0.03, 0.45);
  float star3= sdStar5(rotate(translate(uv-0.19,.5),iTime*.3), 0.02, 0.45);


  star = smoothstep(0.,0.02*abs(sin(iTime)),star);
  star1= step(0.,star1);
  star2= step(0.,star2);
  star3= step(0.,star3);
  col = mix(vec3(1, 1, 0)*0.15, col, star3);
  col = mix(vec3(1, 1, 0)*0.3, col, star2);
  col = mix(vec3(1, 1, 0)*0.5, col, star1);
  col = mix(vec3(1, 1, 0), col, star);


  return col;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
  vec2 uv = fragCoord/iResolution.xy; // <0, 1>
  uv -= 0.5; // <-0.5,0.5>
  uv.x *= iResolution.x/iResolution.y; // fix aspect ratio

  vec3 col = drawScene(uv);

  // Output to screen
  fragColor = vec4(col,1.0);
}
