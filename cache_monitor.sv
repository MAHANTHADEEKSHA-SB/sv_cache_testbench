class cache_monitor;
  static string name = "cache_monitor";
  virtual cache_interface vintf;
  mailbox mbx;
  cache_transaction trans;
  function new(mailbox mon_mbx,virtual cache_interface vintf);
    this.mbx = mon_mbx;
    this.vintf = vintf;
    $display("INSTANCE_CREATED : Class %s",name);
  endfunction : new
  
  virtual function void display_name();
    $display("CLASS_NAME : %s",name);
  endfunction : display_name
  
  task monitor(ref cache_transaction trans);
    // Apply the transaction to the DUT
    if(trans != null)begin
      trans.addr        = vintf.addr;
      trans.tag1_loaded = vintf.tag1_loaded;
      trans.tag2_loaded = vintf.tag2_loaded;
      trans.valid1      = vintf.valid1;
      trans.valid2      = vintf.valid2;
      trans.dirty1      = vintf.dirty1;
      trans.dirty2      = vintf.dirty2;
      trans.ld          = vintf.ld;
      trans.st          = vintf.st;
      trans.l2_ack      = vintf.l2_ack;
    end
    else begin
      $error("%s : [PACKET_NULL] transaction argument %s packet is null",name,trans.name);
    end
  endtask : monitor
  
  virtual task reset_wait();
    $display("%s : [RESET_WAIT] Waiting for reset",name);
    //@(posedge vintf.rst);//assuming active high reset and system resets initially
    @(negedge vintf.rst);
    $display("%s : [RESET_WAIT] detected reset",name);
  endtask : reset_wait
  
  virtual task run();//add mid reset logic maybe
    $display("%s : [RUN] Run method called",name);
    reset_wait();
    @(posedge vintf.clk);
    @(posedge vintf.clk);
    forever begin
      @(posedge vintf.clk);
      trans = new(.name("mon_trans"));
      monitor(.trans(trans));
      mbx.put(trans);
    end
    $display("%s : [RUN] Run method ended",name);
  endtask : run
endclass : cache_monitor