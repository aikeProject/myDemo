#include <project_billboard>
#include <common>
#include <app>
#include <audio>
#include <noise>

uniform float radius;
uniform float radiusMultiplier;
uniform float rotation;
uniform float dampenExponent;
uniform float perturbMultiplier;

uniform float audioFrequencyFactor;
uniform float audioVolumeFactor;
uniform float audioScaleFactor;
uniform float audioScaleExponent;

uniform vec3 noiseParams;

uniform float sineFrequency;
uniform float sineAmplitude;
uniform float sineTimescale;

uniform float particleScale;
uniform float particleCount;

attribute float pid;
attribute vec3 seed;

void main() {

    float norm = pid / particleCount;
    float theta = norm * PI2;

    // arrange the particles in a circle
    vec2 circle = vec2(sin(theta + rotation * PI2), cos(theta + rotation * PI2));

    // dampen values when norm is close to 0 or 1
    float dampen = pow(abs(sin(norm * PI)), dampenExponent);

    #ifdef USE_FREQUENCY_OFFSET

    float frequencyCoord = norm;

    #ifdef USE_MIRRORED_FREQUENCY
    frequencyCoord = abs(frequencyCoord * 2.0 - 1.0);
    #endif

    frequencyCoord *= 0.6; // ignore upper (boring) frequencies

    float frequencySample = sampleAudioTexture(frequency, frequencyCoord);
    float frequencyOffset = frequencySample * audioFrequencyFactor;

    #endif

    #ifdef USE_VOLUME_OFFSET

    float volumeOffset = smoothedVolume * audioVolumeFactor;

    #endif

    #ifdef USE_SINE_OFFSET

    float sineOffset = sin(theta * sineFrequency + time * sineTimescale) * sineAmplitude * smoothedVolume * dampen;

    #endif

    #ifdef USE_NOISE_OFFSET

    // Compute some gradient noise using the circle coordinates and the application time. We use the
    // absolute value of the x coordinate to make the noise horizontally symmetrical. Unfortunately
    // this makes the offset discontinuous around x == 0. Fortunately the x derivative *is*
    // continuous there, so we mix the value noise with the x derivative.

    vec3 noiseCoord = vec3(0.0);

    noiseCoord.x = max(0.25, smoothedVolume) * noiseParams.x * abs(circle.x);
    noiseCoord.y = max(0.25, smoothedVolume) * noiseParams.y * circle.y;
    noiseCoord.z = max(0.10, smoothedVolume) * noiseParams.z * sin(time);

    vec4 noiseDerivatives = noised(noiseCoord);
    float noiseOffset = mix(noiseDerivatives.x, noiseDerivatives.y * 0.2, dampen) * max(0.1, dampen);

    #endif

    // Sum offsets and perturb the particle position.

    float offset = 0.0;

    #ifdef USE_FREQUENCY_OFFSET
    offset += frequencyOffset;
    #endif

    #ifdef USE_VOLUME_OFFSET
    offset += volumeOffset;
    #endif

    #ifdef USE_NOISE_OFFSET
    offset += noiseOffset;
    #endif

    #ifdef USE_SINE_OFFSET
    offset += sineOffset;
    #endif

    vec3 particlePosition = vec3(circle, 0) * radius * radiusMultiplier + vec3(circle, 0) * offset * perturbMultiplier;

    // Compute the particle scale.

    float scale = particleScale;
    scale += pow(max(0.0, offset * audioScaleFactor), audioScaleExponent);
    scale /= length(cameraPosition - particlePosition);

    vec3 transformed = particlePosition + projectBillboardVertex(position, scale);

    #include <project_vertex>

}

