`timescale 1ns / 1ps

module testbench ();

  logic clk, reset;
  logic [ 4:0] curr_inst_addr;
  logic [ 4:0] next_inst_addr;
  logic [15:0] curr_inst;
  logic [ 3:0] addr_on_dmem;
  logic [ 7:0] data_on_dmem;

  top dut (
      .clk(clk),
      .reset(reset),
      .curr_inst_addr(curr_inst_addr),
      .next_inst_addr(next_inst_addr),
      .curr_inst(curr_inst),
      .addr_on_dmem(addr_on_dmem),
      .data_on_dmem(data_on_dmem)
  );

  initial begin
    $dumpfile("sim.vcd");
    $dumpvars(0, testbench);

    clk   = 0;
    reset = 1;
    #1;
    clk = 1;
    #1;
    reset = 0;

    for (int i = 0; i < 100; i++) begin
      #5;
      clk = ~clk;
    end

    $display("Test Complete");
  end

endmodule
