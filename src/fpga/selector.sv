`timescale 1ns / 1ps

module selector (
    input logic clk,
    input logic pulse4,
    input logic pulse5,
    input logic reset,
    input logic [15:0] inst_from_fpga,
    input logic [15:0] inst_from_imem,
    input logic halt,
    output logic [15:0] inst_to_exec
);

  always_ff @(posedge clk)
    if (reset) inst_to_exec <= 16'b0;
    else if (pulse4 && !halt) inst_to_exec <= inst_from_fpga;
    else if (pulse5 && !halt) inst_to_exec <= inst_from_imem;
    else inst_to_exec <= inst_to_exec;

  //    logic[1:0] states;
  //    assign { pulse4, pulse5} = states;
  //    always_comb
  //        case( states)
  //            2'b00: inst_to_exec <= inst_to_exec;
  //            2'b01: inst_to_exec <= inst_from_imem;
  //            2'b10: inst_to_exec <= inst_from_fpga;
  //            default: inst_to_exec <= inst_to_exec;
  //        endcase

endmodule
