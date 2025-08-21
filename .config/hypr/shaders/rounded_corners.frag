#version 330

uniform sampler2D tex;
uniform float radius;
in vec2 texcoord;
out vec4 fragColor;

void main() {
    vec4 color = texture(tex, texcoord);
    vec2 size = textureSize(tex, 0);
    vec2 position = texcoord * size;
    vec2 center = size / 2.0;
    float distance = length(max(abs(position - center) - size / 2.0 + radius, 0.0)) - radius;
    
    if (distance > 0.0) {
        discard;
    }
    
    fragColor = color;
}