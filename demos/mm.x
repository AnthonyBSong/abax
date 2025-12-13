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


pub proc mm {
  mem0__read_req: chan<SimpleReadReq<u32:4>> out;
  mem0__read_resp: chan<SimpleReadResp<u32:32>> in;
  mem1__read_req: chan<SimpleReadReq<u32:4>> out;
  mem1__read_resp: chan<SimpleReadResp<u32:32>> in;
  mem2__write_req: chan<SimpleWriteReq<u32:4, u32:32>> out;
  mem2__write_resp: chan<SimpleWriteResp> in;
  go: chan<bool> in;
  done: chan<bool> out;

  config(mem0__read_req: chan<SimpleReadReq<u32:4>> out, mem0__read_resp: chan<SimpleReadResp<u32:32>> in, mem1__read_req: chan<SimpleReadReq<u32:4>> out, mem1__read_resp: chan<SimpleReadResp<u32:32>> in, mem2__write_req: chan<SimpleWriteReq<u32:4, u32:32>> out, mem2__write_resp: chan<SimpleWriteResp> in, go: chan<bool> in, done: chan<bool> out) { (mem0__read_req, mem0__read_resp, mem1__read_req, mem1__read_resp, mem2__write_req, mem2__write_resp, go, done) }

  init { (0, 0, 0, 0, false) }

  next(state: (s32, s32, s32, s32, bool)) {
    let (acc0, index0, index1, index2, busy) = state;
    let (tok0, tmp0) = recv_if(join(), go, !busy, bool:0);
    let tmp1 = !busy && (tmp0 == bool:1);
    let tmp2 = s32:0;
    let tmp3 = if (index1 < s32:4 && index2 == s32:0) { tmp2 } else { acc0 };
    let tmp4 = ((((index0 as s32) * s32:4) + (index2 as s32)) as uN[4]);
    let tmp5 = SimpleReadReq<u32:4> { addr: tmp4 };
    let tok1 = send(join(), mem0__read_req, tmp5);
    let (tok2, tmp6) = recv(tok1, mem0__read_resp);
    let tmp7 = (tmp6.data as s32);
    let tmp8 = ((((index2 as s32) * s32:4) + (index1 as s32)) as uN[4]);
    let tmp9 = SimpleReadReq<u32:4> { addr: tmp8 };
    let tok3 = send(join(), mem1__read_req, tmp9);
    let (tok4, tmp10) = recv(tok3, mem1__read_resp);
    let tmp11 = (tmp10.data as s32);
    let tmp12 = (tmp7 as s64);
    let tmp13 = (tmp11 as s64);
    let tmp14 = (tmp12 * tmp13);
    let tmp15 = (tmp14 as s32);
    let tmp16 = (tmp3 + tmp15);
    let tmp17 = tmp16;
    let tmp18 = if (index0 < s32:4 && index1 < s32:4 && index2 < s32:4) { tmp17 } else { tmp3 };
    let tmp19 = if (index2 + 1 >= s32:4) { s32:0 } else { index2 + 1 };
    let tmp20 = index2 + 1 >= s32:4;
    let tmp21 = ((((index0 as s32) * s32:4) + (index1 as s32)) as uN[4]);
    let tmp22 = (tmp18 as uN[32]);
    let tmp23 = SimpleWriteReq<u32:4, u32:32> { addr: tmp21, data: tmp22 };
    let tok5 = join(tok0, tok2, tok4);
    let tok6 = send_if(tok5, mem2__write_req, tmp20 && (index1 < s32:4), tmp23);
    let (tok7, _) = recv_if(tok6, mem2__write_resp, tmp20 && (index1 < s32:4), zero!<SimpleWriteResp>());
    let tmp24 = if (tmp20 && index1 + 1 >= s32:4) { s32:0 } else if (tmp20) { index1 + 1 } else { index1 };
    let tmp25 = tmp20 && (index1 + 1 >= s32:4);
    let tmp26 = if (tmp25 && index0 + 1 >= s32:4) { s32:0 } else if (tmp25) { index0 + 1 } else { index0 };
    let tmp27 = tmp25 && (index0 + 1 >= s32:4);
    let tok8 = send_if(tok7, done, tmp27, bool:1);
    let tmp28 = if (tmp27) { 0 } else { tmp18 };
    let tmp29 = if (tmp27) { s32:0 } else { tmp26 };
    let tmp30 = if (tmp27) { s32:0 } else { tmp24 };
    let tmp31 = if (tmp27) { s32:0 } else { tmp19 };
    let tmp32 = (tmp1) || (busy && !tmp27);
    (tmp28, tmp29, tmp30, tmp31, tmp32)
  }
}

#[test_proc]
proc mm_test {
  terminator: chan<bool> out;
  mem0__read_req_s: chan<SimpleReadReq<u32:4>> out;
  mem0__read_resp_r: chan<SimpleReadResp<u32:32>> in;
  mem0__write_req_s: chan<SimpleWriteReq<u32:4, u32:32>> out;
  mem0__write_resp_r: chan<SimpleWriteResp> in;
  mem1__read_req_s: chan<SimpleReadReq<u32:4>> out;
  mem1__read_resp_r: chan<SimpleReadResp<u32:32>> in;
  mem1__write_req_s: chan<SimpleWriteReq<u32:4, u32:32>> out;
  mem1__write_resp_r: chan<SimpleWriteResp> in;
  mem2__read_req_s: chan<SimpleReadReq<u32:4>> out;
  mem2__read_resp_r: chan<SimpleReadResp<u32:32>> in;
  mem2__write_req_s: chan<SimpleWriteReq<u32:4, u32:32>> out;
  mem2__write_resp_r: chan<SimpleWriteResp> in;
  go_s: chan<bool> out;
  done_r: chan<bool> in;

  config(terminator: chan<bool> out) {
    let (mem0__read_req_s, mem0__read_req_r) = chan<SimpleReadReq<u32:4>>("mem0__read_req");
    let (mem0__read_resp_s, mem0__read_resp_r) = chan<SimpleReadResp<u32:32>>("mem0__read_resp");
    let (mem0__write_req_s, mem0__write_req_r) = chan<SimpleWriteReq<u32:4, u32:32>>("mem0__write_req");
    let (mem0__write_resp_s, mem0__write_resp_r) = chan<SimpleWriteResp>("mem0__write_resp");
    spawn Simple1R1WRam<u32:4, u32:32, u32:16>(mem0__read_req_r, mem0__read_resp_s, mem0__write_req_r, mem0__write_resp_s);
    let (mem1__read_req_s, mem1__read_req_r) = chan<SimpleReadReq<u32:4>>("mem1__read_req");
    let (mem1__read_resp_s, mem1__read_resp_r) = chan<SimpleReadResp<u32:32>>("mem1__read_resp");
    let (mem1__write_req_s, mem1__write_req_r) = chan<SimpleWriteReq<u32:4, u32:32>>("mem1__write_req");
    let (mem1__write_resp_s, mem1__write_resp_r) = chan<SimpleWriteResp>("mem1__write_resp");
    spawn Simple1R1WRam<u32:4, u32:32, u32:16>(mem1__read_req_r, mem1__read_resp_s, mem1__write_req_r, mem1__write_resp_s);
    let (mem2__read_req_s, mem2__read_req_r) = chan<SimpleReadReq<u32:4>>("mem2__read_req");
    let (mem2__read_resp_s, mem2__read_resp_r) = chan<SimpleReadResp<u32:32>>("mem2__read_resp");
    let (mem2__write_req_s, mem2__write_req_r) = chan<SimpleWriteReq<u32:4, u32:32>>("mem2__write_req");
    let (mem2__write_resp_s, mem2__write_resp_r) = chan<SimpleWriteResp>("mem2__write_resp");
    spawn Simple1R1WRam<u32:4, u32:32, u32:16>(mem2__read_req_r, mem2__read_resp_s, mem2__write_req_r, mem2__write_resp_s);
    let (go_s, go_r) = chan<bool>("go");
    let (done_s, done_r) = chan<bool>("done");
    spawn mm(mem0__read_req_s, mem0__read_resp_r, mem1__read_req_s, mem1__read_resp_r, mem2__write_req_s, mem2__write_resp_r, go_r, done_s);
    (terminator, mem0__read_req_s, mem0__read_resp_r, mem0__write_req_s, mem0__write_resp_r, mem1__read_req_s, mem1__read_resp_r, mem1__write_req_s, mem1__write_resp_r, mem2__read_req_s, mem2__read_resp_r, mem2__write_req_s, mem2__write_resp_r, go_s, done_r)
  }

  init { () }

  next(state: ()) {
    let tok = join();
    // preload memories
    let tok = send(tok, mem0__write_req_s, SimpleWriteReq<u32:4, u32:32> { addr: uN[4]:0, data: (s32:-1 as uN[32]) });
    let (tok, _) = recv(tok, mem0__write_resp_r);
    let tok = send(tok, mem0__write_req_s, SimpleWriteReq<u32:4, u32:32> { addr: uN[4]:1, data: (s32:0 as uN[32]) });
    let (tok, _) = recv(tok, mem0__write_resp_r);
    let tok = send(tok, mem0__write_req_s, SimpleWriteReq<u32:4, u32:32> { addr: uN[4]:2, data: (s32:1 as uN[32]) });
    let (tok, _) = recv(tok, mem0__write_resp_r);
    let tok = send(tok, mem0__write_req_s, SimpleWriteReq<u32:4, u32:32> { addr: uN[4]:3, data: (s32:2 as uN[32]) });
    let (tok, _) = recv(tok, mem0__write_resp_r);
    let tok = send(tok, mem0__write_req_s, SimpleWriteReq<u32:4, u32:32> { addr: uN[4]:4, data: (s32:3 as uN[32]) });
    let (tok, _) = recv(tok, mem0__write_resp_r);
    let tok = send(tok, mem0__write_req_s, SimpleWriteReq<u32:4, u32:32> { addr: uN[4]:5, data: (s32:4 as uN[32]) });
    let (tok, _) = recv(tok, mem0__write_resp_r);
    let tok = send(tok, mem0__write_req_s, SimpleWriteReq<u32:4, u32:32> { addr: uN[4]:6, data: (s32:5 as uN[32]) });
    let (tok, _) = recv(tok, mem0__write_resp_r);
    let tok = send(tok, mem0__write_req_s, SimpleWriteReq<u32:4, u32:32> { addr: uN[4]:7, data: (s32:6 as uN[32]) });
    let (tok, _) = recv(tok, mem0__write_resp_r);
    let tok = send(tok, mem0__write_req_s, SimpleWriteReq<u32:4, u32:32> { addr: uN[4]:8, data: (s32:7 as uN[32]) });
    let (tok, _) = recv(tok, mem0__write_resp_r);
    let tok = send(tok, mem0__write_req_s, SimpleWriteReq<u32:4, u32:32> { addr: uN[4]:9, data: (s32:8 as uN[32]) });
    let (tok, _) = recv(tok, mem0__write_resp_r);
    let tok = send(tok, mem0__write_req_s, SimpleWriteReq<u32:4, u32:32> { addr: uN[4]:10, data: (s32:9 as uN[32]) });
    let (tok, _) = recv(tok, mem0__write_resp_r);
    let tok = send(tok, mem0__write_req_s, SimpleWriteReq<u32:4, u32:32> { addr: uN[4]:11, data: (s32:10 as uN[32]) });
    let (tok, _) = recv(tok, mem0__write_resp_r);
    let tok = send(tok, mem0__write_req_s, SimpleWriteReq<u32:4, u32:32> { addr: uN[4]:12, data: (s32:11 as uN[32]) });
    let (tok, _) = recv(tok, mem0__write_resp_r);
    let tok = send(tok, mem0__write_req_s, SimpleWriteReq<u32:4, u32:32> { addr: uN[4]:13, data: (s32:12 as uN[32]) });
    let (tok, _) = recv(tok, mem0__write_resp_r);
    let tok = send(tok, mem0__write_req_s, SimpleWriteReq<u32:4, u32:32> { addr: uN[4]:14, data: (s32:13 as uN[32]) });
    let (tok, _) = recv(tok, mem0__write_resp_r);
    let tok = send(tok, mem0__write_req_s, SimpleWriteReq<u32:4, u32:32> { addr: uN[4]:15, data: (s32:14 as uN[32]) });
    let (tok, _) = recv(tok, mem0__write_resp_r);
    let tok = send(tok, mem1__write_req_s, SimpleWriteReq<u32:4, u32:32> { addr: uN[4]:0, data: (s32:2 as uN[32]) });
    let (tok, _) = recv(tok, mem1__write_resp_r);
    let tok = send(tok, mem1__write_req_s, SimpleWriteReq<u32:4, u32:32> { addr: uN[4]:1, data: (s32:3 as uN[32]) });
    let (tok, _) = recv(tok, mem1__write_resp_r);
    let tok = send(tok, mem1__write_req_s, SimpleWriteReq<u32:4, u32:32> { addr: uN[4]:2, data: (s32:4 as uN[32]) });
    let (tok, _) = recv(tok, mem1__write_resp_r);
    let tok = send(tok, mem1__write_req_s, SimpleWriteReq<u32:4, u32:32> { addr: uN[4]:3, data: (s32:5 as uN[32]) });
    let (tok, _) = recv(tok, mem1__write_resp_r);
    let tok = send(tok, mem1__write_req_s, SimpleWriteReq<u32:4, u32:32> { addr: uN[4]:4, data: (s32:6 as uN[32]) });
    let (tok, _) = recv(tok, mem1__write_resp_r);
    let tok = send(tok, mem1__write_req_s, SimpleWriteReq<u32:4, u32:32> { addr: uN[4]:5, data: (s32:7 as uN[32]) });
    let (tok, _) = recv(tok, mem1__write_resp_r);
    let tok = send(tok, mem1__write_req_s, SimpleWriteReq<u32:4, u32:32> { addr: uN[4]:6, data: (s32:8 as uN[32]) });
    let (tok, _) = recv(tok, mem1__write_resp_r);
    let tok = send(tok, mem1__write_req_s, SimpleWriteReq<u32:4, u32:32> { addr: uN[4]:7, data: (s32:9 as uN[32]) });
    let (tok, _) = recv(tok, mem1__write_resp_r);
    let tok = send(tok, mem1__write_req_s, SimpleWriteReq<u32:4, u32:32> { addr: uN[4]:8, data: (s32:10 as uN[32]) });
    let (tok, _) = recv(tok, mem1__write_resp_r);
    let tok = send(tok, mem1__write_req_s, SimpleWriteReq<u32:4, u32:32> { addr: uN[4]:9, data: (s32:11 as uN[32]) });
    let (tok, _) = recv(tok, mem1__write_resp_r);
    let tok = send(tok, mem1__write_req_s, SimpleWriteReq<u32:4, u32:32> { addr: uN[4]:10, data: (s32:12 as uN[32]) });
    let (tok, _) = recv(tok, mem1__write_resp_r);
    let tok = send(tok, mem1__write_req_s, SimpleWriteReq<u32:4, u32:32> { addr: uN[4]:11, data: (s32:13 as uN[32]) });
    let (tok, _) = recv(tok, mem1__write_resp_r);
    let tok = send(tok, mem1__write_req_s, SimpleWriteReq<u32:4, u32:32> { addr: uN[4]:12, data: (s32:14 as uN[32]) });
    let (tok, _) = recv(tok, mem1__write_resp_r);
    let tok = send(tok, mem1__write_req_s, SimpleWriteReq<u32:4, u32:32> { addr: uN[4]:13, data: (s32:15 as uN[32]) });
    let (tok, _) = recv(tok, mem1__write_resp_r);
    let tok = send(tok, mem1__write_req_s, SimpleWriteReq<u32:4, u32:32> { addr: uN[4]:14, data: (s32:16 as uN[32]) });
    let (tok, _) = recv(tok, mem1__write_resp_r);
    let tok = send(tok, mem1__write_req_s, SimpleWriteReq<u32:4, u32:32> { addr: uN[4]:15, data: (s32:17 as uN[32]) });
    let (tok, _) = recv(tok, mem1__write_resp_r);
    // drive scalar inputs
    // start DUT and wait
    let tok = send(tok, go_s, bool:1);
    let (tok, done_flag) = recv(tok, done_r);
    assert_eq(done_flag, bool:1);
    // verify mem2
    let tok = send(tok, mem2__read_req_s, SimpleReadReq<u32:4> { addr: uN[4]:0 });
    let (tok, resp_mem2_val_0) = recv(tok, mem2__read_resp_r);
    let mem2_val_0 = (resp_mem2_val_0.data as s32);
    assert_eq(mem2_val_0, s32:36);
    let tok = send(tok, mem2__read_req_s, SimpleReadReq<u32:4> { addr: uN[4]:1 });
    let (tok, resp_mem2_val_1) = recv(tok, mem2__read_resp_r);
    let mem2_val_1 = (resp_mem2_val_1.data as s32);
    assert_eq(mem2_val_1, s32:38);
    let tok = send(tok, mem2__read_req_s, SimpleReadReq<u32:4> { addr: uN[4]:2 });
    let (tok, resp_mem2_val_2) = recv(tok, mem2__read_resp_r);
    let mem2_val_2 = (resp_mem2_val_2.data as s32);
    assert_eq(mem2_val_2, s32:40);
    let tok = send(tok, mem2__read_req_s, SimpleReadReq<u32:4> { addr: uN[4]:3 });
    let (tok, resp_mem2_val_3) = recv(tok, mem2__read_resp_r);
    let mem2_val_3 = (resp_mem2_val_3.data as s32);
    assert_eq(mem2_val_3, s32:42);
    let tok = send(tok, mem2__read_req_s, SimpleReadReq<u32:4> { addr: uN[4]:4 });
    let (tok, resp_mem2_val_4) = recv(tok, mem2__read_resp_r);
    let mem2_val_4 = (resp_mem2_val_4.data as s32);
    assert_eq(mem2_val_4, s32:164);
    let tok = send(tok, mem2__read_req_s, SimpleReadReq<u32:4> { addr: uN[4]:5 });
    let (tok, resp_mem2_val_5) = recv(tok, mem2__read_resp_r);
    let mem2_val_5 = (resp_mem2_val_5.data as s32);
    assert_eq(mem2_val_5, s32:182);
    let tok = send(tok, mem2__read_req_s, SimpleReadReq<u32:4> { addr: uN[4]:6 });
    let (tok, resp_mem2_val_6) = recv(tok, mem2__read_resp_r);
    let mem2_val_6 = (resp_mem2_val_6.data as s32);
    assert_eq(mem2_val_6, s32:200);
    let tok = send(tok, mem2__read_req_s, SimpleReadReq<u32:4> { addr: uN[4]:7 });
    let (tok, resp_mem2_val_7) = recv(tok, mem2__read_resp_r);
    let mem2_val_7 = (resp_mem2_val_7.data as s32);
    assert_eq(mem2_val_7, s32:218);
    let tok = send(tok, mem2__read_req_s, SimpleReadReq<u32:4> { addr: uN[4]:8 });
    let (tok, resp_mem2_val_8) = recv(tok, mem2__read_resp_r);
    let mem2_val_8 = (resp_mem2_val_8.data as s32);
    assert_eq(mem2_val_8, s32:292);
    let tok = send(tok, mem2__read_req_s, SimpleReadReq<u32:4> { addr: uN[4]:9 });
    let (tok, resp_mem2_val_9) = recv(tok, mem2__read_resp_r);
    let mem2_val_9 = (resp_mem2_val_9.data as s32);
    assert_eq(mem2_val_9, s32:326);
    let tok = send(tok, mem2__read_req_s, SimpleReadReq<u32:4> { addr: uN[4]:10 });
    let (tok, resp_mem2_val_10) = recv(tok, mem2__read_resp_r);
    let mem2_val_10 = (resp_mem2_val_10.data as s32);
    assert_eq(mem2_val_10, s32:360);
    let tok = send(tok, mem2__read_req_s, SimpleReadReq<u32:4> { addr: uN[4]:11 });
    let (tok, resp_mem2_val_11) = recv(tok, mem2__read_resp_r);
    let mem2_val_11 = (resp_mem2_val_11.data as s32);
    assert_eq(mem2_val_11, s32:394);
    let tok = send(tok, mem2__read_req_s, SimpleReadReq<u32:4> { addr: uN[4]:12 });
    let (tok, resp_mem2_val_12) = recv(tok, mem2__read_resp_r);
    let mem2_val_12 = (resp_mem2_val_12.data as s32);
    assert_eq(mem2_val_12, s32:420);
    let tok = send(tok, mem2__read_req_s, SimpleReadReq<u32:4> { addr: uN[4]:13 });
    let (tok, resp_mem2_val_13) = recv(tok, mem2__read_resp_r);
    let mem2_val_13 = (resp_mem2_val_13.data as s32);
    assert_eq(mem2_val_13, s32:470);
    let tok = send(tok, mem2__read_req_s, SimpleReadReq<u32:4> { addr: uN[4]:14 });
    let (tok, resp_mem2_val_14) = recv(tok, mem2__read_resp_r);
    let mem2_val_14 = (resp_mem2_val_14.data as s32);
    assert_eq(mem2_val_14, s32:520);
    let tok = send(tok, mem2__read_req_s, SimpleReadReq<u32:4> { addr: uN[4]:15 });
    let (tok, resp_mem2_val_15) = recv(tok, mem2__read_resp_r);
    let mem2_val_15 = (resp_mem2_val_15.data as s32);
    assert_eq(mem2_val_15, s32:570);
    send(tok, terminator, true);
  }
}
