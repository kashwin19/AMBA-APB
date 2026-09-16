

`include "apb_package.sv"
`include "interface.sv"
`include "uvm_macros.svh"
`timescale 1ns/1ps;

import apb_package::*;

module top_tb;
  
  bit pclk;
  always #5 pclk = ~pclk;

  apb_if vif(pclk);

  apb_top dut (
    .pclk     (pclk),
    .presetn  (vif.presetn),
    .req      (vif.req),
    .wr       (vif.wr),
    .addr     (vif.addr),
    .wdata    (vif.wdata),
    .strb     (vif.strb),
    .prot     (vif.prot),
    .rdata    (vif.rdata),
    .done     (vif.done),
    .error    (vif.error)
  );
assign vif.psel    = dut.psel;
assign vif.penable = dut.penable;
assign vif.pwrite  = dut.pwrite;
assign vif.paddr   = dut.paddr;
assign vif.pwdata  = dut.pwdata;
assign vif.pstrb   = dut.pstrb;
assign vif.pprot   = dut.pprot;
assign vif.pready  = dut.pready;
assign vif.prdata  = dut.prdata;
assign vif.pslverr = dut.pslverr;
  
  

  initial begin

    $dumpfile("apb_top.vcd");
    $dumpvars(0,top_tb);
    
    uvm_config_db#(virtual apb_if)::set(null, "*", "vif", vif);
    run_test("apb_unaligned_addr_test");
    `uvm_info("TEST",("ALL TEST CASES ARE COMPLETED"),UVM_LOW)
    $finish;
  end
  

endmodule
