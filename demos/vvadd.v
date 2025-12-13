module __vvadd__vvadd_0_next(
  input wire clk,
  input wire rst,
  input wire vvadd__done_rdy,
  input wire vvadd__go,
  input wire vvadd__go_vld,
  input wire vvadd__mem0__read_req_rdy,
  input wire [31:0] vvadd__mem0__read_resp,
  input wire vvadd__mem0__read_resp_vld,
  input wire vvadd__mem1__read_req_rdy,
  input wire [31:0] vvadd__mem1__read_resp,
  input wire vvadd__mem1__read_resp_vld,
  input wire vvadd__mem2__write_req_rdy,
  input wire vvadd__mem2__write_resp_vld,
  output wire vvadd__done,
  output wire vvadd__done_vld,
  output wire vvadd__go_rdy,
  output wire [3:0] vvadd__mem0__read_req,
  output wire vvadd__mem0__read_req_vld,
  output wire vvadd__mem0__read_resp_rdy,
  output wire [3:0] vvadd__mem1__read_req,
  output wire vvadd__mem1__read_req_vld,
  output wire vvadd__mem1__read_resp_rdy,
  output wire [35:0] vvadd__mem2__write_req,
  output wire vvadd__mem2__write_req_vld,
  output wire vvadd__mem2__write_resp_rdy
);
  wire [31:0] __vvadd__mem0__read_resp_reg_init = 32'h0000_0000;
  wire [31:0] __vvadd__mem1__read_resp_reg_init = 32'h0000_0000;
  wire [3:0] __vvadd__mem0__read_req_reg_init = 4'h0;
  wire [3:0] __vvadd__mem1__read_req_reg_init = 4'h0;
  wire [35:0] __vvadd__mem2__write_req_reg_init = {4'h0, 32'h0000_0000};
  reg [3:0] ____state_0;
  reg ____state_1;
  reg [3:0] p0_____state_0__1;
  reg p0_tmp18;
  reg p1_tmp18;
  reg p0_valid;
  reg p1_valid;
  reg p2_valid;
  reg __vvadd__mem0__read_req_has_been_sent_reg;
  reg __vvadd__mem1__read_req_has_been_sent_reg;
  reg __vvadd__mem2__write_req_has_been_sent_reg;
  reg __vvadd__done_has_been_sent_reg;
  reg __vvadd__go_reg;
  reg __vvadd__go_valid_reg;
  reg [31:0] __vvadd__mem0__read_resp_reg;
  reg __vvadd__mem0__read_resp_valid_reg;
  reg [31:0] __vvadd__mem1__read_resp_reg;
  reg __vvadd__mem1__read_resp_valid_reg;
  reg __vvadd__mem2__write_resp_valid_reg;
  reg [3:0] __vvadd__mem0__read_req_reg;
  reg __vvadd__mem0__read_req_valid_reg;
  reg [3:0] __vvadd__mem1__read_req_reg;
  reg __vvadd__mem1__read_req_valid_reg;
  reg [35:0] __vvadd__mem2__write_req_reg;
  reg __vvadd__mem2__write_req_valid_reg;
  reg __vvadd__done_reg;
  reg __vvadd__done_valid_reg;
  wire __vvadd__done_vld_buf;
  wire __vvadd__done_not_has_been_sent;
  wire vvadd__done_valid_inv;
  wire __vvadd__done_valid_and_not_has_been_sent;
  wire vvadd__done_valid_load_en;
  wire vvadd__done_load_en;
  wire or_524;
  wire p2_stage_done;
  wire p2_not_valid;
  wire p1_all_active_inputs_valid;
  wire p1_enable;
  wire __vvadd__mem2__write_req_vld_buf;
  wire __vvadd__mem2__write_req_not_has_been_sent;
  wire vvadd__mem2__write_req_valid_inv;
  wire __vvadd__mem2__write_req_valid_and_not_has_been_sent;
  wire vvadd__mem2__write_req_valid_load_en;
  wire vvadd__mem2__write_req_load_en;
  wire __vvadd__mem2__write_req_has_sent_or_is_ready;
  wire p1_stage_done;
  wire p1_data_enable;
  wire p1_not_valid;
  wire or_327;
  wire p0_enable;
  wire __vvadd__mem0__read_req_vld_buf;
  wire __vvadd__mem0__read_req_not_has_been_sent;
  wire vvadd__mem0__read_req_valid_inv;
  wire __vvadd__mem1__read_req_not_has_been_sent;
  wire vvadd__mem1__read_req_valid_inv;
  wire __vvadd__mem0__read_req_valid_and_not_has_been_sent;
  wire vvadd__mem0__read_req_valid_load_en;
  wire __vvadd__mem1__read_req_valid_and_not_has_been_sent;
  wire vvadd__mem1__read_req_valid_load_en;
  wire [4:0] add_269;
  wire vvadd__mem0__read_req_load_en;
  wire vvadd__mem1__read_req_load_en;
  wire tmp18;
  wire __vvadd__mem0__read_req_has_sent_or_is_ready;
  wire __vvadd__mem1__read_req_has_sent_or_is_ready;
  wire p0_all_active_outputs_ready;
  wire [1:0] ____state_0__next_value_predicates;
  wire p0_stage_done;
  wire [2:0] one_hot_280;
  wire p0_data_enable;
  wire vvadd__go_select;
  wire vvadd__go_valid_inv;
  wire vvadd__mem0__read_resp_valid_inv;
  wire vvadd__mem1__read_resp_valid_inv;
  wire vvadd__mem2__write_resp_valid_inv;
  wire and_373;
  wire and_374;
  wire [31:0] tmp4_data;
  wire [31:0] tmp8_data;
  wire vvadd__go_valid_load_en;
  wire vvadd__mem0__read_resp_valid_load_en;
  wire vvadd__mem1__read_resp_valid_load_en;
  wire vvadd__mem2__write_resp_valid_load_en;
  wire ____state_0__at_most_one_next_value;
  wire tmp1;
  wire [1:0] concat_375;
  wire [3:0] unexpand_for_next_value_78_0_case_1;
  wire [3:0] unexpand_for_next_value_78_0_case_0;
  wire __vvadd__mem0__read_req_valid_and_all_active_outputs_ready;
  wire __vvadd__mem0__read_req_valid_and_ready_txfr;
  wire __vvadd__mem1__read_req_valid_and_ready_txfr;
  wire __vvadd__mem2__write_req_valid_and_all_active_outputs_ready;
  wire __vvadd__mem2__write_req_valid_and_ready_txfr;
  wire __vvadd__done_valid_and_all_active_outputs_ready;
  wire __vvadd__done_valid_and_ready_txfr;
  wire [31:0] tmp12__1;
  wire vvadd__go_load_en;
  wire vvadd__mem0__read_resp_load_en;
  wire vvadd__mem1__read_resp_load_en;
  wire vvadd__mem2__write_resp_load_en;
  wire or_523;
  wire p2_enable;
  wire tmp20;
  wire [3:0] one_hot_sel_376;
  wire or_377;
  wire __vvadd__mem0__read_req_not_stage_load;
  wire __vvadd__mem0__read_req_has_been_sent_reg_load_en;
  wire __vvadd__mem1__read_req_has_been_sent_reg_load_en;
  wire __vvadd__mem2__write_req_not_stage_load;
  wire __vvadd__mem2__write_req_has_been_sent_reg_load_en;
  wire __vvadd__done_not_stage_load;
  wire __vvadd__done_has_been_sent_reg_load_en;
  wire [3:0] tmp3;
  wire [35:0] tmp16;
  wire __vvadd__done_buf;
  assign __vvadd__done_vld_buf = __vvadd__mem2__write_resp_valid_reg & p1_valid & p1_tmp18;
  assign __vvadd__done_not_has_been_sent = ~__vvadd__done_has_been_sent_reg;
  assign vvadd__done_valid_inv = ~__vvadd__done_valid_reg;
  assign __vvadd__done_valid_and_not_has_been_sent = __vvadd__done_vld_buf & __vvadd__done_not_has_been_sent;
  assign vvadd__done_valid_load_en = vvadd__done_rdy | vvadd__done_valid_inv;
  assign vvadd__done_load_en = __vvadd__done_valid_and_not_has_been_sent & vvadd__done_valid_load_en;
  assign or_524 = ~p1_tmp18 | vvadd__done_load_en | __vvadd__done_has_been_sent_reg;
  assign p2_stage_done = p1_valid & __vvadd__mem2__write_resp_valid_reg & or_524;
  assign p2_not_valid = ~p1_valid;
  assign p1_all_active_inputs_valid = __vvadd__mem0__read_resp_valid_reg & __vvadd__mem1__read_resp_valid_reg;
  assign p1_enable = p2_stage_done | p2_not_valid;
  assign __vvadd__mem2__write_req_vld_buf = p1_all_active_inputs_valid & p0_valid & p1_enable;
  assign __vvadd__mem2__write_req_not_has_been_sent = ~__vvadd__mem2__write_req_has_been_sent_reg;
  assign vvadd__mem2__write_req_valid_inv = ~__vvadd__mem2__write_req_valid_reg;
  assign __vvadd__mem2__write_req_valid_and_not_has_been_sent = __vvadd__mem2__write_req_vld_buf & __vvadd__mem2__write_req_not_has_been_sent;
  assign vvadd__mem2__write_req_valid_load_en = vvadd__mem2__write_req_rdy | vvadd__mem2__write_req_valid_inv;
  assign vvadd__mem2__write_req_load_en = __vvadd__mem2__write_req_valid_and_not_has_been_sent & vvadd__mem2__write_req_valid_load_en;
  assign __vvadd__mem2__write_req_has_sent_or_is_ready = vvadd__mem2__write_req_load_en | __vvadd__mem2__write_req_has_been_sent_reg;
  assign p1_stage_done = p0_valid & p1_all_active_inputs_valid & __vvadd__mem2__write_req_has_sent_or_is_ready;
  assign p1_data_enable = p1_enable & p1_stage_done;
  assign p1_not_valid = ~p0_valid;
  assign or_327 = ____state_1 | __vvadd__go_valid_reg;
  assign p0_enable = p1_data_enable | p1_not_valid;
  assign __vvadd__mem0__read_req_vld_buf = or_327 & p0_enable;
  assign __vvadd__mem0__read_req_not_has_been_sent = ~__vvadd__mem0__read_req_has_been_sent_reg;
  assign vvadd__mem0__read_req_valid_inv = ~__vvadd__mem0__read_req_valid_reg;
  assign __vvadd__mem1__read_req_not_has_been_sent = ~__vvadd__mem1__read_req_has_been_sent_reg;
  assign vvadd__mem1__read_req_valid_inv = ~__vvadd__mem1__read_req_valid_reg;
  assign __vvadd__mem0__read_req_valid_and_not_has_been_sent = __vvadd__mem0__read_req_vld_buf & __vvadd__mem0__read_req_not_has_been_sent;
  assign vvadd__mem0__read_req_valid_load_en = vvadd__mem0__read_req_rdy | vvadd__mem0__read_req_valid_inv;
  assign __vvadd__mem1__read_req_valid_and_not_has_been_sent = __vvadd__mem0__read_req_vld_buf & __vvadd__mem1__read_req_not_has_been_sent;
  assign vvadd__mem1__read_req_valid_load_en = vvadd__mem1__read_req_rdy | vvadd__mem1__read_req_valid_inv;
  assign add_269 = {1'h0, ____state_0} + 5'h01;
  assign vvadd__mem0__read_req_load_en = __vvadd__mem0__read_req_valid_and_not_has_been_sent & vvadd__mem0__read_req_valid_load_en;
  assign vvadd__mem1__read_req_load_en = __vvadd__mem1__read_req_valid_and_not_has_been_sent & vvadd__mem1__read_req_valid_load_en;
  assign tmp18 = add_269[4];
  assign __vvadd__mem0__read_req_has_sent_or_is_ready = vvadd__mem0__read_req_load_en | __vvadd__mem0__read_req_has_been_sent_reg;
  assign __vvadd__mem1__read_req_has_sent_or_is_ready = vvadd__mem1__read_req_load_en | __vvadd__mem1__read_req_has_been_sent_reg;
  assign p0_all_active_outputs_ready = __vvadd__mem0__read_req_has_sent_or_is_ready & __vvadd__mem1__read_req_has_sent_or_is_ready;
  assign ____state_0__next_value_predicates = {~tmp18, tmp18};
  assign p0_stage_done = or_327 & p0_all_active_outputs_ready;
  assign one_hot_280 = {____state_0__next_value_predicates[1:0] == 2'h0, ____state_0__next_value_predicates[1] && !____state_0__next_value_predicates[0], ____state_0__next_value_predicates[0]};
  assign p0_data_enable = p0_enable & p0_stage_done;
  assign vvadd__go_select = ~____state_1 ? __vvadd__go_reg : 1'h0;
  assign vvadd__go_valid_inv = ~__vvadd__go_valid_reg;
  assign vvadd__mem0__read_resp_valid_inv = ~__vvadd__mem0__read_resp_valid_reg;
  assign vvadd__mem1__read_resp_valid_inv = ~__vvadd__mem1__read_resp_valid_reg;
  assign vvadd__mem2__write_resp_valid_inv = ~__vvadd__mem2__write_resp_valid_reg;
  assign and_373 = ~tmp18 & p0_data_enable;
  assign and_374 = tmp18 & p0_data_enable;
  assign tmp4_data = __vvadd__mem0__read_resp_reg[31:0];
  assign tmp8_data = __vvadd__mem1__read_resp_reg[31:0];
  assign vvadd__go_valid_load_en = p0_data_enable & ~____state_1 | vvadd__go_valid_inv;
  assign vvadd__mem0__read_resp_valid_load_en = p1_data_enable | vvadd__mem0__read_resp_valid_inv;
  assign vvadd__mem1__read_resp_valid_load_en = p1_data_enable | vvadd__mem1__read_resp_valid_inv;
  assign vvadd__mem2__write_resp_valid_load_en = p2_stage_done | vvadd__mem2__write_resp_valid_inv;
  assign ____state_0__at_most_one_next_value = ~tmp18 == one_hot_280[1] & tmp18 == one_hot_280[0];
  assign tmp1 = ~(____state_1 | ~vvadd__go_select);
  assign concat_375 = {and_373, and_374};
  assign unexpand_for_next_value_78_0_case_1 = 4'h0;
  assign unexpand_for_next_value_78_0_case_0 = add_269[3:0];
  assign __vvadd__mem0__read_req_valid_and_all_active_outputs_ready = __vvadd__mem0__read_req_vld_buf & p0_all_active_outputs_ready;
  assign __vvadd__mem0__read_req_valid_and_ready_txfr = __vvadd__mem0__read_req_valid_and_not_has_been_sent & vvadd__mem0__read_req_load_en;
  assign __vvadd__mem1__read_req_valid_and_ready_txfr = __vvadd__mem1__read_req_valid_and_not_has_been_sent & vvadd__mem1__read_req_load_en;
  assign __vvadd__mem2__write_req_valid_and_all_active_outputs_ready = __vvadd__mem2__write_req_vld_buf & vvadd__mem2__write_req_load_en;
  assign __vvadd__mem2__write_req_valid_and_ready_txfr = __vvadd__mem2__write_req_valid_and_not_has_been_sent & vvadd__mem2__write_req_load_en;
  assign __vvadd__done_valid_and_all_active_outputs_ready = __vvadd__done_vld_buf & or_524;
  assign __vvadd__done_valid_and_ready_txfr = __vvadd__done_valid_and_not_has_been_sent & vvadd__done_load_en;
  assign tmp12__1 = tmp4_data + tmp8_data;
  assign vvadd__go_load_en = vvadd__go_vld & vvadd__go_valid_load_en;
  assign vvadd__mem0__read_resp_load_en = vvadd__mem0__read_resp_vld & vvadd__mem0__read_resp_valid_load_en;
  assign vvadd__mem1__read_resp_load_en = vvadd__mem1__read_resp_vld & vvadd__mem1__read_resp_valid_load_en;
  assign vvadd__mem2__write_resp_load_en = vvadd__mem2__write_resp_vld & vvadd__mem2__write_resp_valid_load_en;
  assign or_523 = ~p0_stage_done | ____state_0__at_most_one_next_value | rst;
  assign p2_enable = 1'h1;
  assign tmp20 = tmp1 | ~(~____state_1 | tmp18);
  assign one_hot_sel_376 = unexpand_for_next_value_78_0_case_1 & {4{concat_375[0]}} | unexpand_for_next_value_78_0_case_0 & {4{concat_375[1]}};
  assign or_377 = and_373 | and_374;
  assign __vvadd__mem0__read_req_not_stage_load = ~__vvadd__mem0__read_req_valid_and_all_active_outputs_ready;
  assign __vvadd__mem0__read_req_has_been_sent_reg_load_en = __vvadd__mem0__read_req_valid_and_ready_txfr | __vvadd__mem0__read_req_valid_and_all_active_outputs_ready;
  assign __vvadd__mem1__read_req_has_been_sent_reg_load_en = __vvadd__mem1__read_req_valid_and_ready_txfr | __vvadd__mem0__read_req_valid_and_all_active_outputs_ready;
  assign __vvadd__mem2__write_req_not_stage_load = ~__vvadd__mem2__write_req_valid_and_all_active_outputs_ready;
  assign __vvadd__mem2__write_req_has_been_sent_reg_load_en = __vvadd__mem2__write_req_valid_and_ready_txfr | __vvadd__mem2__write_req_valid_and_all_active_outputs_ready;
  assign __vvadd__done_not_stage_load = ~__vvadd__done_valid_and_all_active_outputs_ready;
  assign __vvadd__done_has_been_sent_reg_load_en = __vvadd__done_valid_and_ready_txfr | __vvadd__done_valid_and_all_active_outputs_ready;
  assign tmp3 = {____state_0};
  assign tmp16 = {p0_____state_0__1, tmp12__1};
  assign __vvadd__done_buf = 1'h1;
  always_ff @ (posedge clk) begin
    if (rst) begin
      ____state_0 <= 4'h0;
      ____state_1 <= 1'h0;
      p0_____state_0__1 <= 4'h0;
      p0_tmp18 <= 1'h0;
      p1_tmp18 <= 1'h0;
      p0_valid <= 1'h0;
      p1_valid <= 1'h0;
      p2_valid <= 1'h0;
      __vvadd__mem0__read_req_has_been_sent_reg <= 1'h0;
      __vvadd__mem1__read_req_has_been_sent_reg <= 1'h0;
      __vvadd__mem2__write_req_has_been_sent_reg <= 1'h0;
      __vvadd__done_has_been_sent_reg <= 1'h0;
      __vvadd__go_reg <= 1'h0;
      __vvadd__go_valid_reg <= 1'h0;
      __vvadd__mem0__read_resp_reg <= __vvadd__mem0__read_resp_reg_init;
      __vvadd__mem0__read_resp_valid_reg <= 1'h0;
      __vvadd__mem1__read_resp_reg <= __vvadd__mem1__read_resp_reg_init;
      __vvadd__mem1__read_resp_valid_reg <= 1'h0;
      __vvadd__mem2__write_resp_valid_reg <= 1'h0;
      __vvadd__mem0__read_req_reg <= __vvadd__mem0__read_req_reg_init;
      __vvadd__mem0__read_req_valid_reg <= 1'h0;
      __vvadd__mem1__read_req_reg <= __vvadd__mem1__read_req_reg_init;
      __vvadd__mem1__read_req_valid_reg <= 1'h0;
      __vvadd__mem2__write_req_reg <= __vvadd__mem2__write_req_reg_init;
      __vvadd__mem2__write_req_valid_reg <= 1'h0;
      __vvadd__done_reg <= 1'h0;
      __vvadd__done_valid_reg <= 1'h0;
    end else begin
      ____state_0 <= or_377 ? one_hot_sel_376 : ____state_0;
      ____state_1 <= p0_data_enable ? tmp20 : ____state_1;
      p0_____state_0__1 <= p0_data_enable ? ____state_0 : p0_____state_0__1;
      p0_tmp18 <= p0_data_enable ? tmp18 : p0_tmp18;
      p1_tmp18 <= p1_data_enable ? p0_tmp18 : p1_tmp18;
      p0_valid <= p0_enable ? p0_stage_done : p0_valid;
      p1_valid <= p1_enable ? p1_stage_done : p1_valid;
      p2_valid <= p2_enable ? p2_stage_done : p2_valid;
      __vvadd__mem0__read_req_has_been_sent_reg <= __vvadd__mem0__read_req_has_been_sent_reg_load_en ? __vvadd__mem0__read_req_not_stage_load : __vvadd__mem0__read_req_has_been_sent_reg;
      __vvadd__mem1__read_req_has_been_sent_reg <= __vvadd__mem1__read_req_has_been_sent_reg_load_en ? __vvadd__mem0__read_req_not_stage_load : __vvadd__mem1__read_req_has_been_sent_reg;
      __vvadd__mem2__write_req_has_been_sent_reg <= __vvadd__mem2__write_req_has_been_sent_reg_load_en ? __vvadd__mem2__write_req_not_stage_load : __vvadd__mem2__write_req_has_been_sent_reg;
      __vvadd__done_has_been_sent_reg <= __vvadd__done_has_been_sent_reg_load_en ? __vvadd__done_not_stage_load : __vvadd__done_has_been_sent_reg;
      __vvadd__go_reg <= vvadd__go_load_en ? vvadd__go : __vvadd__go_reg;
      __vvadd__go_valid_reg <= vvadd__go_valid_load_en ? vvadd__go_vld : __vvadd__go_valid_reg;
      __vvadd__mem0__read_resp_reg <= vvadd__mem0__read_resp_load_en ? vvadd__mem0__read_resp : __vvadd__mem0__read_resp_reg;
      __vvadd__mem0__read_resp_valid_reg <= vvadd__mem0__read_resp_valid_load_en ? vvadd__mem0__read_resp_vld : __vvadd__mem0__read_resp_valid_reg;
      __vvadd__mem1__read_resp_reg <= vvadd__mem1__read_resp_load_en ? vvadd__mem1__read_resp : __vvadd__mem1__read_resp_reg;
      __vvadd__mem1__read_resp_valid_reg <= vvadd__mem1__read_resp_valid_load_en ? vvadd__mem1__read_resp_vld : __vvadd__mem1__read_resp_valid_reg;
      __vvadd__mem2__write_resp_valid_reg <= vvadd__mem2__write_resp_valid_load_en ? vvadd__mem2__write_resp_vld : __vvadd__mem2__write_resp_valid_reg;
      __vvadd__mem0__read_req_reg <= vvadd__mem0__read_req_load_en ? tmp3 : __vvadd__mem0__read_req_reg;
      __vvadd__mem0__read_req_valid_reg <= vvadd__mem0__read_req_valid_load_en ? __vvadd__mem0__read_req_valid_and_not_has_been_sent : __vvadd__mem0__read_req_valid_reg;
      __vvadd__mem1__read_req_reg <= vvadd__mem1__read_req_load_en ? tmp3 : __vvadd__mem1__read_req_reg;
      __vvadd__mem1__read_req_valid_reg <= vvadd__mem1__read_req_valid_load_en ? __vvadd__mem1__read_req_valid_and_not_has_been_sent : __vvadd__mem1__read_req_valid_reg;
      __vvadd__mem2__write_req_reg <= vvadd__mem2__write_req_load_en ? tmp16 : __vvadd__mem2__write_req_reg;
      __vvadd__mem2__write_req_valid_reg <= vvadd__mem2__write_req_valid_load_en ? __vvadd__mem2__write_req_valid_and_not_has_been_sent : __vvadd__mem2__write_req_valid_reg;
      __vvadd__done_reg <= vvadd__done_load_en ? __vvadd__done_buf : __vvadd__done_reg;
      __vvadd__done_valid_reg <= vvadd__done_valid_load_en ? __vvadd__done_valid_and_not_has_been_sent : __vvadd__done_valid_reg;
    end
  end
  assign vvadd__done = __vvadd__done_reg;
  assign vvadd__done_vld = __vvadd__done_valid_reg;
  assign vvadd__go_rdy = vvadd__go_load_en;
  assign vvadd__mem0__read_req = __vvadd__mem0__read_req_reg;
  assign vvadd__mem0__read_req_vld = __vvadd__mem0__read_req_valid_reg;
  assign vvadd__mem0__read_resp_rdy = vvadd__mem0__read_resp_load_en;
  assign vvadd__mem1__read_req = __vvadd__mem1__read_req_reg;
  assign vvadd__mem1__read_req_vld = __vvadd__mem1__read_req_valid_reg;
  assign vvadd__mem1__read_resp_rdy = vvadd__mem1__read_resp_load_en;
  assign vvadd__mem2__write_req = __vvadd__mem2__write_req_reg;
  assign vvadd__mem2__write_req_vld = __vvadd__mem2__write_req_valid_reg;
  assign vvadd__mem2__write_resp_rdy = vvadd__mem2__write_resp_load_en;
  `ifdef ASSERT_ON
  ____state_0__at_most_one_next_value_assert: assert property (@(posedge clk) disable iff ($sampled(rst !== 1'h0 || $isunknown(or_523))) or_523) else $fatal(0, "More than one next_value fired for state element: __state_0");
  `endif  // ASSERT_ON
endmodule
