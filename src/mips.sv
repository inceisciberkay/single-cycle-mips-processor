`timescale 1ns / 1ps

module mips (
    input logic clk,
    input logic reset,
    input logic [15:0] instruction,
    input logic [7:0] dataFromMemory,
    input logic [4:0] currentInstructionAddress,
    output logic [4:0] nextInstructionAddress,
    output logic memWrite,
    output logic [3:0] writeAddressDM,
    output logic pcBranch,
    output logic halt,
    output logic [7:0] writeDataDM
);

  logic regWrite, aluF, memToReg, addition, branch;

  controller cc (
      .op(instruction[15:13]),
      .memWrite(memWrite),
      .regWrite(regWrite),
      .aluF(aluF),
      .memToReg(memToReg),
      .addition(addition),
      .branch(branch),
      .halt(halt)
  );

  datapath dp (
      .clk(clk),
      .reset(reset),
      .instruction(instruction),
      .regWrite(regWrite),
      .dataFromMemory(dataFromMemory),
      .memToReg(memToReg),
      .aluF(aluF),
      .addition(addition),
      .branch(branch),
      .currentInstructionAddress(currentInstructionAddress),
      .writeAddressDM(writeAddressDM),
      .nextInstructionAddress(nextInstructionAddress),
      .pcBranch(pcBranch),
      .writeDataDM(writeDataDM)
  );

endmodule
