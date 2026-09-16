

  
  class apb_monitor extends uvm_component;
    `uvm_component_utils(apb_monitor)
    
      virtual  apb_if vif;
      apb_agent_config cfg;
      
      uvm_analysis_port#(apb_seq_item) ap;
    
      function new(string name="apb_monitor",uvm_component parent);
        super.new(name,parent);
        ap=new("ap",this);
      endfunction
        
        function void build_phase(uvm_phase phase);
          super.build_phase(phase);
          
          if(!uvm_config_db#(apb_agent_config)::get(this,"","cfg",cfg))begin
            `uvm_fatal("MONITOR","cfg not getting in monitor");
          end
            vif=cfg.vif;
        endfunction
        
        
    task run_phase(uvm_phase phase);
          apb_seq_item item;
          forever begin
          
            @(posedge vif.pclk);
            if(!vif.presetn)
              continue;
            if(vif.psel && !vif.penable)begin
          item=apb_seq_item::type_id::create("item",this);
              item.req=vif.req;
              item.wr=vif.wr;
              item.addr=vif.paddr;
              item.wdata=vif.wdata;
              item.strb=vif.strb;
              item.prot=vif.prot;
              while(!vif.done && vif.presetn)@(posedge vif.pclk);
              if(!vif.presetn)begin
                `uvm_info("MONITOR","RESET ASSERTED DURING TRANSFER",UVM_LOW)
                ap.write(item);
                continue;
              end
              item.done=vif.done;
              item.rdata=vif.rdata;
              item.error=vif.error;
              ap.write(item);
              item.display("MONITOR");
            end
          end
          
          endtask      
      
  endclass
