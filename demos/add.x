pub proc add {
  in0: chan<u32> in;
  in1: chan<u32> in;
  out0: chan<u32> out;

  config(in0: chan<u32> in, in1: chan<u32> in, out0: chan<u32> out) { (in0, in1, out0) }

  init { () }

  next(state: ()) {
    let (tok0, tmp0) = recv(join(), in0);
    let (tok1, tmp1) = recv(join(), in1);
    let tmp2 = (tmp0 as u33);
    let tmp3 = (tmp1 as u33);
    let tmp4 = (tmp2 + tmp3);
    let tmp5 = (tmp4 as u32);
    let tok = join(tok0, tok1);
    send(tok, out0, tmp5);
  }
}

#[test_proc]
proc add_test {
  terminator: chan<bool> out;
  in0_s: chan<u32> out;
  in1_s: chan<u32> out;
  out0_r: chan<u32> in;

  config(terminator: chan<bool> out) {
    let (in0_s, in0_r) = chan<u32>("in0");
    let (in1_s, in1_r) = chan<u32>("in1");
    let (out0_s, out0_r) = chan<u32>("out0");
    spawn add(in0_r, in1_r, out0_s);
    (terminator, in0_s, in1_s, out0_r)
  }

  init { () }

  next(state: ()) {
    let tok = join();
    // test case 0
    let tok = send(tok, in0_s, u32:0);
    let tok = send(tok, in1_s, u32:0);
    let (tok, result_0_0) = recv(tok, out0_r);
    assert_eq(result_0_0, u32:0);
    // test case 1
    let tok = send(tok, in0_s, u32:1);
    let tok = send(tok, in1_s, u32:2);
    let (tok, result_1_0) = recv(tok, out0_r);
    assert_eq(result_1_0, u32:3);
    // test case 2
    let tok = send(tok, in0_s, u32:123);
    let tok = send(tok, in1_s, u32:456);
    let (tok, result_2_0) = recv(tok, out0_r);
    assert_eq(result_2_0, u32:579);
    // test case 3
    let tok = send(tok, in0_s, u32:65536);
    let tok = send(tok, in1_s, u32:65536);
    let (tok, result_3_0) = recv(tok, out0_r);
    assert_eq(result_3_0, u32:131072);
    send(tok, terminator, true);
  }
}
