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
  vec3 reflectDirection = normalize(-lightDirection + 2.0 * dot(normalDirection, lightDirection) * normalDirection);

  vec3 fragmentColor;

  float distance = length(lightDirection);

  //used a mix of ambient color and diffuse color to reduce the border effect when the two color are vastly different from each other
  fragmentColor = 0.7* Ka * ambientColor + 0.3 * Kd* diffuseColor; 

  //low piority which create the base color
  if (max(0.0, dot(normalDirection, lightDirection)) / distance >= 0.01)
    fragmentColor = 0.5 * Ka* ambientColor+ 0.5* Kd* diffuseColor; 

  //medium piority
  if (max(0.0, dot(normalDirection, lightDirection)) / distance >= 0.3)
    fragmentColor = 0.1*Ka*ambientColor + 0.9* Kd * diffuseColor; 
            
  //high piority       
  if (pow(max(0.0, dot(reflectDirection, viewDirection)), shininessVal) / distance > 0.5 && dot(normalDirection, lightDirection) > 0.0) 
    fragmentColor = Ks * specularColor;

  gl_FragColor = vec4(fragmentColor, 1.0);
}
