uniform sampler2D waveform;
uniform sampler2D frequency;

uniform float instantVolume;
uniform float smoothedVolume;

float sampleAudioTexture(sampler2D tex, float coord) {
    return texture2D(tex, vec2(coord, 0.0)).r;
}

float averageAudioTexture(sampler2D tex, float coord, float width) {

    float result = 0.0;

    for (int i = 0; i < 4; ++i) {

        result += sampleAudioTexture(tex, coord + width * (float(i) - 2.0)) / 4.0;

    }

    return result;

}

