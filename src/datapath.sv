`timescale 1ns / 1ps

module datapath (
    input logic clk,
    input logic reset,
    input logic [15:0] instruction,
    input logic regWrite,
    input logic [7:0] dataFromMemory,
    input logic memToReg,
    input logic aluF,
    input logic addition,
    input logic branch,
    input logic [4:0] currentInstructionAddress,
    output logic [3:0] writeAddressDM,
    output logic [4:0] nextInstructionAddress,
    output logic pcBranch,
    output logic [7:0] writeDataDM
);

  logic immbit;
  assign immbit = instruction[12];

  logic [7:0] aluA, aluB, aluResult;
  mux2 #(4) waDM_Mux (
      .d0(instruction[7:4]),
      .d1(instruction[11:8]),
      .s (immbit),
      .y (writeAddressDM)
  );
  mux2 #(8) wdDM_Mux (
      .d0(aluB),
      .d1(instruction[7:0]),
      .s (immbit),
      .y (writeDataDM)
  );

  logic zero;
  assign pcBranch = zero & branch;

  logic immbit_addition;
  always_comb
    if (immbit || addition) immbit_addition = 1;
    else immbit_addition = 0;

  logic immbit_notAddition;
  assign immbit_notAddition = immbit && !addition;

  logic [7:0] resMuxOutput;
  logic [7:0] writeDataRF;
  logic [3:0] writeAddressRF;

  logic [4:0] addressPlus1;

  // next instruction address
  adder #(5) a1 (
      .a(currentInstructionAddress),
      .b(5'b00001),
      .c(addressPlus1)
  );
  mux2 #(5) pcMux (
      .d0(addressPlus1),
      .d1(instruction[12:8]),
      .s (pcBranch),
      .y (nextInstructionAddress)
  );

  register_file rf (
      .clk(clk),
      .writeEnable(regWrite),
      .reset(reset),
      .writeAddress(writeAddressRF),
      .writeData(writeDataRF),
      .readAddress1(instruction[7:4]),
      .readAddress2(instruction[3:0]),
      .readData1(aluA),
      .readData2(aluB)
  );
  mux2 #(4) waRF_Mux (
      .d0(instruction[7:4]),
      .d1(instruction[11:8]),
      .s (immbit_addition),
      .y (writeAddressRF)
  );
  mux2 #(8) wdRF_Mux (
      .d0(resMuxOutput),
      .d1(instruction[7:0]),
      .s (immbit_notAddition),
      .y (writeDataRF)
  );
  mux2 #(8) resMux (
      .d0(aluResult),
      .d1(dataFromMemory),
      .s (memToReg),
      .y (resMuxOutput)
  );

  alu alu (
      .a(aluA),
      .b(aluB),
      .f(aluF),
      .y(aluResult),
      .zero(zero)
  );

endmodule
