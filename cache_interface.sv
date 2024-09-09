interface cache_interface(input logic clk,input logic rst);
  // Signals
  logic ld;  // load
  logic st;  // store
  logic [31:0] addr;  // cache access address
  logic [20:0] tag1_loaded;
  logic [20:0] tag2_loaded;
  logic valid1;
  logic valid2;
  logic dirty1;
  logic dirty2;
  logic l2_ack;
  logic hit;
  logic miss;
  logic load_ready;
  logic write_l1;
  logic read_l2;
  logic write_l2;

endinterface : cache_interface