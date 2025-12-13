module __mac__mac_0_next(
  input wire clk,
  input wire rst,
  input wire [31:0] mac__in0,
  input wire mac__in0_vld,
  input wire [31:0] mac__in1,
  input wire mac__in1_vld,
  input wire [31:0] mac__in2,
  input wire mac__in2_vld,
  input wire mac__out0_rdy,
  output wire mac__in0_rdy,
  output wire mac__in1_rdy,
  output wire mac__in2_rdy,
  output wire [31:0] mac__out0,
  output wire mac__out0_vld
);
  // lint_off SIGNED_TYPE
  // lint_off MULTIPLY
  function automatic [31:0] smul32b_32b_x_32b (input reg [31:0] lhs, input reg [31:0] rhs);
    reg signed [31:0] signed_lhs;
    reg signed [31:0] signed_rhs;
    reg signed [31:0] signed_result;
    begin
      signed_lhs = $signed(lhs);
      signed_rhs = $signed(rhs);
      signed_result = signed_lhs * signed_rhs;
      smul32b_32b_x_32b = $unsigned(signed_result);
    end
  endfunction
  // lint_on MULTIPLY
  // lint_on SIGNED_TYPE
  reg [31:0] __mac__in0_reg;
  reg __mac__in0_valid_reg;
  reg [31:0] __mac__in1_reg;
  reg __mac__in1_valid_reg;
  reg [31:0] __mac__in2_reg;
  reg __mac__in2_valid_reg;
  reg [31:0] __mac__out0_reg;
  reg __mac__out0_valid_reg;
  wire mac__out0_valid_inv;
  wire p0_all_active_inputs_valid;
  wire mac__out0_valid_load_en;
  wire mac__out0_load_en;
  wire p0_stage_done;
  wire mac__in0_valid_inv;
  wire mac__in1_valid_inv;
  wire mac__in2_valid_inv;
  wire mac__in0_valid_load_en;
  wire mac__in1_valid_load_en;
  wire mac__in2_valid_load_en;
  wire [31:0] smul_90;
  wire mac__in0_load_en;
  wire mac__in1_load_en;
  wire mac__in2_load_en;
  wire [31:0] tmp8__1;
  assign mac__out0_valid_inv = ~__mac__out0_valid_reg;
  assign p0_all_active_inputs_valid = __mac__in0_valid_reg & __mac__in1_valid_reg & __mac__in2_valid_reg;
  assign mac__out0_valid_load_en = mac__out0_rdy | mac__out0_valid_inv;
  assign mac__out0_load_en = p0_all_active_inputs_valid & mac__out0_valid_load_en;
  assign p0_stage_done = p0_all_active_inputs_valid & mac__out0_load_en;
  assign mac__in0_valid_inv = ~__mac__in0_valid_reg;
  assign mac__in1_valid_inv = ~__mac__in1_valid_reg;
  assign mac__in2_valid_inv = ~__mac__in2_valid_reg;
  assign mac__in0_valid_load_en = p0_stage_done | mac__in0_valid_inv;
  assign mac__in1_valid_load_en = p0_stage_done | mac__in1_valid_inv;
  assign mac__in2_valid_load_en = p0_stage_done | mac__in2_valid_inv;
  assign smul_90 = smul32b_32b_x_32b(__mac__in0_reg, __mac__in1_reg);
  assign mac__in0_load_en = mac__in0_vld & mac__in0_valid_load_en;
  assign mac__in1_load_en = mac__in1_vld & mac__in1_valid_load_en;
  assign mac__in2_load_en = mac__in2_vld & mac__in2_valid_load_en;
  assign tmp8__1 = smul_90 + __mac__in2_reg;
  always_ff @ (posedge clk) begin
    if (rst) begin
      __mac__in0_reg <= 32'h0000_0000;
      __mac__in0_valid_reg <= 1'h0;
      __mac__in1_reg <= 32'h0000_0000;
      __mac__in1_valid_reg <= 1'h0;
      __mac__in2_reg <= 32'h0000_0000;
      __mac__in2_valid_reg <= 1'h0;
      __mac__out0_reg <= 32'h0000_0000;
      __mac__out0_valid_reg <= 1'h0;
    end else begin
      __mac__in0_reg <= mac__in0_load_en ? mac__in0 : __mac__in0_reg;
      __mac__in0_valid_reg <= mac__in0_valid_load_en ? mac__in0_vld : __mac__in0_valid_reg;
      __mac__in1_reg <= mac__in1_load_en ? mac__in1 : __mac__in1_reg;
      __mac__in1_valid_reg <= mac__in1_valid_load_en ? mac__in1_vld : __mac__in1_valid_reg;
      __mac__in2_reg <= mac__in2_load_en ? mac__in2 : __mac__in2_reg;
      __mac__in2_valid_reg <= mac__in2_valid_load_en ? mac__in2_vld : __mac__in2_valid_reg;
      __mac__out0_reg <= mac__out0_load_en ? tmp8__1 : __mac__out0_reg;
      __mac__out0_valid_reg <= mac__out0_valid_load_en ? p0_all_active_inputs_valid : __mac__out0_valid_reg;
    end
  end
  assign mac__in0_rdy = mac__in0_load_en;
  assign mac__in1_rdy = mac__in1_load_en;
  assign mac__in2_rdy = mac__in2_load_en;
  assign mac__out0 = __mac__out0_reg;
  assign mac__out0_vld = __mac__out0_valid_reg;
endmodule
