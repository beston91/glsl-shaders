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
  // Your solution should go here.
  // Only the ambient colour calculations have been provided as an example.

  vec3 normalDirection = normalize (normalInterp);
  vec3 lightDirection = normalize (lightPos - vertPos);
  vec3 viewDirection = normalize (viewVec);
  vec3 reflectDirection = normalize(-lightDirection + 2.0 * dot(normalDirection, lightDirection) * normalDirection);

  float lambertian = Kd * max(0.0, dot(normalDirection, lightDirection));
  float specular = Ks * pow(max(0.0, dot(reflectDirection, viewDirection)), shininessVal);
 
  gl_FragColor = vec4(ambientColor + lambertian * diffuseColor + specular * specularColor, 1.0);
}
