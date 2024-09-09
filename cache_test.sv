class cache_test extends cache_base_test;
  function new(string name = "cache_test",virtual cache_interface vintf);
    super.new(.name(name),.vintf(vintf));
  endfunction : new
endclass : cache_test