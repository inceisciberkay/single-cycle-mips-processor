`timescale 1ns / 1ps

module top_basys (
    input logic clk,
    input logic [15:0] instructionBasys,
    input logic btnU,
    input logic btnR,
    input logic btnL,
    input logic btnC,
    input logic btnD,
    output logic [15:0] instructionOnMemory,
    output logic [6:0] seg,
    output logic dp,
    output logic [3:0] an
);

  logic pulse1, pulse2, pulse3, pulse4, pulse5;

  logic [4:0] instructionAddress;
  logic [4:0] nextInstructionAddress;
  logic [15:0] instructionToBeExecuted;

  logic [3:0] addressOnDataMemory;
  logic [7:0] dataOnDataMemory;

  logic pcBranch;
  logic memWrite;
  logic halt;

  logic [3:0] writeAddress;
  logic [3:0] writeAddressDM;
  assign writeAddress = writeAddressDM;

  logic [3:0] readAddress;
  assign readAddress = instructionToBeExecuted[3:0];

  logic [7:0] writeData;
  logic [7:0] readData;

  selector sc (
      .clk(clk),
      .pulse4(pulse4),
      .pulse5(pulse5),
      .reset(pulse1),
      .instructionFromBasys(instructionBasys),
      .instructionFromMemory(instructionOnMemory),
      .halt(halt),
      .instructionToBeExecuted(instructionToBeExecuted)
  );

  program_counter pc (
      .clk(clk),
      .enable(pulse5),
      .reset(pulse1),
      .nextInstructionAddress(nextInstructionAddress),
      .pcSrc(pcBranch),
      .halt(halt),
      .currentInstructionAddress(instructionAddress)
  );

  instruction_memory im (
      .readAddress(instructionAddress),
      .readData(instructionOnMemory)
  );

  mips spc (
      .clk(clk),
      .reset(pulse1),
      .instruction(instructionToBeExecuted),
      .dataFromMemory(readData),
      .currentInstructionAddress(instructionAddress),
      .nextInstructionAddress(nextInstructionAddress),
      .memWrite(memWrite),
      .writeAddressDM(writeAddressDM),
      .pcBranch(pcBranch),
      .halt(halt),
      .writeDataDM(writeData)
  );

  data_memory dm (
      .clk(clk),
      .writeEnable(memWrite),
      .reset(pulse1),
      .writeAddress(writeAddress),
      .writeData(writeData),
      .readAddress1(readAddress),
      .readAddress2(addressOnDataMemory),
      .readData1(readData),
      .readData2(dataOnDataMemory)
  );

  debounce d1 (
      .clk(clk),
      .button(btnU),
      .pulse(pulse1)
  );  // reset
  debounce d2 (
      .clk(clk),
      .button(btnR),
      .pulse(pulse2)
  );  // iterate right through data memory
  debounce d3 (
      .clk(clk),
      .button(btnL),
      .pulse(pulse3)
  );  // iterate left through data memory
  debounce d4 (
      .clk(clk),
      .button(btnC),
      .pulse(pulse4)
  );  // from basys
  debounce d5 (
      .clk(clk),
      .button(btnD),
      .pulse(pulse5)
  );  // from instruction memory

  SevSeg_4Digit ss (
      .clk(clk),
      .in3(addressOnDataMemory),
      .in2(4'b1111),
      .in1(dataOnDataMemory[7:4]),
      .in0(dataOnDataMemory[3:0]),
      .seg(seg),
      .dp (dp),
      .an (an)
  );

  always_ff @(posedge clk)
    if (pulse2) addressOnDataMemory <= addressOnDataMemory + 1;
    else if (pulse3) addressOnDataMemory <= addressOnDataMemory - 1;
    else addressOnDataMemory <= addressOnDataMemory;

endmodule
