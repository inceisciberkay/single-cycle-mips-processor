`timescale 1ns / 1ps

// 16 x 8
module regfile (
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

  logic [7:0] registers[16];

  always_ff @(posedge clk)
    if (reset) begin
      for (int i = 0; i < 16; i = i + 1) begin
        registers[i] <= 8'b0;
      end
    end else if (write_enable) registers[write_addr] <= write_data;

  assign read_data_1 = registers[read_addr_1];
  assign read_data_2 = registers[read_addr_2];

endmodule
