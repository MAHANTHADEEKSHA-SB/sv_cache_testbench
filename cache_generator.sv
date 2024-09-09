class cache_generator;
  
  static string name = "cache_generator";
  mailbox mbx;
  bit enable_rand_num_trans = 1'b1;
  rand cache_transaction trans;
  rand bit[31 : 0] num_trans;
  
  constraint c_numtrans {num_trans inside {[1 : 30]};}
  
  function new(mailbox gen_mbx);
    this.mbx = gen_mbx;
    $display("INSTANCE_CREATED : Class %s",name);
  endfunction : new
  
  // Method to apply test case
  virtual task apply_stimulus(input bit [31:0] addr, input bit [20:0] tag1_loaded,
                       input bit [20:0] tag2_loaded, input bit valid1, input bit valid2,
                       input bit dirty1, input bit dirty2, input bit ld, input bit st,
                       input bit l2_ack);
    if(trans == null)begin
      $display("PACKET_NULL : Creating packet memory before assigning the stimulus");
      trans = new(.name("custom_trans"));
    end
    if(!(trans.randomize() with {
         addr == local::addr;
         tag1_loaded == local::tag1_loaded;
         tag2_loaded == local::tag2_loaded;
         valid1 == local::valid1;
         valid2 == local::valid2;
         dirty1 == local::dirty1;
         dirty2 == local::dirty2;
         ld == local::ld;
         st == local::st;
         l2_ack == local::l2_ack;}))begin
      $fatal("%s : RANDOMIZATION_FAIL : Randomisation failure in class %s",name,name);
    end
  endtask : apply_stimulus
  
  virtual function void display_name();
    $display("CLASS_NAME : %s",name);
  endfunction : display_name
  
  virtual task run();
    if(enable_rand_num_trans == 1'b1)begin
      if(!this.randomize())begin
        $fatal("%s : [RANDOMIZATION_FAIL] Randomization failure",name);
      end
    end
    else begin
      if(!(this.randomize() with {num_trans inside {[1 : 1]};}))begin
        $fatal("%s : [RANDOMIZATION_FAIL] Randomization failure",name);
      end
    end
    $display("%s : [RUN] Run method called",name);
    repeat(num_trans)begin
      if(trans == null)begin
        trans = new(.name("rand_trans"));
        if(!trans.randomize())begin
          $fatal("%s : RANDOMIZATION_FAIL : Randomisation failure in class %s",name,name);
        end
      end
      mbx.put(trans);
      trans = null;
    end
    $display("%s : [RUN] Run method ended",name);
  endtask : run
  
endclass : cache_generator