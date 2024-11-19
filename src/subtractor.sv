`timescale 1ns / 1ps

module subtractor (
    input  logic [7:0] a,
    input  logic [7:0] b,
    output logic [7:0] c
);

  assign c = a - b;

endmodule
