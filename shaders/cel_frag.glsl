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

void main() {
  // Your solution should go here
  // Only the ambient colour calculations have been provided as an example.
  vec3 normalDirection = normalize(normalInterp);
  vec3 viewDirection = normalize(viewVec);
  vec3 lightDirection = normalize(lightPos - vertPos);

  vec3 fragmentColor;

  float distance = length(lightDirection);
  float attenuation = 1.0 / distance; // linear attenuation

  fragmentColor = Ka * ambientColor; 

  //low piority
  if (attenuation  * max(0.0, dot(normalDirection, lightDirection)) >= 0.1)
    fragmentColor = Kd * diffuseColor; 
            
  /*if (dot(viewDirection, normalDirection) < max(0.0, dot(normalDirection, lightDirection)))
    fragmentColor = diffuseColor;
  */ 
  //high piority         
  if (dot(normalDirection, lightDirection) > 0.0 
               // light source on the right side?
               && attenuation *  pow(max(0.0, dot(
               reflect(-lightDirection, normalDirection), 
               viewDirection)), shininessVal) > 0.5) 
               // more than half highlight intensity? 
            {
               fragmentColor = Ks * specularColor;
            }
  gl_FragColor = vec4(fragmentColor, 1.0);
}