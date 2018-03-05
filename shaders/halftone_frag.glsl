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

void main() {
  // Your solution should go here.
  // Only the background color calculations have been provided as an example.
  vec3 normalDirection = normalize(normalInterp);
  vec3 viewDirection = normalize(viewVec);
  vec3 lightDirection = normalize(lightPos - vertPos);

  float freq = 7.2;
  vec2 nearest = 2.0* fract(freq * gl_FragCoord.xy) - 1.0;
  float dist = length(nearest);
  float radius = 0.8 ;
  if ( max(0.0, dot(normalDirection, lightDirection)) >= 0.1)
    radius = clamp(0.8 * max(0.0, dot(normalDirection, lightDirection)),0.6,0.8); 

  if (dot(normalDirection, lightDirection) > 0.0 
               // light source on the right side?
               && pow(max(0.0, dot(
               reflect(-lightDirection, normalDirection), 
               viewDirection)), shininessVal) > 0.0) 
               // more than half highlight intensity? 
            {
               radius = clamp(0.8 * max(0.0, dot(normalDirection, lightDirection)),0.3,0.8);
            }
  vec3 fragcolor = mix(ambientColor, diffuseColor, step(radius, dist));

  gl_FragColor = vec4(fragcolor, 1.0);
}