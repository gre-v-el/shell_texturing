#version 130

in vec3 position;
in vec2 texcoord;
in vec4 color0;

out lowp vec2 uv;
out lowp vec2 uv_screen;
out lowp vec3 normal;
out lowp vec3 pos_local;
out lowp vec3 pos_local_surface;
out lowp vec3 pos_global;
out lowp vec3 pos_global_surface;

uniform mat4 Model;
uniform mat4 Projection;

uniform vec3 SpringPos;
uniform vec3 CameraPos;
uniform int NumShells;
uniform int CurShell;
uniform float Length;


void main() {
	normal = normalize(color0.xyz / 255.0 - 0.5);
	
	float intersection = dot(normal, SpringPos); // how far "into the mesh" has spring gone


	float t = float(CurShell) / float(NumShells - 1);
	vec3 displacement = normal * Length * t + SpringPos * 0.1 * t*t;
    vec4 res = Projection * Model * vec4(position + displacement, 1);

    uv_screen = res.xy / 2.0 + vec2(0.5, 0.5);
    uv = texcoord;
	pos_local = position;
	pos_local_surface = position + position + normal * Length * float(CurShell) / float(NumShells - 1);
	pos_global = pos_local + (Model * vec4(0.0, 0.0, 0.0, 1.0)).xyz;
	pos_global_surface = pos_local_surface + (Model * vec4(0.0, 0.0, 0.0, 1.0)).xyz;

    gl_Position = res;
}