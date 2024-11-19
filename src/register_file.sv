`timescale 1ns / 1ps

// 16 x 8
module register_file (
    input logic clk,
    input logic writeEnable,
    input logic reset,
    input logic [3:0] writeAddress,
    input logic [7:0] writeData,
    input logic [3:0] readAddress1,
    input logic [3:0] readAddress2,
    output logic [7:0] readData1,
    output logic [7:0] readData2
);

  logic [7:0] registers[16];

  always_ff @(posedge clk)
    if (reset) begin
      for (int i = 0; i < 16; i = i + 1) begin
        registers[i] <= 8'b0;
      end
    end else if (writeEnable) registers[writeAddress] <= writeData;

  assign readData1 = registers[readAddress1];
  assign readData2 = registers[readAddress2];

endmodule
