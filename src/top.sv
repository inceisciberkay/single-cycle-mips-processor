`timescale 1ns / 1ps

module top (
    input logic clk,
    input logic reset,
    output logic [4:0] curr_inst_addr,
    output logic [4:0] next_inst_addr,
    output logic [15:0] curr_inst,
    output logic pc_branch,
    output logic [3:0] read_addr_dmem,
    output logic [7:0] read_data_dmem,
    output logic [3:0] write_addr_dmem,
    output logic [7:0] write_data_dmem
);

  logic memW;
  logic halt;

  logic [3:0] read_addr_dummy;
  logic [7:0] read_data_dummy;

  PC pc (
      .clk(clk),
      .enable(1'b1),
      .reset(reset),
      .next_inst_addr(next_inst_addr),
      .pc_src(pc_branch),
      .halt(halt),
      .curr_inst_addr(curr_inst_addr)
  );

  imem imem (
      .read_addr(curr_inst_addr),
      .read_data(curr_inst)
  );

  mips processor (
      .clk(clk),
      .reset(reset),
      .curr_inst(curr_inst),
      .read_data_dmem(read_data_dmem),
      .curr_inst_addr(curr_inst_addr),
      .next_inst_addr(next_inst_addr),
      .memW(memW),
      .read_addr_dmem(read_addr_dmem),
      .write_addr_dmem(write_addr_dmem),
      .pc_branch(pc_branch),
      .halt(halt),
      .write_data_dmem(write_data_dmem)
  );

  dmem dmem (
      .clk(clk),
      .write_enable(memW),
      .reset(reset),
      .write_addr(write_addr_dmem),
      .write_data(write_data_dmem),
      .read_addr_1(read_addr_dmem),
      .read_addr_2(read_addr_dummy),
      .read_data_1(read_data_dmem),
      .read_data_2(read_data_dummy)
  );

endmodule
