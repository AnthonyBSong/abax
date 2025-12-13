pub proc fib {
  in0: chan<s32> in;
  out0: chan<s32> out;

  config(in0: chan<s32> in, out0: chan<s32> out) { (in0, out0) }

  init { (1, 0, 0, 0, 0, false) }

  next(state: (s32, s32, s32, s32, s32, bool)) {
    let (acc0, acc1, acc2, index0, ub0, busy) = state;
    let (tok0, tmp0) = recv_if(join(), in0, !busy, ub0);
    let tmp1 = (acc2 as s33);
    let tmp2 = (acc0 as s33);
    let tmp3 = (tmp1 + tmp2);
    let tmp4 = (tmp3 as s32);
    let tmp5 = tmp4;
    let tmp6 = acc0;
    let tmp7 = tmp5;
    let tmp8 = if (index0 < tmp0) { tmp7 } else { acc0 };
    let tmp9 = if (index0 < tmp0) { tmp5 } else { acc1 };
    let tmp10 = if (index0 < tmp0) { tmp6 } else { acc2 };
    let tmp11 = if (index0 + 1 >= tmp0) { s32:0 } else { index0 + 1 };
    let tmp12 = index0 + 1 >= tmp0;
    let tok1 = send_if(tok0, out0, tmp12, tmp8);
    let tmp13 = if (tmp12) { 1 } else { tmp8 };
    let tmp14 = if (tmp12) { 0 } else { tmp9 };
    let tmp15 = if (tmp12) { 0 } else { tmp10 };
    let tmp16 = if (tmp12) { s32:0 } else { tmp11 };
    let tmp17 = !tmp12;
    (tmp13, tmp14, tmp15, tmp16, tmp0, tmp17)
  }
}

#[test_proc]
proc fib_test {
  terminator: chan<bool> out;
  in0_s: chan<s32> out;
  out0_r: chan<s32> in;

  config(terminator: chan<bool> out) {
    let (in0_s, in0_r) = chan<s32>("in0");
    let (out0_s, out0_r) = chan<s32>("out0");
    spawn fib(in0_r, out0_s);
    (terminator, in0_s, out0_r)
  }

  init { () }

  next(state: ()) {
    let tok = join();
    // test case 0
    let tok = send(tok, in0_s, s32:0);
    let (tok, result_0_0) = recv(tok, out0_r);
    assert_eq(result_0_0, s32:1);
    // test case 1
    let tok = send(tok, in0_s, s32:1);
    let (tok, result_1_0) = recv(tok, out0_r);
    assert_eq(result_1_0, s32:1);
    // test case 2
    let tok = send(tok, in0_s, s32:5);
    let (tok, result_2_0) = recv(tok, out0_r);
    assert_eq(result_2_0, s32:8);
    // test case 3
    let tok = send(tok, in0_s, s32:10);
    let (tok, result_3_0) = recv(tok, out0_r);
    assert_eq(result_3_0, s32:89);
    send(tok, terminator, true);
  }
}
