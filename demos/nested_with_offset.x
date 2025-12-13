pub proc nested_with_offset {
  in0: chan<s32> in;
  in1: chan<s32> in;
  out0: chan<s32> out;

  config(in0: chan<s32> in, in1: chan<s32> in, out0: chan<s32> out) { (in0, in1, out0) }

  init { (0, 0, 0, 0, false) }

  next(state: (s32, s32, s32, s32, bool)) {
    let (acc0, acc1, index0, index1, busy) = state;
    let (tok0, tmp0) = recv_if(join(), in0, !busy, s32:0);
    let (tok1, tmp1) = recv_if(join(), in1, !busy, s32:0);
    let tmp2 = (index0 as s64);
    let tmp3 = (tmp2 * s64:7);
    let tmp4 = (tmp3 as sN[65]);
    let tmp5 = (tmp4 + sN[65]:3);
    let tmp6 = (tmp5 as s32);
    let tmp7 = tmp6;
    let tmp8 = index0 < s32:3;
    let tmp9 = if (tmp8 && index1 == s32:0) { tmp7 } else { acc1 };
    let tmp10 = (acc0 as s33);
    let tmp11 = (tmp9 as s33);
    let tmp12 = (tmp10 + tmp11);
    let tmp13 = (tmp12 as s34);
    let tmp14 = (index1 as s34);
    let tmp15 = (tmp13 + tmp14);
    let tmp16 = (tmp15 as s32);
    let tmp17 = tmp16;
    let tmp18 = index1 < s32:4;
    let tmp19 = if (tmp8 && tmp18) { tmp17 } else { acc0 };
    let tmp21 = index1 + 1 >= s32:4;
    let tmp20 = if (tmp21) { s32:0 } else { index1 + 1 };
    let tmp23 = index0 + 1 >= s32:3;
    let tmp22 = if (tmp21 && tmp23) { s32:0 } else if (tmp21) { index0 + 1 } else { index0 };
    let tmp24 = tmp21 && tmp23;
    let tok2 = send_if(tok1, out0, tmp24, tmp19);
    let tmp25 = if (tmp24) { 0 } else { tmp19 };
    let tmp26 = if (tmp24) { 0 } else { tmp9 };
    let tmp27 = if (tmp24) { s32:0 } else { tmp22 };
    let tmp28 = if (tmp24) { s32:0 } else { tmp20 };
    let tmp29 = !tmp24;
    (tmp25, tmp26, tmp27, tmp28, tmp29)
  }
}