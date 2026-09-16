


class apb_scoreboard extends uvm_component;
  `uvm_component_utils(apb_scoreboard)
  
  virtual apb_if vif;
  apb_env_config cfg;
  uvm_analysis_imp #(apb_seq_item,apb_scoreboard) imp;
  
  logic [31:0] mem [0:31];
  
  function new(string name="apb_scoreboard",uvm_component parent);
    super.new(name,parent);
    imp=new("imp",this);
    foreach(mem[i])
      mem[i]='0;
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(apb_env_config)::get(this,"","cfg",cfg))
      `uvm_fatal("SCOREBOARD","CFG NOT GET IN SCB")
      vif=cfg.vif;
  endfunction
  
  function void write(apb_seq_item item);
    int index;
    index=item.addr[6:2]; 
    if(item.wr && item.done && !item.error)begin
      if(item.strb[0]) mem[index][7:0] = item.wdata[7:0];
      if(item.strb[1]) mem[index][15:8] = item.wdata[15:8];
      if(item.strb[2]) mem[index][23:16] = item.wdata[23:16];
      if(item.strb[3]) mem[index][31:24] = item.wdata[31:24];
      `uvm_info(get_type_name,$sformatf("PWRITE=%0b | PADDR=%h | PWDATA=%h | PSTRB=%b | PPROT=%b | PSLVERR=%b",item.wr,item.addr,item.wdata,item.strb,item.prot,item.error),UVM_LOW)
    end else if(!item.wr && item.done)begin
      logic [31:0] expected;
      expected=mem[index];
      if(item.error)begin
        `uvm_info(get_type_name,$sformatf("READ ERROR : PADDR=%0h | PRDATA=%0h | PSLVERR=%0b",item.addr,item.rdata,item.error),UVM_LOW)
      end else if(item.rdata !== expected)begin
        `uvm_info(get_type_name,$sformatf("MISMATCH:PADDR=%0h | PRDATA=%0h |EXPECTED=%0h",item.addr,item.rdata,expected),UVM_LOW)
      end else begin
        `uvm_info(get_type_name,$sformatf("MATCH:PADDR=%0h | PRDATA=%0h |EXPECTEDTED=%0h",item.addr,item.rdata,expected),UVM_LOW)
      end
    end   
      
  endfunction
  

  task reset_check();
    forever begin
    @(posedge vif.pclk)
    if(!vif.presetn)begin
      `uvm_info("RESET CHECK",$sformatf("PSEL=%0d | PENABLE=%0b | PADDR=%h|PWRITE=%b |PWDATA=%h ",vif.psel,vif.penable,vif.paddr,vif.pwrite,vif.pwdata),UVM_LOW)
    end
    end
  endtask

  task error_check();
    forever begin
    @(posedge vif.pclk)
    if(vif.pslverr)begin
      `uvm_info("CHECKER FOR SLVERR ERROR",$sformatf("PADDR=%0h | PWDATA=%0h | PPROT=%0b | PSTRB=%0b |PRDATA=%0h | PSLVERR=%0b",vif.paddr,vif.pwdata,vif.pprot,vif.pstrb,vif.prdata,vif.pslverr),UVM_LOW)
    end 
    end
  endtask
  
  task run_phase(uvm_phase phase);
    fork
      reset_check();
      error_check();
    join_none
  endtask
  
  
endclass
