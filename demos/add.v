module __add__add_0_next(
  input wire clk,
  input wire rst,
  input wire [31:0] add__in0,
  input wire add__in0_vld,
  input wire [31:0] add__in1,
  input wire add__in1_vld,
  input wire add__out0_rdy,
  output wire add__in0_rdy,
  output wire add__in1_rdy,
  output wire [31:0] add__out0,
  output wire add__out0_vld
);
  reg [31:0] __add__in0_reg;
  reg __add__in0_valid_reg;
  reg [31:0] __add__in1_reg;
  reg __add__in1_valid_reg;
  reg [31:0] __add__out0_reg;
  reg __add__out0_valid_reg;
  wire add__out0_valid_inv;
  wire p0_all_active_inputs_valid;
  wire add__out0_valid_load_en;
  wire add__out0_load_en;
  wire p0_stage_done;
  wire add__in0_valid_inv;
  wire add__in1_valid_inv;
  wire add__in0_valid_load_en;
  wire add__in1_valid_load_en;
  wire add__in0_load_en;
  wire add__in1_load_en;
  wire [31:0] tmp4__1;
  assign add__out0_valid_inv = ~__add__out0_valid_reg;
  assign p0_all_active_inputs_valid = __add__in0_valid_reg & __add__in1_valid_reg;
  assign add__out0_valid_load_en = add__out0_rdy | add__out0_valid_inv;
  assign add__out0_load_en = p0_all_active_inputs_valid & add__out0_valid_load_en;
  assign p0_stage_done = p0_all_active_inputs_valid & add__out0_load_en;
  assign add__in0_valid_inv = ~__add__in0_valid_reg;
  assign add__in1_valid_inv = ~__add__in1_valid_reg;
  assign add__in0_valid_load_en = p0_stage_done | add__in0_valid_inv;
  assign add__in1_valid_load_en = p0_stage_done | add__in1_valid_inv;
  assign add__in0_load_en = add__in0_vld & add__in0_valid_load_en;
  assign add__in1_load_en = add__in1_vld & add__in1_valid_load_en;
  assign tmp4__1 = __add__in0_reg + __add__in1_reg;
  always_ff @ (posedge clk) begin
    if (rst) begin
      __add__in0_reg <= 32'h0000_0000;
      __add__in0_valid_reg <= 1'h0;
      __add__in1_reg <= 32'h0000_0000;
      __add__in1_valid_reg <= 1'h0;
      __add__out0_reg <= 32'h0000_0000;
      __add__out0_valid_reg <= 1'h0;
    end else begin
      __add__in0_reg <= add__in0_load_en ? add__in0 : __add__in0_reg;
      __add__in0_valid_reg <= add__in0_valid_load_en ? add__in0_vld : __add__in0_valid_reg;
      __add__in1_reg <= add__in1_load_en ? add__in1 : __add__in1_reg;
      __add__in1_valid_reg <= add__in1_valid_load_en ? add__in1_vld : __add__in1_valid_reg;
      __add__out0_reg <= add__out0_load_en ? tmp4__1 : __add__out0_reg;
      __add__out0_valid_reg <= add__out0_valid_load_en ? p0_all_active_inputs_valid : __add__out0_valid_reg;
    end
  end
  assign add__in0_rdy = add__in0_load_en;
  assign add__in1_rdy = add__in1_load_en;
  assign add__out0 = __add__out0_reg;
  assign add__out0_vld = __add__out0_valid_reg;
endmodule
