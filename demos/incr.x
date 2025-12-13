pub proc incr {
  in0: chan<s32> in;
  out0: chan<s32> out;

  config(in0: chan<s32> in, out0: chan<s32> out) { (in0, out0) }

  init { () }

  next(state: ()) {
    let (tok0, tmp0) = recv(join(), in0);
    let tmp1 = (tmp0 as s33);
    let tmp2 = (tmp1 + s33:1);
    let tmp3 = (tmp2 as s32);
    send(tok0, out0, tmp3);
  }
}

#[test_proc]
proc incr_test {
  terminator: chan<bool> out;
  in0_s: chan<s32> out;
  out0_r: chan<s32> in;

  config(terminator: chan<bool> out) {
    let (in0_s, in0_r) = chan<s32>("in0");
    let (out0_s, out0_r) = chan<s32>("out0");
    spawn incr(in0_r, out0_s);
    (terminator, in0_s, out0_r)
  }

  init { () }

  next(state: ()) {
    let tok = join();
    // test case 0
    let tok = send(tok, in0_s, s32:-1);
    let (tok, result_0_0) = recv(tok, out0_r);
    assert_eq(result_0_0, s32:0);
    // test case 1
    let tok = send(tok, in0_s, s32:0);
    let (tok, result_1_0) = recv(tok, out0_r);
    assert_eq(result_1_0, s32:1);
    // test case 2
    let tok = send(tok, in0_s, s32:41);
    let (tok, result_2_0) = recv(tok, out0_r);
    assert_eq(result_2_0, s32:42);
    // test case 3
    let tok = send(tok, in0_s, s32:1024);
    let (tok, result_3_0) = recv(tok, out0_r);
    assert_eq(result_3_0, s32:1025);
    send(tok, terminator, true);
  }
}
