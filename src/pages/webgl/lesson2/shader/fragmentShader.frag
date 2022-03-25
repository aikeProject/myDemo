//设置浮点数据类型为中级精度
precision mediump float;
//接收 JavaScript 传过来的颜色值（rgba）。
uniform vec4 u_Color;

void main(){
    vec4 color = u_Color / vec4(255, 255, 255, 1);
    gl_FragColor = color;
}