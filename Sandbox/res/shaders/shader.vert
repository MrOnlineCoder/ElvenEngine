#version 450 core

layout(location = 0) in vec3 a_Position;

uniform mat4 u_ViewProjection;
uniform mat4 u_Model;

out vec3 v_Position;

void main()
{
    v_Position = a_Position;
    gl_Position = u_ViewProjection * u_Model * vec4(a_Position, 1.0);
}