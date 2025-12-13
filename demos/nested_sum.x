pub proc nested_sum {
  in0: chan<s32> in;
  in1: chan<s32> in;
  out0: chan<s32> out;

  config(in0: chan<s32> in, in1: chan<s32> in, out0: chan<s32> out) { (in0, in1, out0) }

  init { (0, 0, 0, 0, false) }

  next(state: (s32, s32, s32, s32, bool)) {
    let (acc0, index0, index1, ub1, busy) = state;
    let (tok0, tmp0) = recv_if(join(), in0, !busy, ub1);
    let (tok1, tmp1) = recv_if(join(), in1, !busy, s32:0);
    let tmp2 = (tmp1 as s32);
    let tmp3 = (index0 * index1);
    let tmp4 = (acc0 as s34);
    let tmp5 = (tmp3 as s34);
    let tmp6 = (tmp4 + tmp5);
    let tmp7 = (tmp6 as s32);
    let tmp8 = tmp7;
    let tmp9 = if (index0 < s32:10 && index1 < tmp0) { tmp8 } else { acc0 };
    let tmp10 = if (index1 + 1 >= tmp0) { s32:0 } else { index1 + 1 };
    let tmp11 = index1 + 1 >= tmp0;
    let tmp12 = if (tmp11 && index0 + 1 >= s32:10) { s32:0 } else if (tmp11) { index0 + 1 } else { index0 };
    let tmp13 = tmp11 && (index0 + 1 >= s32:10);
    let tok2 = send_if(tok1, out0, tmp13, tmp9);
    let tmp14 = if (tmp13) { 0 } else { tmp9 };
    let tmp15 = if (tmp13) { s32:0 } else { tmp12 };
    let tmp16 = if (tmp13) { s32:0 } else { tmp10 };
    let tmp17 = !tmp13;
    (tmp14, tmp15, tmp16, tmp0, tmp17)
  }
}