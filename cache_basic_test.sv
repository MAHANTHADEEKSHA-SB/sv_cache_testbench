//instantiate tests here
program cache_basic_test(cache_interface intf);
  cache_test test1;
  
  initial begin
    test1 = new(.vintf(intf));
    test1.display_hierarchy();
    test1.run();
    if(test1.env.scoreboard.err_cnt > 0)begin
      $error("%s : [TEST_STATUS] Test -> Failed with Errors : [%0d], Matches : [%0d]",test1.name,test1.env.scoreboard.err_cnt,test1.env.scoreboard.pass_cnt);
    end
    else begin
      $display("%s : [TEST_STATUS] Test -> Passed with Errors : [%0d], Matches : [%0d]",test1.name,test1.env.scoreboard.err_cnt,test1.env.scoreboard.pass_cnt);
    end
    //$finish();
  end
  
endprogram : cache_basic_test//endprogram ends simulation not like endmodule