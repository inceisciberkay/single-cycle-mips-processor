`timescale 1ns / 1ps

module top_fpga (
    input logic clk,
    input logic [15:0] inst_on_fpga,
    input logic btnU,
    input logic btnR,
    input logic btnL,
    input logic btnC,
    input logic btnD,
    output logic [15:0] inst_on_im,
    output logic [6:0] seg,
    output logic dp,
    output logic [3:0] an
);

  logic pulse1, pulse2, pulse3, pulse4, pulse5;

  logic [4:0] curr_inst_addr;
  logic [4:0] next_inst_addr;
  logic [15:0] inst_to_exec;

  logic [3:0] addr_on_dm;
  logic [7:0] data_on_dm;

  logic pc_branch;
  logic memW;
  logic halt;

  logic [3:0] write_addr;
  logic [3:0] write_addr_dm;
  assign write_addr = write_addr_dm;

  logic [3:0] read_addr;
  assign read_addr = inst_to_exec[3:0];

  logic [7:0] write_data;
  logic [7:0] read_data;

  selector sc (
      .clk(clk),
      .pulse4(pulse4),
      .pulse5(pulse5),
      .reset(pulse1),
      .inst_from_fpga(inst_on_fpga),
      .inst_from_im(inst_on_im),
      .halt(halt),
      .inst_to_exec(inst_to_exec)
  );

  PC pc (
      .clk(clk),
      .enable(pulse5),
      .reset(pulse1),
      .next_inst_addr(next_inst_addr),
      .pc_src(pc_branch),
      .halt(halt),
      .curr_inst_addr(curr_inst_addr)
  );

  instruction_memory im (
      .read_addr(curr_inst_addr),
      .read_data(inst_on_im)
  );

  mips spc (
      .clk(clk),
      .reset(pulse1),
      .curr_inst(inst_to_exec),
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
      .reset(pulse1),
      .write_addr(write_addr),
      .write_data(write_data),
      .read_addr_1(read_addr),
      .read_addr_2(addr_on_dm),
      .read_data_1(read_data),
      .read_data_2(data_on_dm)
  );

  debounce d1 (
      .clk(clk),
      .button(btnU),
      .pulse(pulse1)
  );  // reset
  debounce d2 (
      .clk(clk),
      .button(btnR),
      .pulse(pulse2)
  );  // iterate right through data memory
  debounce d3 (
      .clk(clk),
      .button(btnL),
      .pulse(pulse3)
  );  // iterate left through data memory
  debounce d4 (
      .clk(clk),
      .button(btnC),
      .pulse(pulse4)
  );  // from basys
  debounce d5 (
      .clk(clk),
      .button(btnD),
      .pulse(pulse5)
  );  // from curr_inst memory

  SevSeg_4Digit ss (
      .clk(clk),
      .in3(addr_on_dm),
      .in2(4'b1111),
      .in1(data_on_dm[7:4]),
      .in0(data_on_dm[3:0]),
      .seg(seg),
      .dp (dp),
      .an (an)
  );

  always_ff @(posedge clk)
    if (pulse2) addr_on_dm <= addr_on_dm + 1;
    else if (pulse3) addr_on_dm <= addr_on_dm - 1;
    else addr_on_dm <= addr_on_dm;

endmodule