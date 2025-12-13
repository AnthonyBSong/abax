// Simple dual-port RAM model with independent read and write ports.
// Parameterized on address width, data width, and depth.
// Reads observe the state before a concurrent write (read-before-write).
// Writes always update a full word.

pub struct SimpleReadReq<ADDR_WIDTH: u32> {
  addr: uN[ADDR_WIDTH],
}

pub struct SimpleReadResp<DATA_WIDTH: u32> {
  data: uN[DATA_WIDTH],
}

pub struct SimpleWriteReq<ADDR_WIDTH: u32, DATA_WIDTH: u32> {
  addr: uN[ADDR_WIDTH],
  data: uN[DATA_WIDTH],
}

pub struct SimpleWriteResp {}

pub proc Simple1R1WRam<ADDR_WIDTH: u32, DATA_WIDTH: u32, SIZE: u32> {
  read_req: chan<SimpleReadReq<ADDR_WIDTH>> in;
  read_resp: chan<SimpleReadResp<DATA_WIDTH>> out;
  write_req: chan<SimpleWriteReq<ADDR_WIDTH, DATA_WIDTH>> in;
  write_resp: chan<SimpleWriteResp> out;

  config(read_req: chan<SimpleReadReq<ADDR_WIDTH>> in,
         read_resp: chan<SimpleReadResp<DATA_WIDTH>> out,
         write_req: chan<SimpleWriteReq<ADDR_WIDTH, DATA_WIDTH>> in,
         write_resp: chan<SimpleWriteResp> out) {
    (read_req, read_resp, write_req, write_resp)
  }

  init { uN[DATA_WIDTH][SIZE]:[uN[DATA_WIDTH]:0, ...] }

  next(state: uN[DATA_WIDTH][SIZE]) {
    let (tok_r, r_req, r_valid) =
        recv_non_blocking(join(), read_req, zero!<SimpleReadReq<ADDR_WIDTH>>());
    let (tok_w, w_req, w_valid) =
        recv_non_blocking(join(), write_req, zero!<SimpleWriteReq<ADDR_WIDTH, DATA_WIDTH>>());

    let addr_r = r_req.addr as u32;
    let addr_w = w_req.addr as u32;

    let state_before_write = state;
    let state =
        if w_valid { update(state, addr_w, w_req.data) } else { state };

    let read_data = state_before_write[addr_r];
    send_if(
        tok_r, read_resp, r_valid,
        SimpleReadResp<DATA_WIDTH> { data: read_data });

    send_if(
        tok_w, write_resp, w_valid,
        SimpleWriteResp {});

    state
  }
}


pub proc kernel {
  mem0__read_req: chan<SimpleReadReq<u32:4>> out;
  mem0__read_resp: chan<SimpleReadResp<u32:32>> in;
  mem1__write_req: chan<SimpleWriteReq<u32:4, u32:32>> out;
  mem1__write_resp: chan<SimpleWriteResp> in;
  go: chan<bool> in;
  done: chan<bool> out;

  config(mem0__read_req: chan<SimpleReadReq<u32:4>> out, mem0__read_resp: chan<SimpleReadResp<u32:32>> in, mem1__write_req: chan<SimpleWriteReq<u32:4, u32:32>> out, mem1__write_resp: chan<SimpleWriteResp> in, go: chan<bool> in, done: chan<bool> out) { (mem0__read_req, mem0__read_resp, mem1__write_req, mem1__write_resp, go, done) }

  init { (0, false) }

  next(state: (s32, bool)) {
    let (index0, busy) = state;
    let (tok0, tmp0) = recv_if(join(), go, !busy, bool:0);
    let tmp1 = !busy && (tmp0 == bool:1);
    let tmp2 = ((index0 as s32) as uN[4]);
    let tmp3 = SimpleReadReq<u32:4> { addr: tmp2 };
    let tok1 = send(join(), mem0__read_req, tmp3);
    let (tok2, tmp4) = recv(tok1, mem0__read_resp);
    let tmp5 = (tmp4.data as s32);
    let tmp6 = (tmp5 as s33);
    let tmp7 = (tmp6 + s33:1);
    let tmp8 = (tmp7 as s32);
    let tmp9 = ((index0 as s32) as uN[4]);
    let tmp10 = (tmp8 as uN[32]);
    let tmp11 = SimpleWriteReq<u32:4, u32:32> { addr: tmp9, data: tmp10 };
    let tok3 = join(tok0, tok2);
    let tok4 = send(tok3, mem1__write_req, tmp11);
    let (tok5, _) = recv(tok4, mem1__write_resp);
    let tmp12 = if (index0 + 1 >= s32:10) { s32:0 } else { index0 + 1 };
    let tmp13 = index0 + 1 >= s32:10;
    let tok6 = send_if(tok5, done, tmp13, bool:1);
    let tmp14 = if (tmp13) { s32:0 } else { tmp12 };
    let tmp15 = (tmp1) || (busy && !tmp13);
    (tmp14, tmp15)
  }
}