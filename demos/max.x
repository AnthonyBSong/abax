pub proc max {
  in0: chan<s32> in;
  in1: chan<s32> in;
  out0: chan<s32> out;

  config(in0: chan<s32> in, in1: chan<s32> in, out0: chan<s32> out) { (in0, in1, out0) }

  init { () }

  next(state: ()) {
    let (tok0, tmp0) = recv(join(), in0);
    let (tok1, tmp1) = recv(join(), in1);
    let tmp2 = (tmp0 > tmp1);
    let tmp3 = if (tmp2) { tmp0 } else { tmp1 };
    let tok = join(tok0, tok1);
    send(tok, out0, tmp3);
  }
}

#[test_proc]
proc max_test {
  terminator: chan<bool> out;
  in0_s: chan<s32> out;
  in1_s: chan<s32> out;
  out0_r: chan<s32> in;

  config(terminator: chan<bool> out) {
    let (in0_s, in0_r) = chan<s32>("in0");
    let (in1_s, in1_r) = chan<s32>("in1");
    let (out0_s, out0_r) = chan<s32>("out0");
    spawn max(in0_r, in1_r, out0_s);
    (terminator, in0_s, in1_s, out0_r)
  }

  init { () }

  next(state: ()) {
    let tok = join();
    // test case 0
    let tok = send(tok, in0_s, s32:-3);
    let tok = send(tok, in1_s, s32:-7);
    let (tok, result_0_0) = recv(tok, out0_r);
    assert_eq(result_0_0, s32:-3);
    // test case 1
    let tok = send(tok, in0_s, s32:10);
    let tok = send(tok, in1_s, s32:4);
    let (tok, result_1_0) = recv(tok, out0_r);
    assert_eq(result_1_0, s32:10);
    // test case 2
    let tok = send(tok, in0_s, s32:5);
    let tok = send(tok, in1_s, s32:9);
    let (tok, result_2_0) = recv(tok, out0_r);
    assert_eq(result_2_0, s32:9);
    send(tok, terminator, true);
  }
}
