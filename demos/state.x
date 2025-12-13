// to interpret the tests, run:
// interpreter_main state.x

// to generate verilog, run:
// - ir_converter_main --top=<func> dslx.x > <func>.ir
// - opt_main <func>.ir > <func>.opt.ir
// - codegen_main --pipeline_stages=1 --delay_model=unit --reset=rst <func>.opt.ir > <func>.v

// addition
pub proc add {
  A: chan<u32> in;
  B: chan<u32> in;
  C: chan<u32> out;

  // interface for spawning proc
  config(A: chan<u32> in, B: chan<u32> in, C: chan<u32> out) { (A, B, C) }

  // initial state value for proc
  init { () }

  next(st: ()) {
    // read in inputs
    let (tok_A, data_A) = recv(join(), A);
    let (tok_B, data_B) = recv(join(), B);
    // calculate outputs
    let sum = data_A + data_B;
    let tok = join(tok_A, tok_B);
    // send output
    send(tok, C, sum);
  }
}

// accumulator
pub proc accumulator {
  A: chan<u32> in;
  B: chan<u32> out;

  // proc interface
  config(A: chan<u32> in, B: chan<u32> out) { (A, B) }

  // initialize state
  init { u32:0 }

  next(accumulated: u32) {
    let (tok, data) = recv(join(), A);
    let sum = ((data as u33) + (accumulated as u33)) as u32;
    send(tok, B, sum);
    // last value becomes next state
    sum
  }
}

// adder test
#[test_proc]
proc add_test {
  // define channels
  input_a_s:  chan<u32> out;
  input_b_s:  chan<u32> out;
  output_c_r: chan<u32> in;
  terminator: chan<bool> out;

  // no state
  init { () }

  // configure proc
  config(terminator: chan<bool> out) {
    let (input_a_s,  input_a_r)  = chan<u32>("input_a");
    let (input_b_s,  input_b_r)  = chan<u32>("input_b");
    let (output_c_s, output_c_r) = chan<u32>("output_c");
    spawn add(input_a_r, input_b_r, output_c_s);
    (input_a_s, input_b_s, output_c_r, terminator)
  }

  next(state: ()) {
    // test case 1
    let tok = send(join(), input_a_s, u32:3);
    let tok = send(tok,    input_b_s, u32:4);
    let (tok, result) = recv(tok, output_c_r);
    assert_eq(result, u32:7);

    // test case 2
    let tok = send(join(), input_a_s, u32:7);
    let tok = send(tok,    input_b_s, u32:8);
    let (tok, result) = recv(tok, output_c_r);
    assert_eq(result, u32:15);

    // terminate
    let tok = send(tok, terminator, true);
  }
}

// accumulator test
#[test_proc]
proc accumulator_test {
  // define channels
  input_s:  chan<u32> out;
  output_r: chan<u32> in;
  terminator: chan<bool> out;

  // no state
  init { () }

  // configure proc
  config(terminator: chan<bool> out) {
    let (input_s,  input_r)  = chan<u32>("input");
    let (output_s, output_r) = chan<u32>("output");
    spawn accumulator(input_r, output_s);
    (input_s, output_r, terminator)
  }

  next(state: ()) {
    // test case 1
    let tok = send(join(), input_s, u32:3);
    let (tok, result) = recv(tok, output_r);
    assert_eq(result, u32:3);

    // test case 2
    let tok = send(join(), input_s, u32:8);
    let (tok, result) = recv(tok, output_r);
    assert_eq(result, u32:11);

    // test case 3
    let tok = send(join(), input_s, u32:9);
    let (tok, result) = recv(tok, output_r);
    assert_eq(result, u32:20);

    // terminate
    let tok = send(tok, terminator, true);
  }
}