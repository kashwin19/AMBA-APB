
class apb_coverage extends uvm_component;
  `uvm_component_utils(apb_coverage)
  
  uvm_analysis_imp#(apb_seq_item,apb_coverage) cov_imp;
  apb_seq_item item;
  
  virtual apb_if vif;
  
  apb_env_config cfg;
  
    function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(apb_env_config)::get(this,"","cfg",cfg))
      `uvm_fatal("SCOREBOARD","CFG NOT GET IN COVERRAGE")
      vif=cfg.vif;
  endfunction
  
  
  
  covergroup cg1;
    ADDRESS:coverpoint item.addr{bins low={[0:31]};
                         bins med={[32:95]};
                         bins high={[96:124]};}
    STROBE:coverpoint item.strb{bins full={4'b1111};
                         bins med={4'b0011,4'b1100};
                         bins single={4'b1000};}
    PWRITE:coverpoint item.wr;
    
    PSLVERR:coverpoint item.error;
    
    PRESET:coverpoint vif.presetn;
    
    
   PWADATA:coverpoint item.wdata {
     bins low  = {[32'h00 : 32'h10]};
     bins mid  = {[32'h11 : 32'h30]};
     bins high = {[32'h31 : 32'h50]};
}
    
  endgroup
  
    function new(string name="apb_coverage",uvm_component parent);
    super.new(name,parent);
    cov_imp=new("cov_imp",this);
      cg1=new();
  endfunction
  
  function void write(apb_seq_item t);
    item=t;
    
    cg1.sample();
  endfunction
  
  
endclass
