precision mediump float; // It is required to set a floating point precision in all fragment shaders.

// Interpolated values from vertex shader
varying vec3 normalInterp; // Normal
varying vec3 vertPos; // Vertex position
varying vec3 viewVec; // Interpolated view vector

// uniform values remain the same across the scene
uniform float Ka;   // Ambient reflection coefficient
uniform float Kd;   // Diffuse reflection coefficient
uniform float Ks;   // Specular reflection coefficient
uniform float shininessVal; // Shininess

// Material color
uniform vec3 ambientColor;
uniform vec3 diffuseColor;
uniform vec3 specularColor;

uniform vec3 lightPos; // Light position in camera space

// HINT: Use the built-in variable gl_FragCoord to get the screen-space coordinates

// README: works well ambient = # 6b380c, diffuse = #e68627, specular = #ffffff
void main() {
  // Your solution should go here.
  vec3 normalDirection = normalize(normalInterp);
  vec3 viewDirection = normalize(viewVec);
  vec3 lightDirection = normalize(lightPos - vertPos);
  vec3 inBetweenColor = diffuseColor;

  float lambertian = Kd * max(0.0, dot(normalDirection,lightDirection));
  float specular = Ks * pow(max(0.0, dot(viewDirection,reflect(-lightDirection, normalDirection))), shininessVal);
  
  //calculating the density of the how much colour is at a certain spot
  vec3 intensity = Ka * ambientColor + lambertian * diffuseColor + specular * specularColor*2.0;
  //YUV approximation from https://en.wikipedia.org/wiki/YUV
  float density = 10.0*(intensity.r*0.299 + intensity.g*0.587 + intensity.b*0.114);

  float freq = 7.2;
  //calculate whether a pixel is in the range of the radius or not
  vec2 nearest = 2.0* fract(freq * gl_FragCoord.xy) - 0.85;
  float dist = length(nearest);

  //float radius = clamp(0.8 * max(0.0, dot(normalDirection, lightDirection)),0.7,0.83);
  float radius = clamp(  2.0 / density  ,0.2,0.8);

  /*
  if ( max(0.0, dot(normalDirection, lightDirection)) >= 0.1){
    radius = clamp(0.8 * max(0.0, dot(normalDirection, lightDirection)),0.63,0.83); 
  }
  */

  if (dot(normalDirection, lightDirection) > 0.0 && pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), shininessVal) > 0.2) 
    inBetweenColor = 0.5*diffuseColor + 0.5*specularColor;
    
 //mix function create the dot by setting dist < radius to ambient color and dist > radius to diffuse color
  vec3 fragcolor = mix(ambientColor, inBetweenColor, step(radius, dist));

  gl_FragColor = vec4(fragcolor, 1.0);
}