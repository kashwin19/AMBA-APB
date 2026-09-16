

  
  class apb_driver extends uvm_driver#(apb_seq_item);
    
    `uvm_component_utils(apb_driver)
    
     virtual  apb_if vif;
     apb_agent_config cfg;
       
    function new(string name="apb_driver",uvm_component parent);
      super.new(name,parent);
    endfunction
    
    
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      if(!uvm_config_db#(apb_agent_config)::get(this,"","cfg",cfg))begin
        `uvm_fatal("DRIVER","cfg not set in top:driver missing cfg");
      end
        vif=cfg.vif;
    endfunction
    
       task run_phase(uvm_phase phase);
         apb_seq_item item;
         vif.presetn<=0;
         vif.req<=0;
         repeat(2)@(posedge vif.pclk);
         @(negedge vif.pclk);
         vif.presetn<=1;
         forever begin
           seq_item_port.get_next_item(item);
           @(negedge vif.pclk);
           vif.req <= item.req;
           vif.wr<=item.wr;
           vif.addr<=item.addr;
           vif.wdata<=item.wdata;
           vif.strb<=item.strb;
           vif.prot<=item.prot;

           @(negedge vif.pclk);
           @(negedge vif.pclk);
           
           if(!item.reset)begin
             `uvm_info("DRIVER","DURING TRANSFER RESET ASSERTED",UVM_LOW)
             vif.presetn<=1'b0;
             vif.req<=1'b0;
             repeat(2)@(posedge vif.pclk);
             vif.presetn<=1'b1;
             item.done=1'b0;
             item.rdata=32'b0;
             item.error=1'b0;
             seq_item_port.item_done();
             continue;
           end
           
           if(!item.hold_req)
             vif.req<=1'b0;
           while(!vif.done && vif.presetn)@(posedge vif.pclk);
           if(!vif.presetn)begin
             `uvm_info("DRIVER","RESET DURING TRANSFER",UVM_LOW)
             seq_item_port.item_done();
             continue;
           end
           
             
           item.done=vif.done;
           item.rdata=vif.rdata;
           item.error=vif.error;  
           @(posedge vif.pclk);
           item.display("DRIVER");
           seq_item_port.item_done();
         end
       endtask
    
    
  endclass
  
