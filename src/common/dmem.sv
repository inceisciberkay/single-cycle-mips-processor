`timescale 1ns / 1ps

// 16x8
module dmem (
    input logic clk,
    input logic write_enable,
    input logic reset,
    input logic [3:0] write_addr,
    input logic [7:0] write_data,
    input logic [3:0] read_addr_1,
    input logic [3:0] read_addr_2,
    output logic [7:0] read_data_1,
    output logic [7:0] read_data_2
);

  logic [7:0] memory[16];

  always_ff @(posedge clk)
    if (reset) begin
      for (int i = 0; i < 16; i = i + 1) begin
        memory[i] <= 8'b0;
      end
    end else if (write_enable) memory[write_addr] <= write_data;

  assign read_data_1 = memory[read_addr_1];
  assign read_data_2 = memory[read_addr_2];

endmodule
