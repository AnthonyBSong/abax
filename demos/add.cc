
  template<typename T>
using InputChannel = __xls_channel<T, __xls_channel_dir_In>;
template<typename T>
using OutputChannel = __xls_channel<T, __xls_channel_dir_Out>;
  
// Signed adds
int add(int a, int b) {
  return a + b;
}

class TestBlock {
public:
  // Top method
  #pragma hls_top
  int Run(int a, int b) {
      return add(a, b);
  }
};
