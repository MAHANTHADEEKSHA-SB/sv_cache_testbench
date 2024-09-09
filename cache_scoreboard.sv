class cache_scoreboard;
  static string name = "cache_scoreboard";
  static int err_cnt,pass_cnt;
  mailbox mbx;
  mailbox drv_mbx;
  virtual cache_interface vintf;
  bit debug = 1'b0;
  
  cache_transaction expected_queue[$];
  cache_transaction actual_queue[$];
  
  bit[31 : 0] num_trans = 0;
  
  function new(mailbox sco_mbx,mailbox drv_mbx,virtual cache_interface vintf);
    this.vintf = vintf;
    this.drv_mbx = drv_mbx;
    this.mbx = sco_mbx;
    $display("INSTANCE_CREATED : Class %s",name);
  endfunction : new
  
  virtual function void display_name();
    $display("CLASS_NAME : %s",name);
  endfunction : display_name  
  
  virtual task run();
    int i,j;
    cache_transaction trans1,trans2,exp,act;
    $display("%s : [RUN] Run method called",name);
    fork
        begin
          forever begin
            if(debug == 1'b1)
              $display("%s : [WAITING_EXPECTED_PKT]",name);
            wait(drv_mbx.num > 0);
            drv_mbx.get(trans1);
            trans1.name = $sformatf("transaction %0d",i);
            expected_queue.push_back(trans1);
            trans1 = null;
            i = i + 1;
            if(debug == 1'b1)
              $display("%s : [DONE_WAITING_EXPECTED_PKT]",name);
          end
        end
        begin
          forever begin
            if(debug == 1'b1)
              $display("%s : [WAITING_ACTUAL_PKT]",name);
            wait(mbx.num > 0);
            mbx.get(trans2);
            trans2.name = $sformatf("transaction %0d",j);
            actual_queue.push_back(trans2);
            trans2 = null;
            j = j + 1;
            if(debug == 1'b1)
              $display("%s : [DONE_WAITING_ACTUAL_PKT]",name);
          end
        end
    join_none
    
    forever begin
      @(posedge vintf.clk);
      wait(expected_queue.size() > 0);
      exp = expected_queue.pop_front();
      wait(actual_queue.size() > 0);
      act = actual_queue.pop_front();
      if(exp.addr != act.addr)begin
        $error("%s : [ADDR_MISMATCH] exp %0h act %0h",name,exp.addr,act.addr);
        err_cnt = err_cnt + 1;
      end
      else begin
        if(debug == 1'b1)
          $display("%s : [ADDR_MATCH] exp %0h act %0h",name,exp.addr,act.addr);
        pass_cnt = pass_cnt + 1;
      end
      num_trans = num_trans + 1;
      exp = null;
      act = null;
    end
    
    $display("%s : [RUN] Run method ended",name);
  endtask : run
  
endclass : cache_scoreboard