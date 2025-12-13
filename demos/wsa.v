module __wsa__wsa_0_next(
  input wire clk,
  input wire rst,
  input wire [31:0] wsa__in0,
  input wire wsa__in0_vld,
  input wire [31:0] wsa__in1,
  input wire wsa__in1_vld,
  input wire wsa__out0_rdy,
  input wire wsa__out1_rdy,
  input wire wsa__out2_rdy,
  output wire wsa__in0_rdy,
  output wire wsa__in1_rdy,
  output wire [31:0] wsa__out0,
  output wire wsa__out0_vld,
  output wire [31:0] wsa__out1,
  output wire wsa__out1_vld,
  output wire [31:0] wsa__out2,
  output wire wsa__out2_vld
);
  reg __wsa__out0_has_been_sent_reg;
  reg __wsa__out1_has_been_sent_reg;
  reg __wsa__out2_has_been_sent_reg;
  reg [31:0] __wsa__in0_reg;
  reg __wsa__in0_valid_reg;
  reg [31:0] __wsa__in1_reg;
  reg __wsa__in1_valid_reg;
  reg [31:0] __wsa__out0_reg;
  reg __wsa__out0_valid_reg;
  reg [31:0] __wsa__out1_reg;
  reg __wsa__out1_valid_reg;
  reg [31:0] __wsa__out2_reg;
  reg __wsa__out2_valid_reg;
  wire p0_all_active_inputs_valid;
  wire __wsa__out0_not_has_been_sent;
  wire wsa__out0_valid_inv;
  wire __wsa__out1_not_has_been_sent;
  wire wsa__out1_valid_inv;
  wire __wsa__out2_not_has_been_sent;
  wire wsa__out2_valid_inv;
  wire __wsa__out0_valid_and_not_has_been_sent;
  wire wsa__out0_valid_load_en;
  wire __wsa__out1_valid_and_not_has_been_sent;
  wire wsa__out1_valid_load_en;
  wire __wsa__out2_valid_and_not_has_been_sent;
  wire wsa__out2_valid_load_en;
  wire wsa__out0_load_en;
  wire wsa__out1_load_en;
  wire wsa__out2_load_en;
  wire __wsa__out0_has_sent_or_is_ready;
  wire __wsa__out1_has_sent_or_is_ready;
  wire __wsa__out2_has_sent_or_is_ready;
  wire p0_all_active_outputs_ready;
  wire p0_stage_done;
  wire wsa__in0_valid_inv;
  wire wsa__in1_valid_inv;
  wire wsa__in0_valid_load_en;
  wire wsa__in1_valid_load_en;
  wire __wsa__out0_valid_and_all_active_outputs_ready;
  wire __wsa__out0_valid_and_ready_txfr;
  wire __wsa__out1_valid_and_ready_txfr;
  wire __wsa__out2_valid_and_ready_txfr;
  wire wsa__in0_load_en;
  wire wsa__in1_load_en;
  wire __wsa__out0_not_stage_load;
  wire __wsa__out0_has_been_sent_reg_load_en;
  wire __wsa__out1_has_been_sent_reg_load_en;
  wire __wsa__out2_has_been_sent_reg_load_en;
  wire [31:0] tmp2;
  wire [31:0] tmp3;
  wire [31:0] tmp4;
  assign p0_all_active_inputs_valid = __wsa__in0_valid_reg & __wsa__in1_valid_reg;
  assign __wsa__out0_not_has_been_sent = ~__wsa__out0_has_been_sent_reg;
  assign wsa__out0_valid_inv = ~__wsa__out0_valid_reg;
  assign __wsa__out1_not_has_been_sent = ~__wsa__out1_has_been_sent_reg;
  assign wsa__out1_valid_inv = ~__wsa__out1_valid_reg;
  assign __wsa__out2_not_has_been_sent = ~__wsa__out2_has_been_sent_reg;
  assign wsa__out2_valid_inv = ~__wsa__out2_valid_reg;
  assign __wsa__out0_valid_and_not_has_been_sent = p0_all_active_inputs_valid & __wsa__out0_not_has_been_sent;
  assign wsa__out0_valid_load_en = wsa__out0_rdy | wsa__out0_valid_inv;
  assign __wsa__out1_valid_and_not_has_been_sent = p0_all_active_inputs_valid & __wsa__out1_not_has_been_sent;
  assign wsa__out1_valid_load_en = wsa__out1_rdy | wsa__out1_valid_inv;
  assign __wsa__out2_valid_and_not_has_been_sent = p0_all_active_inputs_valid & __wsa__out2_not_has_been_sent;
  assign wsa__out2_valid_load_en = wsa__out2_rdy | wsa__out2_valid_inv;
  assign wsa__out0_load_en = __wsa__out0_valid_and_not_has_been_sent & wsa__out0_valid_load_en;
  assign wsa__out1_load_en = __wsa__out1_valid_and_not_has_been_sent & wsa__out1_valid_load_en;
  assign wsa__out2_load_en = __wsa__out2_valid_and_not_has_been_sent & wsa__out2_valid_load_en;
  assign __wsa__out0_has_sent_or_is_ready = wsa__out0_load_en | __wsa__out0_has_been_sent_reg;
  assign __wsa__out1_has_sent_or_is_ready = wsa__out1_load_en | __wsa__out1_has_been_sent_reg;
  assign __wsa__out2_has_sent_or_is_ready = wsa__out2_load_en | __wsa__out2_has_been_sent_reg;
  assign p0_all_active_outputs_ready = __wsa__out0_has_sent_or_is_ready & __wsa__out1_has_sent_or_is_ready & __wsa__out2_has_sent_or_is_ready;
  assign p0_stage_done = p0_all_active_inputs_valid & p0_all_active_outputs_ready;
  assign wsa__in0_valid_inv = ~__wsa__in0_valid_reg;
  assign wsa__in1_valid_inv = ~__wsa__in1_valid_reg;
  assign wsa__in0_valid_load_en = p0_stage_done | wsa__in0_valid_inv;
  assign wsa__in1_valid_load_en = p0_stage_done | wsa__in1_valid_inv;
  assign __wsa__out0_valid_and_all_active_outputs_ready = p0_all_active_inputs_valid & p0_all_active_outputs_ready;
  assign __wsa__out0_valid_and_ready_txfr = __wsa__out0_valid_and_not_has_been_sent & wsa__out0_load_en;
  assign __wsa__out1_valid_and_ready_txfr = __wsa__out1_valid_and_not_has_been_sent & wsa__out1_load_en;
  assign __wsa__out2_valid_and_ready_txfr = __wsa__out2_valid_and_not_has_been_sent & wsa__out2_load_en;
  assign wsa__in0_load_en = wsa__in0_vld & wsa__in0_valid_load_en;
  assign wsa__in1_load_en = wsa__in1_vld & wsa__in1_valid_load_en;
  assign __wsa__out0_not_stage_load = ~__wsa__out0_valid_and_all_active_outputs_ready;
  assign __wsa__out0_has_been_sent_reg_load_en = __wsa__out0_valid_and_ready_txfr | __wsa__out0_valid_and_all_active_outputs_ready;
  assign __wsa__out1_has_been_sent_reg_load_en = __wsa__out1_valid_and_ready_txfr | __wsa__out0_valid_and_all_active_outputs_ready;
  assign __wsa__out2_has_been_sent_reg_load_en = __wsa__out2_valid_and_ready_txfr | __wsa__out0_valid_and_all_active_outputs_ready;
  assign tmp2 = __wsa__in0_reg | __wsa__in1_reg;
  assign tmp3 = __wsa__in0_reg & __wsa__in1_reg;
  assign tmp4 = __wsa__in0_reg ^ __wsa__in1_reg;
  always_ff @ (posedge clk) begin
    if (rst) begin
      __wsa__out0_has_been_sent_reg <= 1'h0;
      __wsa__out1_has_been_sent_reg <= 1'h0;
      __wsa__out2_has_been_sent_reg <= 1'h0;
      __wsa__in0_reg <= 32'h0000_0000;
      __wsa__in0_valid_reg <= 1'h0;
      __wsa__in1_reg <= 32'h0000_0000;
      __wsa__in1_valid_reg <= 1'h0;
      __wsa__out0_reg <= 32'h0000_0000;
      __wsa__out0_valid_reg <= 1'h0;
      __wsa__out1_reg <= 32'h0000_0000;
      __wsa__out1_valid_reg <= 1'h0;
      __wsa__out2_reg <= 32'h0000_0000;
      __wsa__out2_valid_reg <= 1'h0;
    end else begin
      __wsa__out0_has_been_sent_reg <= __wsa__out0_has_been_sent_reg_load_en ? __wsa__out0_not_stage_load : __wsa__out0_has_been_sent_reg;
      __wsa__out1_has_been_sent_reg <= __wsa__out1_has_been_sent_reg_load_en ? __wsa__out0_not_stage_load : __wsa__out1_has_been_sent_reg;
      __wsa__out2_has_been_sent_reg <= __wsa__out2_has_been_sent_reg_load_en ? __wsa__out0_not_stage_load : __wsa__out2_has_been_sent_reg;
      __wsa__in0_reg <= wsa__in0_load_en ? wsa__in0 : __wsa__in0_reg;
      __wsa__in0_valid_reg <= wsa__in0_valid_load_en ? wsa__in0_vld : __wsa__in0_valid_reg;
      __wsa__in1_reg <= wsa__in1_load_en ? wsa__in1 : __wsa__in1_reg;
      __wsa__in1_valid_reg <= wsa__in1_valid_load_en ? wsa__in1_vld : __wsa__in1_valid_reg;
      __wsa__out0_reg <= wsa__out0_load_en ? tmp2 : __wsa__out0_reg;
      __wsa__out0_valid_reg <= wsa__out0_valid_load_en ? __wsa__out0_valid_and_not_has_been_sent : __wsa__out0_valid_reg;
      __wsa__out1_reg <= wsa__out1_load_en ? tmp3 : __wsa__out1_reg;
      __wsa__out1_valid_reg <= wsa__out1_valid_load_en ? __wsa__out1_valid_and_not_has_been_sent : __wsa__out1_valid_reg;
      __wsa__out2_reg <= wsa__out2_load_en ? tmp4 : __wsa__out2_reg;
      __wsa__out2_valid_reg <= wsa__out2_valid_load_en ? __wsa__out2_valid_and_not_has_been_sent : __wsa__out2_valid_reg;
    end
  end
  assign wsa__in0_rdy = wsa__in0_load_en;
  assign wsa__in1_rdy = wsa__in1_load_en;
  assign wsa__out0 = __wsa__out0_reg;
  assign wsa__out0_vld = __wsa__out0_valid_reg;
  assign wsa__out1 = __wsa__out1_reg;
  assign wsa__out1_vld = __wsa__out1_valid_reg;
  assign wsa__out2 = __wsa__out2_reg;
  assign wsa__out2_vld = __wsa__out2_valid_reg;
endmodule
