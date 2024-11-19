`timescale 1ns / 1ps

module alu (
    input logic [7:0] a,
    input logic [7:0] b,
    input logic f,
    output logic [7:0] y,
    output logic zero
);

  logic [7:0] p, q;

  adder add (
      .a(a),
      .b(b),
      .c(p)
  );

  subtractor sub (
      .a(a),
      .b(b),
      .c(q)
  );

  always_comb
    case (f)
      0: y = p;  // add
      1: y = q;  // subtract
      default: y = {8{1'bx}};
    endcase

  assign zero = (q == 0);

endmodule
