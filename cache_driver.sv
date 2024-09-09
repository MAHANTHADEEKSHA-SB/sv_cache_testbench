class cache_driver;
  
  static string name = "cache_driver";
  virtual cache_interface vintf;
  mailbox mbx;
  mailbox sco_mbx;//May needs to be removed after reference model component
  cache_transaction trans;
  function new(mailbox drv_mbx,mailbox sco_mbx, virtual cache_interface vintf);
    this.mbx = drv_mbx;
    this.sco_mbx = sco_mbx;
    this.vintf = vintf;
    $display("INSTANCE_CREATED : Class %s",name);
  endfunction :  new
  
  virtual function void display_name();
    $display("CLASS_NAME : %s",name);
  endfunction : display_name  
  
  task drive(const ref cache_transaction trans);
    // Apply the transaction to the DUT
    if(trans != null)begin
      vintf.addr        <= trans.addr;
      vintf.tag1_loaded <= trans.tag1_loaded;
      vintf.tag2_loaded <= trans.tag2_loaded;
      vintf.valid1      <= trans.valid1;
      vintf.valid2      <= trans.valid2;
      vintf.dirty1      <= trans.dirty1;
      vintf.dirty2      <= trans.dirty2;
      vintf.ld          <= trans.ld;
      vintf.st          <= trans.st;
      vintf.l2_ack      <= trans.l2_ack;
    end
    else begin
      $error("%s : [PACKET_NULL] : transaction argument %s packet is null",name,trans.name);
    end
  endtask : drive

  virtual task reset_wait();
    $display("%s : [RESET_WAIT] Waiting for reset",name);
    //@(posedge vintf.rst);//assuming active high reset and system resets initially
    @(negedge vintf.rst);
    $display("%s : [RESET_WAIT] detected reset",name);
  endtask : reset_wait
  
  virtual task run();
    $display("%s : [RUN] Run method called",name);
    forever begin
      reset_wait();
      @(posedge vintf.clk);
      forever begin
        fork
          begin : stimulus
            forever begin
              @(posedge vintf.clk);
              wait(mbx.num > 0);
              mbx.get(trans);
              if(trans == null)begin
                $fatal("%s : [PACKET_NULL] DV_ENV issue packet popped from class %s is null",name,name);
              end
              drive(.trans(trans));
              sco_mbx.put(trans);
            end
          end
          begin : mid_reset_terminate
            @(posedge vintf.rst);//assuming active high reset and system resets initially
            $display("%s : [MID_RESET] reset detected",name);
          end
        join_any
        disable stimulus;
        break;
      end
    end
    $display("%s : [RUN] Run method ended",name);
  endtask : run
  
endclass : cache_driver