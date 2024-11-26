`timescale 1ns / 1ps

module mips (
    input logic clk,
    input logic reset,
    input logic [15:0] curr_inst,
    input logic [7:0] read_data_dm,
    input logic [4:0] curr_inst_addr,
    output logic [4:0] next_inst_addr,
    output logic memW,
    output logic [3:0] write_addr_dm,
    output logic pc_branch,
    output logic halt,
    output logic [7:0] write_data_dm
);

  logic regW, aluF, mem_to_reg, addition, branch;

  controller cc (
      .op(curr_inst[15:13]),
      .memW(memW),
      .regW(regW),
      .aluF(aluF),
      .mem_to_reg(mem_to_reg),
      .addition(addition),
      .branch(branch),
      .halt(halt)
  );

  datapath dp (
      .clk(clk),
      .reset(reset),
      .curr_inst(curr_inst),
      .regW(regW),
      .read_data_dm(read_data_dm),
      .mem_to_reg(mem_to_reg),
      .aluF(aluF),
      .addition(addition),
      .branch(branch),
      .curr_inst_addr(curr_inst_addr),
      .write_addr_dm(write_addr_dm),
      .next_inst_addr(next_inst_addr),
      .pc_branch(pc_branch),
      .write_data_dm(write_data_dm)
  );

endmodule
