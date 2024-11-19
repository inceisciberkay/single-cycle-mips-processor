`timescale 1ns / 1ps

module program_counter (
    input logic clk,
    input logic enable,
    input logic reset,
    input logic [4:0] nextInstructionAddress,
    input logic pcSrc,
    input logic halt,
    output logic [4:0] currentInstructionAddress
);

  always_ff @(posedge clk)
    if (reset) begin
      currentInstructionAddress <= 5'b0;
    end else if ((enable || pcSrc) && !halt) begin
      currentInstructionAddress <= nextInstructionAddress;
    end

endmodule
