pub proc useless {
  in0: chan<s32> in;
  out0: chan<s32> out;

  config(in0: chan<s32> in, out0: chan<s32> out) { (in0, out0) }

  init { () }

  next(state: ()) {
    let (tok0, tmp0) = recv(join(), in0);
    let tmp3 = for (tmp1, tmp2): (s32, s32) in s32:0..s32:10 {
      let tmp4 = (tmp2 as s33);
      let tmp5 = (tmp4 + s33:1);
      let tmp6 = (tmp5 as s32);
      tmp6
    }(tmp0);
    send(tok0, out0, tmp3);
  }
}