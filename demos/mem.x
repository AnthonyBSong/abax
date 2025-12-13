// to interpret the tests, run:
// interpreter_main mem.x --dslx_stdlib_path=../../xls/xls/dslx/stdlib

// to generate verilog, run:
// - ir_converter_main --top=vvadd128 mem.x --dslx_stdlib_path=../../xls/xls/dslx/stdlib > vvadd.ir
// - opt_main vvadd.ir > vvadd.opt.ir
// - codegen_main --pipeline_stages=5 --delay_model="sky130" --reset=rst --reset_active_low=false --reset_asynchronous=false --reset_data_path=true --flop_inputs=false --flop_outputs=false vvadd.opt.ir > vvadd.v

import std;

// 1 R/W RAM
pub struct memreq<aw: u32, dw: u32> {
  addr: bits[aw],
  data: bits[dw],
  we:   bool,
  re:   bool,
}

pub struct memresp<dw: u32> {
  data: bits[dw]
}

pub proc ram<size: u32, dw: u32, aw: u32 = { std::clog2(size) }> {
  // req and response channels
  req:  chan<memreq<aw, dw>> in;
  resp: chan<memresp<dw>>   out;

  config(req: chan<memreq<aw, dw>> in, resp: chan<memresp<dw>> out) {
    (req, resp)
  }

  // initialize data array to all 0
  init { bits[dw][size]: [bits[dw]:0, ...] }
  
  // response logic
  next(state: bits[dw][size]) {
    let (tok, request) = recv(join(), req);
    let next_state = if request.we { update(state, request.addr, request.data) } else { state };
    let response   = memresp { data: if request.re {state[request.addr]} else { bits[dw]:0 } };
    let tok        = send(tok, resp, response);
    next_state 
  }
}

// test the memory
#[test_proc]
proc ram_test {
  req:  chan<memreq<6, 32>> out;
  resp: chan<memresp<32>>    in;
  term: chan<bool>          out;

  config(terminator: chan<bool> out) {
    let (req_s,  req_r)  = chan<memreq<6, 32>>("request");
    let (resp_s, resp_r) = chan<memresp<32>>  ("response");
    spawn ram<u32:64, u32:32>(req_r, resp_s);
    (req_s, resp_r, terminator)
  }

  init { () }

  next(state: ()) {
    // write memory
    let tok = for (addr, tok): (u32, token) in u32:0..u32:64 {
      // create memory request
      let request = memreq {
        addr: addr as u6,
        data: addr,
        we:   true,
        re:   false,
      };
      // send it
      let tok = send(tok, req, request);
      // wait for response
      let (tok, _) = recv(tok, resp);
      tok
    }(join());
    // read memory
    let tok = for (addr, tok): (u32, token) in u32:0..u32:64 {
      // create memory request
      let request = memreq {
        addr: addr as u6,
        data: u32:0,
        we:  false,
        re:  true,
      };
      let tok = send(tok, req, request);
      let (tok, rdata) = recv(tok, resp);
      assert_eq(rdata.data, addr);
      tok
    }(tok);
    let tok = send(tok, term, true);
  }
}

// vector-vector add
pub proc vvadd<size: u32, dw: u32, len: u32, aw: u32 = { std::clog2(size) }> {
  // channels for A vector
  req_A:  chan<memreq<aw, dw>> out;
  resp_A: chan<memresp<dw>>     in;
  // channels for B vector
  req_B:  chan<memreq<aw, dw>> out;
  resp_B: chan<memresp<dw>>     in;
  // channels for C vector
  req_C:  chan<memreq<aw, dw>> out;
  resp_C: chan<memresp<dw>>     in;
  // control/status channels
  start:  chan<bool>            in;
  done:   chan<bool>           out;

  config(req_A: chan<memreq<aw, dw>> out, resp_A: chan<memresp<dw>> in,
         req_B: chan<memreq<aw, dw>> out, resp_B: chan<memresp<dw>> in,
         req_C: chan<memreq<aw, dw>> out, resp_C: chan<memresp<dw>> in,
         start: chan<bool> in, done: chan<bool> out) {
    (req_A, resp_A, req_B, resp_B, req_C, resp_C, start, done)
  }

  init { (bits[aw]: 0, bool: true) }

  next (state: (bits[aw], bool)) {
    // check for "go" message
    let (tok, go) = recv_if(join(), start, state.1, false);
    let (addr, idle) = if go { (bits[aw]:0, false) } else { state };
    // construct read request
    let request = memreq {
      addr: addr,
      data: bits[dw]:0,
      we:  false,
      re:  true,
    };
    // send memory requests
    let tok = send_if(tok, req_A, !idle, request);
    let tok = send_if(tok, req_B, !idle, request);
    // read memory data
    let (tok, a) = recv_if(tok, resp_A, !idle, memresp { data: bits[dw]:0 });
    let (tok, b) = recv_if(tok, resp_B, !idle, memresp { data: bits[dw]:0 });
    // construct write request
    let request = memreq {
      addr: addr,
      data: (a.data + b.data) as bits[dw],
      we:  true,
      re:  false,
    };
    // send request
    let tok = send_if(tok, req_C, !idle, request);
    // check write-ack
    let (tok, _) = recv_if(tok, resp_C, !idle, memresp { data: bits[dw]:0 });
    let d = ((addr as u32) == len - 1);
    let tok = send_if(tok, done, d, true );
    let next_idle = if idle { true } else { d };
    (addr + 1, next_idle)
  }
}

#[test_proc]
proc vvadd_test {
  req_A:  chan<memreq<6, 32>> out;
  resp_A: chan<memresp<32>>   in;
  req_B:  chan<memreq<6, 32>> out;
  resp_B: chan<memresp<32>>   in;
  req_C:  chan<memreq<6, 32>> out;
  resp_C: chan<memresp<32>>   in;
  start:  chan<bool>          out;
  done:   chan<bool>          in;
  term:   chan<bool>          out;

  config(terminator: chan<bool> out) {
    // channels
    let (req_A_s, req_A_r)     = chan<memreq<6,32>>("req_A");
    let (resp_A_s, resp_A_r)   = chan<memresp<32>>("resp_A");
    let (req_B_s, req_B_r)     = chan<memreq<6,32>>("req_B");
    let (resp_B_s, resp_B_r)   = chan<memresp<32>>("resp_B");
    let (req_C_s, req_C_r)     = chan<memreq<6,32>>("req_C");
    let (resp_C_s, resp_C_r)   = chan<memresp<32>>("resp_C");
    let (start_s, start_r)     = chan<bool>("start");
    let (done_s, done_r)       = chan<bool>("done");

    // spawn memories
    spawn ram<u32:64, u32:32>(req_A_r, resp_A_s);
    spawn ram<u32:64, u32:32>(req_B_r, resp_B_s);
    spawn ram<u32:64, u32:32>(req_C_r, resp_C_s);

    // spawn VVADD
    spawn vvadd<u32:64, u32:32, u32:32>(req_A_s, resp_A_r,
                                       req_B_s, resp_B_r,
                                       req_C_s, resp_C_r,
                                       start_r, done_s);

    (req_A_s, resp_A_r,
     req_B_s, resp_B_r,
     req_C_s, resp_C_r,
     start_s, done_r,
     terminator)
  }

  init { () }

  next(state: ()) {
    let tok = join();

    let tok = for (i, tok):(u32, token) in u32:0..u32:32 {
      // A[i] = i
      let reqA = memreq {
        addr: i as u6,
        data: i,
        we:   true,
        re:   false,
      };
      let tok = send(tok, req_A, reqA);
      let (tok, _) = recv(tok, resp_A);

      // B[i] = 2*i
      let reqB = memreq {
        addr: i as u6,
        data: (i * u32:2),
        we:   true,
        re:   false,
      };
      let tok = send(tok, req_B, reqB);
      let (tok, _) = recv(tok, resp_B);

      tok
    }(tok);

    let tok = send(tok, start, true);

    let (tok, _) = recv(tok, done);

    let tok = for (i, tok):(u32, token) in u32:0..u32:32 {
      let req = memreq {
        addr: i as u6,
        data: u32:0,
        we:   false,
        re:   true,
      };
      let tok = send(tok, req_C, req);
      let (tok, r) = recv(tok, resp_C);
      assert_eq(r.data, (i * u32:3));   // C[i] = A[i] + B[i] = 3*i
      tok
    }(tok);

    let tok = send(tok, term, true);
  }
}

// wrapper
pub proc vvadd128 {
  // channels for A, B, C
  req_A:  chan<memreq<7, 32>> out;
  resp_A: chan<memresp<32>>   in;
  req_B:  chan<memreq<7, 32>> out;
  resp_B: chan<memresp<32>>   in;
  req_C:  chan<memreq<7, 32>> out;
  resp_C: chan<memresp<32>>   in;

  // start and done
  start:  chan<bool> in;
  done:   chan<bool> out;

  config(req_A: chan<memreq<7,32>> out, resp_A: chan<memresp<32>> in,
         req_B: chan<memreq<7,32>> out, resp_B: chan<memresp<32>> in,
         req_C: chan<memreq<7,32>> out, resp_C: chan<memresp<32>> in,
         start: chan<bool> in, done: chan<bool> out) {

    spawn vvadd<u32:128, u32:32, u32:128>(req_A, resp_A,
                                          req_B, resp_B,
                                          req_C, resp_C,
                                          start, done);

    (req_A, resp_A, req_B, resp_B, req_C, resp_C, start, done)
  }

  init { () }

  next(state: ()) { state }
}

