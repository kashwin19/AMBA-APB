


class apb_env extends uvm_env;
  `uvm_component_utils(apb_env)
  
  apb_agent agent;
  apb_scoreboard scb;
  apb_env_config env_cfg;
  apb_coverage apb_cov;
  
  
  function new(string name="apb_env",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db#(apb_env_config)::get(this,"","cfg",env_cfg))
      `uvm_fatal("ENV","CFG NOT GETTING")
      
      agent=apb_agent::type_id::create("agent",this);
    
if(env_cfg.is_scoreboard)
  scb = apb_scoreboard::type_id::create("scb", this);

if(env_cfg.is_coverage)
  apb_cov = apb_coverage::type_id::create("apb_cov", this);
    
    uvm_config_db#(apb_agent_config)::set(this,"agent*","cfg",env_cfg.agent_cfg);
    uvm_config_db#(apb_env_config)::set(this,"scb","cfg",env_cfg);
    uvm_config_db#(apb_env_config)::set(this,"apb_cov","cfg",env_cfg);
      
      
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    agent.mon.ap.connect(scb.imp);
    agent.mon.ap.connect(apb_cov.cov_imp);
  endfunction
  
  
endclass
  
