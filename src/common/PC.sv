`timescale 1ns / 1ps

module PC (
    input logic clk,
    input logic enable,
    input logic reset,
    input logic [4:0] next_inst_addr,
    input logic pc_src,
    input logic halt,
    output logic [4:0] curr_inst_addr
);

  always_ff @(posedge clk)
    if (reset) begin
      curr_inst_addr <= 5'b0;
    end else if ((enable || pc_src) && !halt) begin
      curr_inst_addr <= next_inst_addr;
    end

endmodule
