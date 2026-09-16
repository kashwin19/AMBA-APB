
`include "apb_master.sv"
`include "apb_slave.sv"
module apb_top #(
    parameter ADDR_WIDTH  = 32,
    parameter DATA_WIDTH  = 32,
    parameter MEM_DEPTH   = 32,
    parameter WAIT_CYCLE = 2
)(
    input  wire                    pclk,
    input  wire                    presetn,
    input  wire                    req,
    input  wire                    wr,
    input  wire [ADDR_WIDTH-1:0]   addr,
    input  wire [DATA_WIDTH-1:0]   wdata,
    input  wire [3:0]              strb,
    input  wire [2:0]              prot,   
    output wire [DATA_WIDTH-1:0]   rdata,
    output wire                    done,
    output wire                    error
);


    wire                    psel;
    wire                    penable;
    wire                    pwrite;
    wire [ADDR_WIDTH-1:0]   paddr;
    wire [DATA_WIDTH-1:0]   pwdata;
    wire [3:0]              pstrb;
    wire [2:0]              pprot;
    wire [DATA_WIDTH-1:0]   prdata;
    wire                    pready;
    wire                    pslverr;
  
    apb_master #(
        .ADDR_WIDTH (ADDR_WIDTH),
        .DATA_WIDTH (DATA_WIDTH)
    ) master_dut (
        .pclk     (pclk),
        .presetn  (presetn),
        .req      (req),
        .wr       (wr),
        .addr     (addr),
        .wdata    (wdata),
        .strb     (strb),
        .prot     (prot),
        .rdata    (rdata),
        .done     (done),
        .error      (error),
        .psel      (psel),
        .penable  (penable),
        .pwrite   (pwrite),
        .paddr    (paddr),
        .pwdata   (pwdata),
        .pstrb    (pstrb),
        .pprot    (pprot),
        .prdata   (prdata),
        .pready   (pready),
        .pslverr  (pslverr)
    );

    apb_slave #(
        .ADDR_WIDTH  (ADDR_WIDTH),
        .DATA_WIDTH  (DATA_WIDTH),
        .MEM_DEPTH   (MEM_DEPTH),
        .WAIT_CYCLE (WAIT_CYCLE)
    ) slave_dut (
        .pclk     (pclk),
        .presetn  (presetn),
        .pselx    (psel),
        .penable  (penable),
        .pwrite   (pwrite),
        .paddr    (paddr),
        .pwdata   (pwdata),
        .pstrb    (pstrb),
        .pprot    (pprot),
        .prdata   (prdata),
        .pready   (pready),
        .pslverr  (pslverr)
    );

endmodule
