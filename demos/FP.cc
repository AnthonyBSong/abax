template <int Width, bool Signed = true>
using ac_int = XlsInt<Width, Signed>;

template<int W, int F>
struct SFixed {
    ac_int<W - F, true>  int_part;  // before binary point
    ac_int<F, false>     frac_part; // after binary point
};

template<int W, int F>
ac_int<W, true> pack(SFixed<W,F> x) {
    ac_int<W, true> hi = (ac_int<W, true>)x.int_part << F;
    ac_int<W, true> lo = (ac_int<W, true>)x.frac_part;
    return hi | lo;
}

template<int W, int F>
SFixed<W,F> unpack(ac_int<W, true> raw) {
    SFixed<W,F> r;

    r.int_part = (ac_int<W - F, true>)(raw >> F);

    ac_int<W, false> uraw = (ac_int<W, false>)raw;
    ac_int<W, false> mask = ((ac_int<W, false>)1 << F) - 1;
    r.frac_part = (ac_int<F, false>)(uraw & mask);

    return r;
}

template<int W, int F>
SFixed<W,F> operator+(SFixed<W,F> a, SFixed<W,F> b) {
    ac_int<W, true> ra = pack<W,F>(a);
    ac_int<W, true> rb = pack<W,F>(b);
    ac_int<W, true> sum = ra + rb;
    return unpack<W,F>(sum);
}

template<int W, int F>
SFixed<W,F> operator-(SFixed<W,F> a, SFixed<W,F> b) {
    ac_int<W, true> ra = pack<W,F>(a);
    ac_int<W, true> rb = pack<W,F>(b);
    ac_int<W, true> diff = ra - rb;
    return unpack<W,F>(diff);
}

template<int W, int F>
SFixed<W,F> operator*(SFixed<W,F> a, SFixed<W,F> b) {
    using Wide = ac_int<2 * W, true>;

    ac_int<W, true> ra = pack<W,F>(a);
    ac_int<W, true> rb = pack<W,F>(b);

    Wide prod = (Wide)ra * (Wide)rb;
    ac_int<W, true> scaled = (ac_int<W, true>)(prod >> F);

    return unpack<W,F>(scaled);
}
