`timescale 1ns / 1ps

module top (
    input logic clk,
    input logic reset,
    output logic [4:0] inst_addr,
    output logic [4:0] next_inst_addr,
    output logic [15:0] curr_inst,
    output logic [3:0] addr_on_dm,
    output logic [7:0] data_on_dm
);

  logic pcBranch;
  logic memWrite;
  logic halt;

  logic [3:0] writeAddress;
  logic [3:0] writeAddressDM;
  assign writeAddress = writeAddressDM;

  logic [3:0] readAddress;
  assign readAddress = curr_inst[3:0];

  logic [7:0] writeData;
  logic [7:0] readData;

  program_counter pc (
      .clk(clk),
      .enable(1'b1),
      .reset(reset),
      .nextInstructionAddress(next_inst_addr),
      .pcSrc(pcBranch),
      .halt(halt),
      .currentInstructionAddress(inst_addr)
  );

  instruction_memory im (
      .readAddress(inst_addr),
      .readData(curr_inst)
  );

  mips spc (
      .clk(clk),
      .reset(reset),
      .instruction(curr_inst),
      .dataFromMemory(readData),
      .currentInstructionAddress(inst_addr),
      .nextInstructionAddress(next_inst_addr),
      .memWrite(memWrite),
      .writeAddressDM(writeAddressDM),
      .pcBranch(pcBranch),
      .halt(halt),
      .writeDataDM(writeData)
  );

  data_memory dm (
      .clk(clk),
      .writeEnable(memWrite),
      .reset(reset),
      .writeAddress(writeAddress),
      .writeData(writeData),
      .readAddress1(readAddress),
      .readAddress2(addr_on_dm),
      .readData1(readData),
      .readData2(data_on_dm)
  );

endmodule
