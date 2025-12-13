pub proc wsa {
  in0: chan<s32> in;
  in1: chan<s32> in;
  out0: chan<s32> out;
  out1: chan<s32> out;
  out2: chan<s32> out;

  config(in0: chan<s32> in, in1: chan<s32> in, out0: chan<s32> out, out1: chan<s32> out, out2: chan<s32> out) { (in0, in1, out0, out1, out2) }

  init { () }

  next(state: ()) {
    let (tok0, tmp0) = recv(join(), in0);
    let (tok1, tmp1) = recv(join(), in1);
    let tmp2 = (tmp0 | tmp1);
    let tmp3 = (tmp0 & tmp1);
    let tmp4 = (tmp0 ^ tmp1);
    let tok = join(tok0, tok1);
    send(tok, out0, tmp2);
    send(tok, out1, tmp3);
    send(tok, out2, tmp4);
  }
}

#[test_proc]
proc wsa_test {
  terminator: chan<bool> out;
  in0_s: chan<s32> out;
  in1_s: chan<s32> out;
  out0_r: chan<s32> in;
  out1_r: chan<s32> in;
  out2_r: chan<s32> in;

  config(terminator: chan<bool> out) {
    let (in0_s, in0_r) = chan<s32>("in0");
    let (in1_s, in1_r) = chan<s32>("in1");
    let (out0_s, out0_r) = chan<s32>("out0");
    let (out1_s, out1_r) = chan<s32>("out1");
    let (out2_s, out2_r) = chan<s32>("out2");
    spawn wsa(in0_r, in1_r, out0_s, out1_s, out2_s);
    (terminator, in0_s, in1_s, out0_r, out1_r, out2_r)
  }

  init { () }

  next(state: ()) {
    let tok = join();
    // test case 0
    let tok = send(tok, in0_s, s32:0);
    let tok = send(tok, in1_s, s32:0);
    let (tok, result_0_0) = recv(tok, out0_r);
    assert_eq(result_0_0, s32:0);
    let (tok, result_0_1) = recv(tok, out1_r);
    assert_eq(result_0_1, s32:0);
    let (tok, result_0_2) = recv(tok, out2_r);
    assert_eq(result_0_2, s32:0);
    // test case 1
    let tok = send(tok, in0_s, s32:5);
    let tok = send(tok, in1_s, s32:3);
    let (tok, result_1_0) = recv(tok, out0_r);
    assert_eq(result_1_0, s32:7);
    let (tok, result_1_1) = recv(tok, out1_r);
    assert_eq(result_1_1, s32:1);
    let (tok, result_1_2) = recv(tok, out2_r);
    assert_eq(result_1_2, s32:6);
    // test case 2
    let tok = send(tok, in0_s, s32:-1);
    let tok = send(tok, in1_s, s32:7);
    let (tok, result_2_0) = recv(tok, out0_r);
    assert_eq(result_2_0, s32:-1);
    let (tok, result_2_1) = recv(tok, out1_r);
    assert_eq(result_2_1, s32:7);
    let (tok, result_2_2) = recv(tok, out2_r);
    assert_eq(result_2_2, s32:-8);
    send(tok, terminator, true);
  }
}
