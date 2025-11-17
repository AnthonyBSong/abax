#include <cstdint>

class TestBlock {
private:
  // Signed adds
  int32_t add(int32_t a, int32_t b) {
    return a + b;
  }

public:
  // Top method
  #pragma hls_top
  int32_t Run(int32_t a, int32_t b, int use) {
      return add(a, b);
  }
};
