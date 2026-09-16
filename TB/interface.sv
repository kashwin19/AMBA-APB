
`include "uvm_macros.svh"
import uvm_pkg::*;

interface apb_if#(ADDR_WIDTH=32,
                  DATA_WIDTH=32)
                 (input logic pclk);
  
  logic presetn;
  logic req,wr;
  logic [ADDR_WIDTH-1:0] addr;
  logic [DATA_WIDTH-1:0] wdata;
  logic [2:0] prot;
  logic [3:0] strb;
  logic [DATA_WIDTH-1:0] rdata;
  logic done,error;
  
  logic psel;
  logic penable;
  logic pwrite;
  logic [ADDR_WIDTH-1:0] paddr;
  logic [DATA_WIDTH-1:0] pwdata;
  logic [2:0] pprot;
  logic [3:0] pstrb;
  logic [DATA_WIDTH-1:0]prdata;
  logic pready,pslverr;
  

  property p4;//TC9
    @(posedge pclk)
    $fell(presetn) |-> ##1 !(psel && penable);
  endproperty
  
property p2;
  @(posedge pclk)
  disable iff(!presetn)
  (psel && $rose(penable)) |-> ##[0:$] pready;
endproperty
  
  property p1;
    @(posedge pclk)
    disable iff (!presetn)
    (psel && !penable) |-> ##1 (penable);
  endproperty
  
  property p3;
    @(posedge pclk)
    disable iff(!presetn)
    (psel && $rose(penable)) |-> $stable({paddr,pwrite, pprot, pstrb});
  endproperty
  
  assert property(p4)
    `uvm_info("ASSERTION","PASS FOR RESET CHECK",UVM_LOW)
    else
      `uvm_error("ASSERTION","FAIL FOR RESET")
  
  
  assert property(p3)
    `uvm_info("ASSERTION","PASSED IN SIGNALS STABLE DURING ACCESS PAHSE",UVM_LOW)
    else
      `uvm_error("ASSERTION","FAILED IN SIGNALS STABLE DURING ACCESS PAHSE")
      
  
  assert property(p2)
    `uvm_info("ASSERTION","PASSED FOR WAIT CYCLE",UVM_LOW)
    else
      `uvm_info("ASSERTION","FAILED FOR WAIT_CYCLE",UVM_LOW)
      
  assert property(p1)
    `uvm_info("ASSERTION","PASSED FOR SETUP TO ACCESS PHASE",UVM_LOW)
    else
      `uvm_error("ASSERTION","FAILED FOR SETUP TO ACCESS PHASE")
  
endinterface
