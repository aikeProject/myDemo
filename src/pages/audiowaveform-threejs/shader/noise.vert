

#include <hash>

// http://iquilezles.org/www/articles/gradientnoise/gradientnoise.htm

// returns 3D value noise
float noise(in vec3 x)
{
    // grid
    vec3 p = floor(x);
    vec3 w = fract(x);

    // quintic interpolant
    vec3 u = w*w*w*(w*(w*6.0-15.0)+10.0);

    // gradients
    vec3 ga = hash33( p+vec3(0.0,0.0,0.0) );
    vec3 gb = hash33( p+vec3(1.0,0.0,0.0) );
    vec3 gc = hash33( p+vec3(0.0,1.0,0.0) );
    vec3 gd = hash33( p+vec3(1.0,1.0,0.0) );
    vec3 ge = hash33( p+vec3(0.0,0.0,1.0) );
    vec3 gf = hash33( p+vec3(1.0,0.0,1.0) );
    vec3 gg = hash33( p+vec3(0.0,1.0,1.0) );
    vec3 gh = hash33( p+vec3(1.0,1.0,1.0) );

    // projections
    float va = dot( ga, w-vec3(0.0,0.0,0.0) );
    float vb = dot( gb, w-vec3(1.0,0.0,0.0) );
    float vc = dot( gc, w-vec3(0.0,1.0,0.0) );
    float vd = dot( gd, w-vec3(1.0,1.0,0.0) );
    float ve = dot( ge, w-vec3(0.0,0.0,1.0) );
    float vf = dot( gf, w-vec3(1.0,0.0,1.0) );
    float vg = dot( gg, w-vec3(0.0,1.0,1.0) );
    float vh = dot( gh, w-vec3(1.0,1.0,1.0) );

    // interpolation
    return va +
    u.x*(vb-va) +
    u.y*(vc-va) +
    u.z*(ve-va) +
    u.x*u.y*(va-vb-vc+vd) +
    u.y*u.z*(va-vc-ve+vg) +
    u.z*u.x*(va-vb-ve+vf) +
    u.x*u.y*u.z*(-va+vb+vc-vd+ve-vf-vg+vh);
}

// returns 3D value noise (in .x)  and its derivatives (in .yzw)
vec4 noised( in vec3 x )
{
    // grid
    vec3 p = floor(x);
    vec3 w = fract(x);

    // quintic interpolant
    vec3 u = w*w*w*(w*(w*6.0-15.0)+10.0);
    vec3 du = 30.0*w*w*(w*(w-2.0)+1.0);

    // gradients
    vec3 ga = hash33( p+vec3(0.0,0.0,0.0) );
    vec3 gb = hash33( p+vec3(1.0,0.0,0.0) );
    vec3 gc = hash33( p+vec3(0.0,1.0,0.0) );
    vec3 gd = hash33( p+vec3(1.0,1.0,0.0) );
    vec3 ge = hash33( p+vec3(0.0,0.0,1.0) );
    vec3 gf = hash33( p+vec3(1.0,0.0,1.0) );
    vec3 gg = hash33( p+vec3(0.0,1.0,1.0) );
    vec3 gh = hash33( p+vec3(1.0,1.0,1.0) );

    // projections
    float va = dot( ga, w-vec3(0.0,0.0,0.0) );
    float vb = dot( gb, w-vec3(1.0,0.0,0.0) );
    float vc = dot( gc, w-vec3(0.0,1.0,0.0) );
    float vd = dot( gd, w-vec3(1.0,1.0,0.0) );
    float ve = dot( ge, w-vec3(0.0,0.0,1.0) );
    float vf = dot( gf, w-vec3(1.0,0.0,1.0) );
    float vg = dot( gg, w-vec3(0.0,1.0,1.0) );
    float vh = dot( gh, w-vec3(1.0,1.0,1.0) );

    // interpolation
    float v = va +
    u.x*(vb-va) +
    u.y*(vc-va) +
    u.z*(ve-va) +
    u.x*u.y*(va-vb-vc+vd) +
    u.y*u.z*(va-vc-ve+vg) +
    u.z*u.x*(va-vb-ve+vf) +
    u.x*u.y*u.z*(-va+vb+vc-vd+ve-vf-vg+vh);

    vec3 d = ga +
    u.x*(gb-ga) +
    u.y*(gc-ga) +
    u.z*(ge-ga) +
    u.x*u.y*(ga-gb-gc+gd) +
    u.y*u.z*(ga-gc-ge+gg) +
    u.z*u.x*(ga-gb-ge+gf) +
    u.x*u.y*u.z*(-ga+gb+gc-gd+ge-gf-gg+gh) +

    du * (vec3(vb-va,vc-va,ve-va) +
    u.yzx*vec3(va-vb-vc+vd,va-vc-ve+vg,va-vb-ve+vf) +
    u.zxy*vec3(va-vb-ve+vf,va-vb-vc+vd,va-vc-ve+vg) +
    u.yzx*u.zxy*(-va+vb+vc-vd+ve-vf-vg+vh));

    return vec4( v, d );
}
