`timescale 1ns / 1ps

module top (
    input logic clk,
    input logic reset,
    output logic [4:0] curr_inst_addr,
    output logic [4:0] next_inst_addr,
    output logic [15:0] curr_inst,
    output logic [3:0] addr_on_dm,
    output logic [7:0] data_on_dm
);

  logic pc_branch;
  logic memW;
  logic halt;

  logic [3:0] write_addr;
  logic [3:0] write_addr_dm;
  assign write_addr = write_addr_dm;

  logic [3:0] read_addr;
  assign read_addr = curr_inst[3:0];

  logic [7:0] write_data;
  logic [7:0] read_data;

  PC pc (
      .clk(clk),
      .enable(1'b1),
      .reset(reset),
      .next_inst_addr(next_inst_addr),
      .pc_src(pc_branch),
      .halt(halt),
      .curr_inst_addr(curr_inst_addr)
  );

  instruction_memory im (
      .read_addr(curr_inst_addr),
      .read_data(curr_inst)
  );

  mips spc (
      .clk(clk),
      .reset(reset),
      .curr_inst(curr_inst),
      .read_data_dm(read_data),
      .curr_inst_addr(curr_inst_addr),
      .next_inst_addr(next_inst_addr),
      .memW(memW),
      .write_addr_dm(write_addr_dm),
      .pc_branch(pc_branch),
      .halt(halt),
      .write_data_dm(write_data)
  );

  data_memory dm (
      .clk(clk),
      .write_enable(memW),
      .reset(reset),
      .write_addr(write_addr),
      .write_data(write_data),
      .read_addr_1(read_addr),
      .read_addr_2(addr_on_dm),
      .read_data_1(read_data),
      .read_data_2(data_on_dm)
  );

endmodule
