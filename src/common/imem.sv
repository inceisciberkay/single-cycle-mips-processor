`timescale 1ns / 1ps

// 32x16
module imem (
    input  logic [ 4:0] read_addr,
    output logic [15:0] read_data
);

  logic [15:0] memory[32];

  assign read_data = memory[read_addr];

  initial begin
    memory[0] = 16'b001_1_0000_00000100;  // rf[0] = 4
    memory[1] = 16'b001_1_0001_00000101;  // rf[1] = 5
    memory[2] = 16'b001_1_0100_00001111;  // rf[4] = 15
    memory[3] = 16'b001_1_0101_00000110;  // rf[5] = 6
    memory[4] = 16'b000_0_0000_0000_0000;  // store value of rf[0] to dm[0]
    memory[5] = 16'b000_0_0000_0001_0001;  // store value of rf[1] to dm[1]
    memory[6] = 16'b000_0_0000_0100_0100;  // store value of rf[4] to dm[4]
    memory[7] = 16'b000_0_0000_0101_0101;  // store value of rf[5] to dm[5]
    memory[8] = 16'b001_1_0010_00000000;  // rf[2] = 0
    memory[9] = 16'b001_1_0011_00000001;  // rf[3] = 1
    memory[10] = 16'b001_1_1111_00000000;  // rf[15] = 0
    memory[11] = 16'b101_10011_0010_0101;  // branch to IM[19] if rf[2] == rf[5]
    memory[12] = 16'b010_1_1000_1111_0100;  // add rf[15] and rf[4], write the result into rf[8]
    memory[13] = 16'b000_0_0000_1000_1000;  // store the value of rf[8] to dm[8]
    memory[14] = 16'b001_0_0000_1111_1000;  // load the value from dm[8] to rf[15]
    memory[15] = 16'b010_0_1001_0010_0011;  // add rf[2] and rf[3], write the result into rf[9]
    memory[16] = 16'b000_0_0000_1001_1001;  // store the value of rf[9] to dm[9]
    memory[17] = 16'b001_0_0000_0010_1001;  // load the value from dm[9] to rf[2]
    memory[18] = 16'b101_01011_0000_0000;  // branch to IM[11] if rf[0] == rf[0];
    memory[19] = 16'b000_0_0000_1111_1111;  // store value rf[15] (rf[rf[0]] * rf[rf[1]]), to dm[15]
    memory[20] = 16'b111_1111111111111;  // stop execution (halt)
    memory[21] = 16'b0001000100000010;
    memory[22] = 16'b0001001000000010;
    memory[23] = 16'b0001010000000010;
    memory[24] = 16'b0001100000000010;
    memory[25] = 16'b0011000000000010;
    memory[26] = 16'b0101000000000010;
    memory[27] = 16'b1001010001000010;
    memory[28] = 16'b0101000010000010;
    memory[29] = 16'b0001001000010010;
    memory[30] = 16'b0111000100100010;
    memory[31] = 16'b0001000001000010;
  end

endmodule
