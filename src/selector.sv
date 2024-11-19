`timescale 1ns / 1ps

module selector (
    input logic clk,
    input logic pulse4,
    input logic pulse5,
    input logic reset,
    input logic [15:0] instructionFromBasys,
    input logic [15:0] instructionFromMemory,
    input logic halt,
    output logic [15:0] instructionToBeExecuted
);

  always_ff @(posedge clk)
    if (reset) instructionToBeExecuted <= 16'b0;
    else if (pulse4 && !halt) instructionToBeExecuted <= instructionFromBasys;
    else if (pulse5 && !halt) instructionToBeExecuted <= instructionFromMemory;
    else instructionToBeExecuted <= instructionToBeExecuted;

  //    logic[1:0] states;
  //    assign { pulse4, pulse5} = states;
  //    always_comb
  //        case( states)
  //            2'b00: instructionToBeExecuted <= instructionToBeExecuted;
  //            2'b01: instructionToBeExecuted <= instructionFromMemory;
  //            2'b10: instructionToBeExecuted <= instructionFromBasys;
  //            default: instructionToBeExecuted <= instructionToBeExecuted;
  //        endcase

endmodule
