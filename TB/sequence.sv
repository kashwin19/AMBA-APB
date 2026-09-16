

  
  
  class apb_sequence extends uvm_sequence#(apb_seq_item);
    `uvm_object_utils(apb_sequence)
    
    function new(string name="apb_sequence");
      super.new(name);
    endfunction
  endclass
    
    
    class apb_write_read extends apb_sequence; //TC1 //TC2
      `uvm_object_utils(apb_write_read)
      
      
      function new(string name="apb_write_read");
        super.new(name);
      endfunction
      
      task body();
        write_read_back();
      endtask
      
      task write_read_back();
        apb_seq_item item;
        
        item=apb_seq_item::type_id::create("item");
        
        start_item(item);
        item.req=1'b1;
        item.wr=1'b1;
        item.addr=32'h00;
        item.wdata=32'hAABBCCDD;
        item.strb=4'hf;
        item.prot=3'b000;
        item.hold_req=1'b0;
        item.reset=1'b1;
        
        finish_item(item);
        
        item=apb_seq_item::type_id::create("item");
        
        start_item(item);
        item.req=1'b1;
        item.wr=1'b0;
        item.addr=32'h00;
        item.strb=4'hf;
        item.prot=3'b000;
        item.hold_req=1'b0;
        item.reset=1'b1;
        finish_item(item);
      endtask
      
    endclass

class apb_b2b_write extends apb_sequence; //TC3
  `uvm_object_utils(apb_b2b_write)
  
  function new(string name="apb_b2b_write");
    super.new(name);
  endfunction
  
  task body();
    apb_seq_item item;
    repeat(4)begin
    item=apb_seq_item::type_id::create("item");
    start_item(item);
      assert(item.randomize() with {req==1'b1; 
                                   wr==1'b1;
                                   hold_req==1'b1;
                                   prot==3'b000;
                                   reset==1'b1;
                                   strb==4'hf;})
    finish_item(item);
    end
  endtask
  
endclass

class apb_b2b_read extends apb_sequence;  //TC4
  `uvm_object_utils(apb_b2b_read)
  
  function new(string name="apb_b2b_read");
    super.new(name);
  endfunction
  
  task body();
    apb_seq_item item;
    repeat(4)begin
      item=apb_seq_item::type_id::create("item");
      start_item(item);
      assert(item.randomize() with {req==1'b1;
                                   wr==1'b0;
                                   hold_req==1'b0;
                                   prot==3'b000;
                                   reset==1'b1;})
      finish_item(item);
    end
  endtask
  
endclass

class apb_full_write extends apb_sequence; //TC5
  `uvm_object_utils(apb_full_write)
  
  function new(string name="apb_full_write");
    super.new(name);
  endfunction
  
  task body();
    apb_seq_item item;
    for(int i=0; i<32; i++)begin
      item=apb_seq_item::type_id::create("item");
       start_item(item);
      assert(item.randomize() with {wr==1'b1;
                                   req==1'b1;
                                   prot==3'b000;
                                   hold_req==1'b0;
                                   reset==1'b1;
                                   strb==4'hf;})
  
    finish_item(item);
    end
  endtask
  
endclass

class apb_full_read extends apb_sequence; //TC6
  `uvm_object_utils(apb_full_read)
  
  function new(string name="apb_full_read");
    super.new(name);
  endfunction
  
  
  task body();
    apb_seq_item item;
    for(int i=0; i<32; i++)begin
      item=apb_seq_item::type_id::create("item");
      start_item(item);
      assert(item.randomize() with {wr==1'b0;
                                   req==1'b1;
                                   wdata==32'b0;
                                   hold_req==1'b0;
                                   prot==3'b000;
                                   reset==1'b1;
                                   strb==4'hf;})
      finish_item(item);
    end
  endtask
  
endclass

class apb_addr_error extends apb_sequence; //TC7
  `uvm_object_utils(apb_addr_error)
  
  function new(string name="apb_addr_error");
    super.new(name);
  endfunction
  
  task body();
    apb_seq_item item;
    item=apb_seq_item::type_id::create("item");
    start_item(item);
    item.req=1'b1;
    item.wr=1'b1;
    item.addr=32'h80;
    item.wdata=32'hAACCBBDD;
    item.prot=3'b000;
    item.strb=4'b1111;
    item.hold_req=1'b0;
    item.reset=1'b1;
    finish_item(item);
  endtask
  
endclass

class apb_strb_error extends apb_sequence;//TC8
  `uvm_object_utils(apb_strb_error)
  
  function new(string name="apb_strb_error");
    super.new(name);
  endfunction
  
  task body();
    apb_seq_item item;
    item=apb_seq_item::type_id::create("item");
    start_item(item);
    item.req=1'b1;
    item.wr=1'b1;
    item.addr=32'h08;
    item.wdata=32'hccddffaa;
    item.prot=3'b000;
    item.strb=4'b0000;
    item.hold_req=1'b0;
    item.reset=1'b1;
    finish_item(item);
  endtask
  
endclass

class apb_prot_error extends apb_sequence;//TC9
  `uvm_object_utils(apb_prot_error)
  
  function new(string name="apb_prot_error");
    super.new(name);
  endfunction
  
  task body();
    apb_seq_item item;
    item=apb_seq_item::type_id::create("item");
    start_item(item);
    item.req=1'b1;
    item.wr=1'b1;
    item.addr=32'h08;
    item.wdata=32'hccddffaa;
    item.prot=3'b010;
    item.strb=4'b0000;
    item.hold_req=1'b0;
    item.reset=1'b1;
    finish_item(item);
    
  endtask
  
  
endclass


class apb_reset_check extends apb_sequence;//TC10
  `uvm_object_utils(apb_reset_check)
  
  function new(string name="apb_reset_check");
    super.new(name);
  endfunction
  
  task body();
    apb_seq_item item;
    item=apb_seq_item::type_id::create("item");
    
    start_item(item);
    assert(item.randomize() with {wr==1'b1;
                                  req==1'b1;
                                  hold_req==1'b0;
                                  prot==3'b000;
                                  reset==1'b0;});
    finish_item(item);
    
    start_item(item);
    assert(item.randomize() with {wr==1'b1;
                                  req==1'b1;
                                  hold_req==1'b0;
                                  prot==3'b000;
                                  reset==1'b1;});
    finish_item(item);
    
  endtask
  
  endclass

  
  class apb_partial_writes extends apb_sequence;//TC11
    `uvm_object_utils(apb_partial_writes)
    
    function new(string name="apb_partial_writes");
      super.new(name);
    endfunction
    
    task body();
      apb_seq_item item;
       repeat(10)begin
      item=apb_seq_item::type_id::create("item");
      start_item(item);
      assert(item.randomize() with {wr==1'b1;
                                    req==1'b1;
                                    hold_req==1'b0;
                                    prot==3'b000;
                                    reset==1'b1;})
      finish_item(item);
      end
      
    endtask
    
  endclass

class apb_unalign_addr extends apb_sequence;
  `uvm_object_utils(apb_unalign_addr)
  
  function new(string name="apb_unalign_addr");
    super.new(name);
  endfunction
  
  task body();
    apb_seq_item item;
    item=apb_seq_item::type_id::create("item");
    start_item(item);
  item.req      = 1'b1;
  item.wr       = 1'b1;
  item.addr     = 32'h03; 
  item.wdata    = 32'hAABBCCDD;
  item.strb     = 4'b1111;
  item.prot     = 3'b000;
  item.hold_req = 1'b0;
  item.reset    = 1'b1;
    finish_item(item);
  endtask
  
endclass


  
  

  


    
