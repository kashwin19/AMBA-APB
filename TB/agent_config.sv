
// `include "uvm_macros.svh"
// import uvm_pkg::*;
  
  class apb_agent_config extends uvm_object;
    
    virtual apb_if vif;
    
    `uvm_object_utils(apb_agent_config)
    
//     bit has_driver=1;
//     bit has_monitor=1;
    
    uvm_active_passive_enum is_active=UVM_ACTIVE;
    

    function new(string name="apb_agent_config");
      super.new(name);
    endfunction
    
    
  endclass
