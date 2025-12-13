pub proc mac {
  in0: chan<s32> in;
  in1: chan<s32> in;
  in2: chan<s32> in;
  out0: chan<s32> out;

  config(in0: chan<s32> in, in1: chan<s32> in, in2: chan<s32> in, out0: chan<s32> out) { (in0, in1, in2, out0) }

  init { () }

  next(state: ()) {
    let (tok0, tmp0) = recv(join(), in0);
    let (tok1, tmp1) = recv(join(), in1);
    let (tok2, tmp2) = recv(join(), in2);
    let tmp3 = (tmp0 as s64);
    let tmp4 = (tmp1 as s64);
    let tmp5 = (tmp3 * tmp4);
    let tmp6 = (tmp5 as sN[65]);
    let tmp7 = (tmp2 as sN[65]);
    let tmp8 = (tmp6 + tmp7);
    let tmp9 = (tmp8 as s32);
    let tok = join(tok0, tok1, tok2);
    send(tok, out0, tmp9);
  }
}

#[test_proc]
proc mac_test {
  terminator: chan<bool> out;
  in0_s: chan<s32> out;
  in1_s: chan<s32> out;
  in2_s: chan<s32> out;
  out0_r: chan<s32> in;

  config(terminator: chan<bool> out) {
    let (in0_s, in0_r) = chan<s32>("in0");
    let (in1_s, in1_r) = chan<s32>("in1");
    let (in2_s, in2_r) = chan<s32>("in2");
    let (out0_s, out0_r) = chan<s32>("out0");
    spawn mac(in0_r, in1_r, in2_r, out0_s);
    (terminator, in0_s, in1_s, in2_s, out0_r)
  }

  init { () }

  next(state: ()) {
    let tok = join();
    // test case 0
    let tok = send(tok, in0_s, s32:2);
    let tok = send(tok, in1_s, s32:3);
    let tok = send(tok, in2_s, s32:4);
    let (tok, result_0_0) = recv(tok, out0_r);
    assert_eq(result_0_0, s32:10);
    // test case 1
    let tok = send(tok, in0_s, s32:5);
    let tok = send(tok, in1_s, s32:-1);
    let tok = send(tok, in2_s, s32:7);
    let (tok, result_1_0) = recv(tok, out0_r);
    assert_eq(result_1_0, s32:2);
    // test case 2
    let tok = send(tok, in0_s, s32:-4);
    let tok = send(tok, in1_s, s32:5);
    let tok = send(tok, in2_s, s32:6);
    let (tok, result_2_0) = recv(tok, out0_r);
    assert_eq(result_2_0, s32:-14);
    send(tok, terminator, true);
  }
}
