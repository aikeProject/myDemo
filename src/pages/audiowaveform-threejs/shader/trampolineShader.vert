#include <project_billboard>
#include <common>
#include <app>
#include <audio>
#include <noise>

uniform float radius;
uniform float radiusMultiplier;
uniform float rotation;
uniform float perturbMultiplier;

uniform float audioFrequencyFactor;
uniform float audioVolumeFactor;
uniform float audioScaleFactor;
uniform float audioScaleExponent;

uniform float particleScale;
uniform float particleCount;

attribute float pid;
attribute vec3 seed;

void main() {

    float norm = pid / particleCount;
    float theta = norm * PI2;

    // arrange the particles in a circle
    vec2 circle = vec2(sin(theta + rotation * PI2), cos(theta + rotation * PI2));

    #ifdef USE_FREQUENCY_OFFSET

    float frequencyCoord = seed.x; // the trampoline uses random frequency coordinates

    frequencyCoord *= 0.6; // ignore upper (boring) frequencies

    float frequencySample = sampleAudioTexture(frequency, frequencyCoord);
    float frequencyOffset = frequencySample * audioFrequencyFactor;

    frequencyOffset *= seed.y;

    #endif

    #ifdef USE_VOLUME_OFFSET

    float volumeOffset = smoothedVolume * audioVolumeFactor;

    volumeOffset *= seed.y;

    #endif

    // Sum offsets and perturb the particle position.

    float offset = 0.0;

    #ifdef USE_FREQUENCY_OFFSET
    offset += frequencyOffset;
    #endif

    #ifdef USE_VOLUME_OFFSET
    offset += volumeOffset;
    #endif

    vec3 particlePosition = vec3(circle, 0) * radius * radiusMultiplier + vec3(0, 0, -1) * offset * perturbMultiplier;

    // Compute the particle scale.

    float scale = particleScale;
    scale += pow(max(0.0, offset * audioScaleFactor), audioScaleExponent);
    scale /= length(cameraPosition - particlePosition);

    // Project the vertex as a billboard in model space, then add it to the particle position in
    // world space. We don't need to use the model matrix here because the particle's position
    // is always computed in world space.

    vec3 worldPosition = particlePosition + projectBillboardVertex(position, scale);

    gl_Position = projectionMatrix * viewMatrix * vec4(worldPosition, 1.0);

}