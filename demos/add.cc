

template <int Width, bool Signed = true>
using ac_int = XlsInt<Width, Signed>;

class TestBlock {
private:
  // Signed adds
  int add(int a, int b) {
    return a + b;
  }

public:
  // Top method
  #pragma hls_top
  int Run(int a, int b, int use) {
      return add(a, b);
  }
};
