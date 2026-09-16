

  
  class apb_seq_item extends uvm_sequence_item;
    `uvm_object_utils(apb_seq_item)
    rand logic req;
    rand logic wr;
    rand logic [31:0] addr,wdata;
    rand logic [2:0] prot;
    rand logic [3:0] strb;
    rand logic hold_req;
    rand logic reset;
    
    logic [31:0] rdata;
    logic done,error;
    
    constraint c1 {addr[1:0]==2'b00;
                   addr inside {[32'h00:32'h7C]};}

    constraint c2 {strb dist {4'b1111:=40,4'b0011:=20,4'b1100:=20,4'b1000:=20};}
    
    constraint c3 { wdata inside {[32'h00:32'h50]};}
    
    
    
    function new(string name="apb_seq_item");
      super.new(name);
    endfunction
    
    function void display(string name);
      `uvm_info(name,$sformatf("REQ=%0d | WR=%0d | PADDR=%0h |PWDATA=%0h | PPROT=%b | PSTRB=%b | PRDATA=%0h | PLAVERR=%0d",req,wr,addr,wdata,prot,strb,rdata,error),UVM_LOW)
    endfunction
    
  endclass
