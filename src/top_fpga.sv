`timescale 1ns / 1ps

module top_fpga (
    input logic clk,
    input logic [15:0] inst_on_fpga,
    input logic btnU,
    input logic btnR,
    input logic btnL,
    input logic btnC,
    input logic btnD,
    output logic [15:0] inst_on_imem,
    output logic [6:0] seg,
    output logic dp,
    output logic [3:0] an
);

  logic pulse1, pulse2, pulse3, pulse4, pulse5;

  logic [4:0] curr_inst_addr;
  logic [4:0] next_inst_addr;
  logic [15:0] curr_inst;

  logic [3:0] read_addr_dmem;
  logic [7:0] read_data_dmem;
  logic [3:0] write_addr_dmem;
  logic [7:0] write_data_dmem;

  logic [3:0] read_addr_dummy;
  logic [7:0] read_data_dummy;

  logic pc_branch;
  logic memW;
  logic halt;

  selector sc (
      .clk(clk),
      .pulse4(pulse4),
      .pulse5(pulse5),
      .reset(pulse1),
      .inst_from_fpga(inst_on_fpga),
      .inst_from_imem(inst_on_imem),
      .halt(halt),
      .curr_inst(curr_inst)
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

  imem imem (
      .read_addr(curr_inst_addr),
      .read_data(inst_on_imem)
  );

  mips processor (
      .clk(clk),
      .reset(pulse1),
      .curr_inst(curr_inst),
      .read_data_dmem(read_data),
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
      .reset(pulse1),
      .write_addr(write_addr_dmem),
      .write_data(write_data_dmem),
      .read_addr_1(read_addr_dmem),
      .read_addr_2(read_addr_dummy),
      .read_data_1(read_data_dmem),
      .read_data_2(read_data_dummy)
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
      .in3(read_addr_dmem),
      .in2(4'b1111),
      .in1(read_data_dmem[7:4]),
      .in0(read_data_dmem[3:0]),
      .seg(seg),
      .dp (dp),
      .an (an)
  );

  always_ff @(posedge clk)
    if (pulse2) read_addr_dmem <= read_addr_dmem + 1;
    else if (pulse3) read_addr_dmem <= read_addr_dmem - 1;
    else read_addr_dmem <= read_addr_dmem;

endmodule
