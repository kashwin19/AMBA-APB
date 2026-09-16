
class apb_test extends uvm_test;
  `uvm_component_utils(apb_test)
  
  apb_env env;
  apb_env_config env_cfg;
  
  function new(string name="apb_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    env=apb_env::type_id::create("env",this);
    env_cfg=apb_env_config::type_id::create("env_cfg",this);
    
    env_cfg.agent_cfg=apb_agent_config::type_id::create("agent_cfg");
    
    if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",env_cfg.agent_cfg.vif))
      `uvm_fatal("TEST","VIF NOT GET FOR ENV.AGENT_CFG.VIF")
      
      if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",env_cfg.vif))
        `uvm_fatal("TEST","VIF NOT GET FOR ENV_CFG.VIG")
      
      uvm_config_db#(apb_env_config)::set(this,"*","cfg",env_cfg);
      endfunction
      
    function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
    endfunction
  
  
endclass

class apb_write_read_test extends apb_test; //TC1,//TC2
  
  `uvm_component_utils(apb_write_read_test)
  function new(string name="apb_read_write",uvm_component parent);
    super.new(name,parent);
    endfunction

  
    task run_phase(uvm_phase phase);

      apb_write_read seq0;

    phase.raise_objection(this);
      seq0 = apb_write_read::type_id::create("seq0");

      seq0.start(env.agent.seqr);    
      #50000;
     phase.drop_objection(this);

  endtask

endclass
      

      class apb_b2b_write_test extends apb_test;//TC3
        `uvm_component_utils(apb_b2b_write_test)
    function new(string name="apb_b2b_write_test",uvm_component parent);
      super.new(name,parent);
        endfunction
        
        task run_phase(uvm_phase phase);
          apb_b2b_write seq1;
          phase.raise_objection(this);
          seq1=apb_b2b_write::type_id::create("seq1");
          seq1.start(env.agent.seqr);
         // #50000;
          phase.drop_objection(this);
        endtask
        
      endclass
      
      class apb_b2b_read_test extends apb_test; //TC4
        `uvm_component_utils(apb_b2b_read_test)
        
        function new(string name="apb_b2b_read_test",uvm_component parent);
          super.new(name,parent);
        endfunction
        
        task run_phase(uvm_phase phase);
          apb_b2b_read seq2;
          
          phase.raise_objection(this);
          seq2=apb_b2b_read::type_id::create("seq2");
          seq2.start(env.agent.seqr);
      //    #50000;
          phase.drop_objection(this);
        endtask
        
        
      endclass
      
      class apb_full_write_read_test extends apb_test;//TC5,6
        `uvm_component_utils(apb_full_write_read_test)
        
        function new(string name="apb_full_write_read_test",uvm_component parent);
          super.new(name,parent);
        endfunction
        
        task run_phase(uvm_phase phase);
          apb_full_write seq4;
          apb_full_read seq5;
          
          phase.raise_objection(this);
          seq4=apb_full_write::type_id::create("seq4");
          seq5=apb_full_read::type_id::create("seq5");
          seq4.start(env.agent.seqr);
          seq5.start(env.agent.seqr);
          #50000;
          phase.drop_objection(this);
        endtask  
      endclass
      
      class apb_addr_error_test extends apb_test;//TC7
        `uvm_component_utils(apb_addr_error_test)
        
        function new(string name="apb_addr_error_test",uvm_component parent);
          super.new(name,parent);
        endfunction
        
        task run_phase(uvm_phase phase);
          apb_addr_error seq6;
          
          phase.raise_objection(this);
          seq6=apb_addr_error::type_id::create("seq6");
          seq6.start(env.agent.seqr);
          #50000;
          phase.drop_objection(this);
          
        endtask
        
        
      endclass
      
      class apb_strb_error_test extends apb_test;//TC8
        `uvm_component_utils(apb_strb_error_test)
        
        function new(string name="apb_strb_error_test",uvm_component parent);
          super.new(name,parent);
        endfunction
        
        task run_phase(uvm_phase phase);
          apb_strb_error seq7;
          
          phase.raise_objection(this);
          seq7=apb_strb_error::type_id::create("seq7");
          seq7.start(env.agent.seqr);
          phase.drop_objection(this);
          #50000;
        endtask
        
        
      endclass
      
            class apb_prot_error_test extends apb_test;//TC9
              `uvm_component_utils(apb_prot_error_test)
        
         function new(string name="apb_prot_error_test",uvm_component parent);
          super.new(name,parent);
        endfunction
        
        task run_phase(uvm_phase phase);
          apb_prot_error seq8; 
          phase.raise_objection(this);
          seq8=apb_prot_error::type_id::create("seq8");
          seq8.start(env.agent.seqr);
          #50000;
          phase.drop_objection(this);
        endtask
        
        
      endclass

      class apb_reset_check_test extends apb_test;//TC10
        `uvm_component_utils(apb_reset_check_test)
        
        function new(string name="apb_reset_check_test",uvm_component parent);
          super.new(name,parent);
        endfunction

        task run_phase(uvm_phase phase);
          apb_reset_check seq9;
          phase.raise_objection(this);
          seq9=apb_reset_check::type_id::create("seq9");
          seq9.start(env.agent.seqr);
          #50000;
          phase.drop_objection(this);
        endtask
        
      endclass

class apb_partial_writes_test extends apb_test;//TC11
  `uvm_component_utils(apb_partial_writes_test)
  
  function new(string name="apb_partial_writes_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    apb_partial_writes seq10;
    
    phase.raise_objection(this);
    seq10=apb_partial_writes::type_id::create("seq10");
    seq10.start(env.agent.seqr);
    #50000;
    phase.drop_objection(this);
  endtask
  
endclass






class apb_regression_test extends apb_test;
  `uvm_component_utils(apb_regression_test)
  
  function new(string name="apb_regression_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    apb_write_read seq1;
    apb_b2b_write seq2;
    apb_b2b_read  seq3;
    apb_full_write  seq4;
    apb_full_read   seq5;
    apb_addr_error  seq6;
    apb_strb_error seq7;
    apb_prot_error seq8;
    apb_reset_check seq9;
    apb_partial_writes seq10;
    
    phase.raise_objection(this);
    seq1=apb_write_read::type_id::create("seq1");
    seq2=apb_b2b_write::type_id::create("seq2");
    seq3=apb_b2b_read::type_id::create("seq3");
    seq4=apb_full_write::type_id::create("seq4");
    seq5=apb_full_read::type_id::create("seq5");
    seq6=apb_addr_error::type_id::create("seq6");
    seq7=apb_strb_error::type_id::create("seq7");
    seq8=apb_prot_error::type_id::create("seq8");
    seq9=apb_reset_check::type_id::create("seq9");
    seq10=apb_partial_writes::type_id::create("seq10");
    
 
    seq1.start(env.agent.seqr);
    `uvm_info("TEST","SEQ1 DONE",UVM_LOW)
    seq2.start(env.agent.seqr);
    `uvm_info("TEST","SEQ2 DONE",UVM_LOW)
    seq3.start(env.agent.seqr);
    `uvm_info("TEST","SEQ3 DONE",UVM_LOW)
    seq4.start(env.agent.seqr);
    `uvm_info("TEST","SEQ4 DONE",UVM_LOW)
    seq5.start(env.agent.seqr);
    `uvm_info("TEST","SEQ5 DONE",UVM_LOW)
    seq6.start(env.agent.seqr);
    `uvm_info("TEST","SEQ6 DONE",UVM_LOW)
    seq7.start(env.agent.seqr);
    `uvm_info("TEST","SEQ7 DONE",UVM_LOW)
    seq8.start(env.agent.seqr);
    `uvm_info("TEST","SEQ8 DONE",UVM_LOW)
    seq9.start(env.agent.seqr);
    `uvm_info("TEST","SEQ9 DONE",UVM_LOW)
    seq10.start(env.agent.seqr);
    `uvm_info("TEST","SEQ10 DONE",UVM_LOW)
     #50000;
    phase.drop_objection(this);
    
  endtask
  
endclass



class apb_unaligned_addr_test extends apb_test;
  `uvm_component_utils(apb_unaligned_addr_test)
  
  function new(string name="apb_unaligned_addr_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    apb_unalign_addr seq11;
    
    phase.raise_objection(this);
    seq11=apb_unalign_addr::type_id::create("seq11");
    seq11.start(env.agent.seqr);
    #50000;
    phase.drop_objection(this);
  endtask
  
endclass


//with_wait_state;


class apb_partial_writes_test_with_wait_state extends apb_test;//partial writes with wait state
  `uvm_component_utils(apb_partial_writes_test)
  
  function new(string name="apb_partial_writes_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    apb_partial_writes seq10;
    phase.raise_objection(this);
    seq10=apb_partial_writes::type_id::create("seq10");
    seq10.start(env.agent.seqr);
    
    phase.drop_objection(this);
  endtask
  
endclass
      
      
      

  
