class cache_environment;
  
  static string name = "cache_environment";
  cache_agent      agent;
  cache_scoreboard scoreboard;
  
  mailbox mbx;
  mailbox sco_mbx;
  
  function new(virtual cache_interface vintf);
    mbx = new();//monitor to scoreboard
    sco_mbx = new();//driver to scoreboard
    agent      = new(.agt_mbx(mbx),.sco_mbx(sco_mbx),.vintf(vintf));
    scoreboard = new(.sco_mbx(mbx),.drv_mbx(sco_mbx),.vintf(vintf));
    $display("INSTANCE_CREATED : Class %s",name);
  endfunction : new
  
  virtual function void display_name();
    $display("CLASS_NAME : %s",name);
  endfunction : display_name  
  
  virtual task run();
    $display("%s : [RUN] Run method called",name);
    fork
      begin : agt_run
        agent.run();
      end
      begin : sco_run
        scoreboard.run();
      end
    join_any
    wait(agent.generator.num_trans == scoreboard.num_trans);
    $display("%s : [NUM_CMP] number of comparisons done",name);
    disable sco_run;
    //disable agt_run;
    //$finish();
    $display("%s : [RUN] Run method ended",name);
  endtask : run
  
endclass :  cache_environment