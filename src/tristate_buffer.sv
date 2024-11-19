`timescale 1ns / 1ps

module tristate_buffer #(
    parameter int WIDTH = 16
) (
    input logic [WIDTH - 1:0] a,
    input logic c,
    output logic [WIDTH - 1:0] y
);

  assign y = c ? a : 1'bz;

endmodule
