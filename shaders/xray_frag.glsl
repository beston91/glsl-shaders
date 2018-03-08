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
  
  //This calculate whether the normal is in the same direction of the vertPos vector, if they are, it will result in a number closes to 1, when 1 - that it will
  //produce a low opacity, which looks hollow.
  //At the edge, the normal vector would be orthogonal to the vertPos, which produces result close to 0. Hence 1 - opac will be close to 1 and hence appear solid
  float opac = dot(normalize(normalInterp), normalize(vertPos));
  opac = abs(opac);
  opac = 1.0-opac;

  gl_FragColor =  vec4(opac * ambientColor,1.0);

  gl_FragColor.a = opac;
}
