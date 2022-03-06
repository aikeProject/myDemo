// 顶点着色器
// https://github.com/mrdoob/three.js/blob/master/examples/webaudio_visualizer.html

varying vec2 vUv;

void main() {

    vUv = uv;

    gl_Position = vec4( position, 1.0 );

}