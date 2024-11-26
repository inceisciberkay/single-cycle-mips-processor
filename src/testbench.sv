`timescale 1ns / 1ps

module testbench ();

  logic clk, reset;
  logic [4:0] curr_inst_addr;
  logic [4:0] next_inst_addr;
  logic [15:0] curr_inst;
  logic pc_branch;
  logic [3:0] read_addr_dmem;
  logic [7:0] read_data_dmem;
  logic [3:0] write_addr_dmem;
  logic [7:0] write_data_dmem;

  top dut (
      .clk(clk),
      .reset(reset),
      .curr_inst_addr(curr_inst_addr),
      .next_inst_addr(next_inst_addr),
      .curr_inst(curr_inst),
      .pc_branch(pc_branch),
      .read_addr_dmem(read_addr_dmem),
      .read_data_dmem(read_data_dmem),
      .write_addr_dmem(write_addr_dmem),
      .write_data_dmem(write_data_dmem)
  );

  initial begin
    $dumpfile("sim.vcd");
    $dumpvars(0, testbench);

    clk   = 0;
    reset = 1;
    #1;
    clk = 1;
    #1;
    clk   = 0;
    reset = 0;

    for (int i = 0; i < 200; i++) begin
      #5;
      clk = ~clk;
    end

    $display("Test Complete");
  end

endmodule
