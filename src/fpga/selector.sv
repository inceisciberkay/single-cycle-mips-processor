`timescale 1ns / 1ps

module selector (
    input logic clk,
    input logic pulse4,
    input logic pulse5,
    input logic reset,
    input logic [15:0] inst_from_fpga,
    input logic [15:0] inst_from_imem,
    input logic halt,
    output logic [15:0] curr_inst
);

  always_ff @(posedge clk)
    if (reset) curr_inst <= 16'b0;
    else if (pulse4 && !halt) curr_inst <= inst_from_fpga;
    else if (pulse5 && !halt) curr_inst <= inst_from_imem;
    else curr_inst <= curr_inst;

  //    logic[1:0] states;
  //    assign { pulse4, pulse5} = states;
  //    always_comb
  //        case( states)
  //            2'b00: curr_inst <= curr_inst;
  //            2'b01: curr_inst <= inst_from_imem;
  //            2'b10: curr_inst <= inst_from_fpga;
  //            default: curr_inst <= curr_inst;
  //        endcase

endmodule
