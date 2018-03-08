// Fragment shader template for the bonus question

precision mediump float; // It is required to set a floating point precision in all fragment shaders.

// Interpolated values from vertex shader
// NOTE: You may need to edit this section to add additional variables
varying vec3 normalInterp; // Normal
varying vec3 vertPos; // Vertex position
varying vec3 viewVec; // Interpolated view vector
varying highp vec2 texCoordInterp;

// uniform values remain the same across the scene
// NOTE: You may need to edit this section to add additional variables
uniform float Ka;   // Ambient reflection coefficient
uniform float Kd;   // Diffuse reflection coefficient
uniform float Ks;   // Specular reflection coefficient
uniform float shininessVal; // Shininess

// Material color
uniform vec3 ambientColor;
uniform vec3 diffuseColor;
uniform vec3 specularColor;

uniform vec3 lightPos; // Light position in camera space

uniform sampler2D uSampler;	// 2D sampler for the earth texture

//README: work best at ambient colour = #615851, difuse color = #cc6f12, specular color = #f0eeeb 

void main() {
  vec3 normalDirection = normalize (normalInterp);
  vec3 lightDirection = normalize (lightPos - vertPos);
  vec3 viewDirection = normalize (viewVec);
  vec3 reflectDirection = normalize(-lightDirection + 2.0 * dot(normalDirection, lightDirection) * normalDirection);

  float lambertian = Kd * max(0.0, dot(normalDirection, lightDirection));
  float specular = Ks * pow(max(0.0, dot(reflectDirection, viewDirection)), shininessVal);
  
  //calculating the density of the how much colour is at a certain spot
  vec3 intensity = Ka * ambientColor + lambertian * diffuseColor + specular * specularColor*2.0;
  //approximation
  float density = 10.0*(intensity.r*0.299 + intensity.g*0.587 + intensity.b*0.114);

    //default colour is white
    gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
    //progressively creating more black line if the density is lower than certain threshold as that represents darker areas and thus requires more crosshatching
    if (density < 10.0) {
        //this isolate the diagonal pixel(positive gradient) and set it to black
        if (mod(gl_FragCoord.x - gl_FragCoord.y, 10.0) == 0.0) {
            gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
        }
    }
      
    //this isolate the other diagonal pixel(negative gradient) and set it to black
    if (density < 7.5) {
        if (mod(gl_FragCoord.x + gl_FragCoord.y, 10.0) == 0.0) {
            gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
        }
    }
     
    if (density < 4.0) {
        if (mod(gl_FragCoord.x - gl_FragCoord.y - 4.0, 10.0) == 0.0) {
            gl_FragColor = vec4(0.0, 0.0, 0.0, 0.8);
        }
    }

    if (density < 3.8) {
        if (mod(gl_FragCoord.x - gl_FragCoord.y - 4.0, 10.0) == 0.0) {
            gl_FragColor = vec4(0.0, 0.0, 0.0, 0.8);
        }
    }
    if (density < 3.659) {
        if (mod(gl_FragCoord.x + gl_FragCoord.y + 4.0, 10.0) == 0.0) {
            gl_FragColor = vec4(0.0, 0.0, 0.0, 0.8);
        }
    }
    
    if (density < 1.2) {
        if (mod(gl_FragCoord.x + gl_FragCoord.y + 4.0, 10.0) == 0.0) {
            gl_FragColor = vec4(0.0, 0.0, 0.0, 0.7);
        }
    }
              
}
