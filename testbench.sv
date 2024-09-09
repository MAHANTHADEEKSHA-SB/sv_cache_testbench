// Code your testbench here
// or browse Examples
`include "cache_interface.sv"
`include "cache_transaction.sv"
`include "cache_generator.sv"
`include "cache_driver.sv"
`include "cache_monitor.sv"
`include "cache_agent.sv"
`include "cache_scoreboard.sv"
`include "cache_environment.sv"
`include "cache_base_test.sv"
`include "cache_test.sv"
`include "cache_basic_test.sv"
module cache_tb();
  
  reg cache_clk;
  reg cache_rst;
  
  initial begin
    cache_clk = 1'b0;
  end
  
  always #10 cache_clk = ~cache_clk;//100Mhz Clock
  
  cache_interface cache_if(.clk(cache_clk),.rst(cache_rst));
  
    // Instantiate the DUT
  cache_controller uut (
    .clk(cache_clk),
    .reset(cache_rst),
    .ld(cache_if.ld),
    .st(cache_if.st),
    .addr(cache_if.addr),
    .tag1_loaded(cache_if.tag1_loaded),
    .tag2_loaded(cache_if.tag2_loaded),
    .valid1(cache_if.valid1),
    .valid2(cache_if.valid2),
    .dirty1(cache_if.dirty1),
    .dirty2(cache_if.dirty2),
    .l2_ack(cache_if.l2_ack),
    .hit(cache_if.hit),
    .miss(cache_if.miss),
    .load_ready(cache_if.load_ready),
    .write_l1(cache_if.write_l1),
    .read_l2(cache_if.read_l2),
    .write_l2(cache_if.write_l2)
  );

  cache_basic_test basic_test(.intf(cache_if));
  
  initial begin
    cache_rst = 1'b0;//assuming active high reset
    @(posedge cache_clk);
    cache_rst = 1'b1;
    repeat(10) begin
      @(posedge cache_clk);
    end
    cache_rst = 1'b0;
  end
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end
  //initial begin
    //#1000us;//comment this once env is in sync
    //$finish();
  //end
endmodule : cache_tb // doesn't end simulations if there are background process running