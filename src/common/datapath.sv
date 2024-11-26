`timescale 1ns / 1ps

module datapath (
    input logic clk,
    input logic reset,
    input logic [15:0] curr_inst,
    input logic regW,
    input logic [7:0] read_data_dmem,
    input logic mem_to_reg,
    input logic aluF,
    input logic addition,
    input logic branch,
    input logic [4:0] curr_inst_addr,
    output logic [3:0] read_addr_dmem,
    output logic [3:0] write_addr_dmem,
    output logic [4:0] next_inst_addr,
    output logic pc_branch,
    output logic [7:0] write_data_dmem
);

  logic immbit;
  assign immbit = curr_inst[12];

  logic [7:0] aluA, aluB, aluR;
  mux2 #(4) wa_dmem_mux (
      .d0(curr_inst[7:4]),
      .d1(curr_inst[11:8]),
      .s (immbit),
      .y (write_addr_dmem)
  );
  mux2 #(8) wd_dmem_mux (
      .d0(aluB),
      .d1(curr_inst[7:0]),
      .s (immbit),
      .y (write_data_dmem)
  );

  logic zero;
  assign pc_branch = zero & branch;

  logic immbit_addition;
  always_comb
    if (immbit || addition) immbit_addition = 1;
    else immbit_addition = 0;

  logic immbit_not_addition;
  assign immbit_not_addition = immbit && !addition;

  logic [7:0] res_mux_out;
  logic [7:0] write_data_rf;
  logic [3:0] write_addr_rf;

  logic [4:0] cur_addr_plus_1;

  // calculate next curr_inst address
  adder #(5) a1 (
      .a(curr_inst_addr),
      .b(5'b00001),
      .c(cur_addr_plus_1)
  );
  mux2 #(5) pc_mux (
      .d0(cur_addr_plus_1),
      .d1(curr_inst[12:8]),
      .s (pc_branch),
      .y (next_inst_addr)
  );

  regfile rf (
      .clk(clk),
      .write_enable(regW),
      .reset(reset),
      .write_addr(write_addr_rf),
      .write_data(write_data_rf),
      .read_addr_1(curr_inst[7:4]),
      .read_addr_2(curr_inst[3:0]),
      .read_data_1(aluA),
      .read_data_2(aluB)
  );
  mux2 #(4) wa_rf_mux (
      .d0(curr_inst[7:4]),
      .d1(curr_inst[11:8]),
      .s (immbit_addition),
      .y (write_addr_rf)
  );
  mux2 #(8) wd_rf_mux (
      .d0(res_mux_out),
      .d1(curr_inst[7:0]),
      .s (immbit_not_addition),
      .y (write_data_rf)
  );
  mux2 #(8) res_mux (
      .d0(aluR),
      .d1(read_data_dmem),
      .s (mem_to_reg),
      .y (res_mux_out)
  );

  ALU alu (
      .a(aluA),
      .b(aluB),
      .f(aluF),
      .y(aluR),
      .zero(zero)
  );

  assign read_addr_dmem = curr_inst[3:0];

endmodule
