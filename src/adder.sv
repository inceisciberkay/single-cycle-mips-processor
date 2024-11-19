`timescale 1ns / 1ps

module adder #(
    parameter int WIDTH = 8
) (
    input  logic [WIDTH - 1:0] a,
    input  logic [WIDTH - 1:0] b,
    output logic [WIDTH - 1:0] c
);

  assign c = a + b;

endmodule
