class cache_agent;
  
  static string name = "cache_agent";
  cache_driver    driver;
  cache_monitor   monitor;
  cache_generator generator;
  
  virtual cache_interface vintf;
  mailbox mbx;
  
  function new(mailbox agt_mbx,mailbox sco_mbx,virtual cache_interface vintf);
    mbx = new();//generator to driver
    generator  = new(.gen_mbx(mbx));
    driver     = new(.drv_mbx(mbx),.sco_mbx(sco_mbx),.vintf(vintf));
    monitor    = new(.mon_mbx(agt_mbx),.vintf(vintf));//monitor to scoreboard
    $display("INSTANCE_CREATED : Class %s",name);
    this.vintf = vintf;
  endfunction : new
  
  virtual function void display_name();
    $display("CLASS_NAME : %s",name);
  endfunction : display_name
  
  virtual task run();
    $display("%s : [RUN] Run method called",name);
    fork
      generator.run();
      driver.run();
      monitor.run();
    join_any
    $display("%s : [RUN] Run method ended",name);
  endtask : run
endclass : cache_agent