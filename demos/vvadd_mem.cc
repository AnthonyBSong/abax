// ---- Simple stateful vvadd (same 4-state idea, no enums) ----
#include "/xls_builtin.h"  // NOLINT
#include "xls_int.h"       // NOLINT

class TestBlock {
public:
  __xls_channel<int, __xls_channel_dir_In>  v0_in;
  __xls_channel<int, __xls_channel_dir_In>  v1_in;
  __xls_channel<int, __xls_channel_dir_Out> out;

  __xls_memory<int, 16> v0;
  __xls_memory<int, 16> v1;
  __xls_memory<int, 16> c;

  // state: 0=load v0, 1=load v1, 2=compute, 3=output
  int state = 0;
  int i = 0;

#pragma hls_top
  void vvadd() {
    if (state == 0) {
      int x;
      if (v0_in.read(x)) {
        v0[i] = x;
        i++;
        if (i == 16) { i = 0; state = 1; }
      }

    } else if (state == 1) {
      int y;
      if (v1_in.read(y)) {
        v1[i] = y;
        i++;
        if (i == 16) { i = 0; state = 2; }
      }

    } else if (state == 2) {
      c[i] = v0[i] + v1[i];
      i++;
      if (i == 16) { i = 0; state = 3; }

    } else { // state 3
      out.write(c[i]); 
      i++;
      if (i == 16) { i = 0; state = 0; }
    }
  }
};
