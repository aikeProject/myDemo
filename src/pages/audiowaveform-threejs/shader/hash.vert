

// Pseudorandom hash functions
// https://www.shadertoy.com/view/4djSRW

// Use these for integer stepped ranges, ie Value-Noise/Perlin noise functions.
#define HASHSCALE1 0.1031
#define HASHSCALE3 vec3(0.1031, 0.1030, 0.0973)
#define HASHSCALE4 vec4(1031, 0.1030, 0.0973, 0.1099)

// Use these for smaller input rangers like audio tick or 0-1 UVs.
// #define HASHSCALE1 443.8975
// #define HASHSCALE3 vec3(443.897, 441.423, 437.195)
// #define HASHSCALE4 vec4(443.897, 441.423, 437.195, 444.129)

float hash11(float p)
{
    vec3 o = fract(vec3(p,p,p) * HASHSCALE1);
    o += dot(o, o.yzx + 19.19);
    return fract((o.x + o.y) * o.z);
}

float hash12(vec2 p)
{
    vec3 o = fract(p.xyx * HASHSCALE1);
    o += dot(o, o.yzx + 19.19);
    return fract((o.x + o.y) * o.z);
}

float hash13(vec3 p)
{
    vec3 o = fract(p.xyz * HASHSCALE1);
    o += dot(o, o.yzx + 19.19);
    return fract((o.x + o.y) * o.z);
}

vec2 hash21(float p)
{
    vec3 o = fract(vec3(p,p,p) * HASHSCALE3);
    o += dot(o, o.yzx + 19.19);
    return fract((o.xx + o.yz) * o.zy);
}

vec2 hash22(vec2 p)
{
    vec3 o = fract(p.xyx * HASHSCALE3);
    o += dot(o, o.yzx + 19.19);
    return fract((o.xx + o.yz) * o.zy);

}

vec2 hash23(vec3 p)
{
    vec3 o = fract(p.xyz * HASHSCALE3);
    o += dot(o, o.yzx + 19.19);
    return fract((o.xx+o.yz) * o.zy);
}

vec3 hash31(float p)
{
    vec3 o = fract(vec3(p,p,p) * HASHSCALE3);
    o += dot(o, o.yzx + 19.19);
    return fract((o.xxy + o.yzz) * o.zyx);
}

vec3 hash32(vec2 p)
{
    vec3 o = fract(p.xyx * HASHSCALE3);
    o += dot(o, o.yxz + 19.19);
    return fract((o.xxy + o.yzz) * o.zyx);
}

vec3 hash33(vec3 p)
{
    vec3 o = fract(p.xyz * HASHSCALE3);
    o += dot(o, o.yxz + 19.19);
    return fract((o.xxy + o.yxx) * o.zyx);
}

vec4 hash41(float p)
{
    vec4 o = fract(vec4(p,p,p,p) * HASHSCALE4);
    o += dot(o, o.wzxy + 19.19);
    return fract((o.xxyz + o.yzzw) * o.zywx);
}

vec4 hash42(vec2 p)
{
    vec4 o = fract(p.xyxy * HASHSCALE4);
    o += dot(o, o.wzxy + 19.19);
    return fract((o.xxyz + o.yzzw) * o.zywx);
}

vec4 hash43(vec3 p)
{
    vec4 o = fract(p.xyzx * HASHSCALE4);
    o += dot(o, o.wzxy + 19.19);
    return fract((o.xxyz + o.yzzw) * o.zywx);
}

vec4 hash44(vec4 p)
{
    vec4 o = fract(p.xyzw * HASHSCALE4);
    o += dot(o, o.wzxy + 19.19);
    return fract((o.xxyz + o.yzzw) * o.zywx);
}

