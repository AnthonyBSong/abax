template <int Width, bool Signed = true>
using ac_int = XlsInt<Width, Signed>;

class TestBlock {
private:
  // Signed adds
  ac_int<32, true> add(ac_int<32, true> a, ac_int<32, true> b) {
    return a + b;
  }

public:
  // Top method
  #pragma hls_top
  ac_int<32, true> Run(ac_int<32, true> a, ac_int<32, true> b, int use) {
      return add(a, b);
  }
};
