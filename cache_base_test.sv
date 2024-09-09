class cache_base_test;
  static string name = "cache_base_test";
  cache_environment env;
  
  virtual cache_interface vintf;
  
  function new(string name = "cache_base_test",virtual cache_interface vintf);
    env = new(.vintf(vintf));
    this.vintf = vintf;
    this.name = name;
    $display("INSTANCE_CREATED : Class %s",name);
  endfunction : new
  
  virtual function void display_hierarchy();
    $display("[TEST_HIERARCHY] : \n[%s]\n\t[%s]\n\t\t[%s]\n\t\t\t[%s]\n\t\t\t[%s]\n\t\t\t[%s]\n\t\t[%s]",name,env.name,env.agent.name,env.agent.generator.name,env.agent.driver.name,env.agent.monitor.name,env.scoreboard.name);
  endfunction : display_hierarchy
  
  virtual function void display_name();
    $display("CLASS_NAME : %s",name);
  endfunction : display_name 
  
  virtual task run();
    $display("%s : [RUN] Run method called",name);
    env.run();
    //#1000ns;
    $display("%s : [RUN] Run method ended",name);
  endtask : run
  
endclass : cache_base_test