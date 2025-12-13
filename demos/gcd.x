pub proc gcd {
  in0: chan<s32> in;
  in1: chan<s32> in;
  out0: chan<s32> out;

  config(in0: chan<s32> in, in1: chan<s32> in, out0: chan<s32> out) { (in0, in1, out0) }

  init { (0, 0, 0, true, false) }

  next(state: (s32, s32, s32, bool, bool)) {
    let (acc0, acc1, acc2, index0, busy) = state;
    let (tok0, tmp0) = recv_if(join(), in0, !busy, acc0);
    let (tok1, tmp1) = recv_if(join(), in1, !busy, acc1);
    let tmp2 = join(tok0, tok1);
    let tmp3 = if (!busy) { tmp0 } else { acc0 };
    let tmp4 = if (!busy) { tmp1 } else { acc2 };
    let tmp5 = (tmp4 > s32:0);
    let tmp6 = tmp5;
    let tmp7 = tmp4;
    let tmp8 = (tmp3 % tmp4);
    let tmp9 = tmp8;
    let tmp10 = tmp7;
    let tmp11 = if (tmp6) { tmp10 } else { tmp3 };
    let tmp12 = if (tmp6) { tmp7 } else { acc1 };
    let tmp13 = if (tmp6) { tmp9 } else { tmp4 };
    let tmp14 = !tmp6;
    let tok2 = send_if(tmp2, out0, tmp14, tmp11);
    let tmp15 = if (tmp14) { tmp0 } else { tmp11 };
    let tmp16 = if (tmp14) { 0 } else { tmp12 };
    let tmp17 = if (tmp14) { tmp1 } else { tmp13 };
    let tmp18 = if (tmp14) { false } else { tmp6 };
    let tmp19 = !tmp14;
    (tmp15, tmp16, tmp17, tmp18, tmp19)
  }
}

#[test_proc]
proc gcd_test {
  terminator: chan<bool> out;
  in0_s: chan<s32> out;
  in1_s: chan<s32> out;
  out0_r: chan<s32> in;

  config(terminator: chan<bool> out) {
    let (in0_s, in0_r) = chan<s32>("in0");
    let (in1_s, in1_r) = chan<s32>("in1");
    let (out0_s, out0_r) = chan<s32>("out0");
    spawn gcd(in0_r, in1_r, out0_s);
    (terminator, in0_s, in1_s, out0_r)
  }

  init { () }

  next(state: ()) {
    let tok = join();
    // test case 0
    let tok = send(tok, in0_s, s32:12);
    let tok = send(tok, in1_s, s32:8);
    let (tok, result_0_0) = recv(tok, out0_r);
    assert_eq(result_0_0, s32:4);
    // test case 1
    let tok = send(tok, in0_s, s32:48);
    let tok = send(tok, in1_s, s32:18);
    let (tok, result_1_0) = recv(tok, out0_r);
    assert_eq(result_1_0, s32:6);
    // test case 2
    let tok = send(tok, in0_s, s32:17);
    let tok = send(tok, in1_s, s32:13);
    let (tok, result_2_0) = recv(tok, out0_r);
    assert_eq(result_2_0, s32:1);
    // test case 3
    let tok = send(tok, in0_s, s32:100);
    let tok = send(tok, in1_s, s32:25);
    let (tok, result_3_0) = recv(tok, out0_r);
    assert_eq(result_3_0, s32:25);
    // test case 4
    let tok = send(tok, in0_s, s32:7);
    let tok = send(tok, in1_s, s32:7);
    let (tok, result_4_0) = recv(tok, out0_r);
    assert_eq(result_4_0, s32:7);
    send(tok, terminator, true);
  }
}
