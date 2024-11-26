`timescale 1ns / 1ps

module controller (
    input logic [2:0] op,
    output logic memW,
    output logic regW,
    output logic aluF,
    output logic mem_to_reg,
    output logic addition,
    output logic branch,
    output logic halt
);

  logic [6:0] controls;

  assign {regW, memW, mem_to_reg, addition, aluF, branch, halt} = controls;

  always_comb
    case (op)
      3'b000:  controls = 7'b0100000;  // store value
      3'b001:  controls = 7'b1010000;  // load value
      3'b010:  controls = 7'b1001000;  // addition
      3'b101:  controls = 7'b0000110;  // branch if equals
      3'b111:  controls = 7'b0000001;  // stop execution
      default: controls = 7'bxxxxxxx;  // illegal operation( reserved)
    endcase

endmodule
