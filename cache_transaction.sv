`ifndef CACHE_TRANSACTION_SV
`define CACHE_TRANSACTION_SV
typedef enum bit[1 : 0] {BYTE = 'b00, HALF_WORD = 'b01, WORD = 'b10,DOUBLE_WORD = 'b11} align_e;
class cache_transaction;
  
  static string name = "cache_transaction";
  static bit display_enable = 0;
  // Transaction fields
  rand bit [31:0] addr;
  rand bit [20:0] tag1_loaded;
  rand bit [20:0] tag2_loaded;
  rand align_e alignment;
  rand bit valid1;
  rand bit valid2;
  rand bit dirty1;
  rand bit dirty2;
  rand bit ld;
  rand bit st;
  rand bit l2_ack;
  
  constraint c_addr {(alignment == HALF_WORD) -> {addr[0] == 1'b0;}
                     (alignment == WORD) -> {addr[1 : 0] == 2'b00;}
                     (alignment == DOUBLE_WORD) -> {addr[2 : 0] == 3'b00;}
                    }//consraint for word aligned address
  
  function new(string name = "cache_transaction");
    // Constructor
    this.name = name;
    if(display_enable == 1)begin
       $display("INSTANCE_CREATED : Class %s",name);
    end
  endfunction
  
  virtual function void display_fields();
    $display("%s : [FIELDS_DISPLAY]\n addr %0h\n tag1_loaded %0h\n tag2_loaded %0h\n",name,addr,tag1_loaded,tag2_loaded);//add other fields here
  endfunction : display_fields
  
  virtual function void display_name();
    $display("CLASS_NAME : %s",name);
  endfunction : display_name
  
endclass

`endif
