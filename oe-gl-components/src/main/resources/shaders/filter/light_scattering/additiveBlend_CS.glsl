#version 430 core

layout (local_size_x = 8, local_size_y = 8) in;


layout (binding = 0, rgba16f) uniform readonly image2D lightScatteringSampler;

layout (binding = 1, rgba16f) uniform readonly image2D sceneSampler;

layout (binding = 2, rgba16f) uniform writeonly image2D lightScatteringSceneSampler;

vec3 blur(ivec2 computeCoord, int kernels){
	
	vec3 rgb = vec3(0,0,0);
	
	for (int i=-kernels; i<=kernels; i++){
		for (int j=-kernels; j<=kernels; j++){
			rgb += imageLoad(lightScatteringSampler, computeCoord + ivec2(i,j)).rgb;  
		}
	}

	rgb *= 1/ pow(kernels*2+1,2);
	
	return rgb;
}

void main(void){

	ivec2 computeCoord = ivec2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y);

	vec3 lightScatteringColor = blur(computeCoord, 5);   
    vec3 sceneColor = imageLoad(sceneSampler, computeCoord).rgb;

	imageStore(lightScatteringSceneSampler, computeCoord, vec4(lightScatteringColor + sceneColor, 1.0));

}