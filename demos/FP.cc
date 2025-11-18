template<int W, int F>
struct Fixed {
    __xls_int<W> raw;

    // Default to 0
    Fixed() : raw(0) {}

    // Construct directly from underlying raw value
    explicit Fixed(__xls_int<W> v) : raw(v) {}

    // Construct from an integer
    static Fixed from_int(int v) {
        __xls_int<W> scaled = (__xls_int<W>)(v) << F;
        return Fixed(scaled);
    }
};

template<int W, int F>
Fixed<W,F> operator+(Fixed<W,F> a, Fixed<W,F> b) {
    return Fixed<W,F>{ a.raw + b.raw };
}

template<int W, int F>
Fixed<W,F> operator-(Fixed<W,F> a, Fixed<W,F> b) {
    return Fixed<W,F>{ a.raw - b.raw };
}

template<int W, int F>
Fixed<W,F> operator*(Fixed<W,F> a, Fixed<W,F> b) {
    using Wide = __xls_int<2 * W>;

    Wide aw = (Wide)a.raw;
    Wide bw = (Wide)b.raw;

    Wide prod = aw * bw;

    if (F > 0) {
        Wide half = (Wide)1 << (F - 1);
        Wide bias = (prod >= 0) ? half : (Wide)0;
        prod = prod + bias;
    }

    // Drop F fractional bits
    Wide scaled = prod >> F;

    __xls_int<W> narrowed = (__xls_int<W>)scaled;

    return Fixed<W,F>{ narrowed };
}
