
module apb_slave #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter MEM_DEPTH  = 32,
    parameter WAIT_CYCLE = 2
)(
    input  wire                    pclk,
    input  wire                    presetn,
    input  wire                    pselx,
    input  wire                    penable,
    input  wire                    pwrite,
    input  wire [DATA_WIDTH-1:0]   pwdata,
    input  wire [ADDR_WIDTH-1:0]   paddr,
    input  wire [3:0]              pstrb,
    input  wire [2:0]              pprot,
    output wire                    pready,
    output wire                    pslverr,  
    output wire [DATA_WIDTH-1:0]   prdata    
);



    reg [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];
    reg [$clog2(WAIT_CYCLE+2):0] wait_counter;
    
  
    wire non_secure = pprot[1];
    wire pstrb_error = pwrite && (pstrb==4'b0000);
    wire addr_err   = (paddr >> 2) >= MEM_DEPTH;
    wire access_phase=pselx && penable;
  wire unaligned_err = ( paddr[1:0] != 2'b00);
  
   wire access_err = non_secure | addr_err | pstrb_error | unaligned_err ;

    always_ff @(posedge pclk or negedge presetn) begin
        if (!presetn)
            wait_counter <= '0;
      else if (!access_phase)
            wait_counter <= '0;
      else if (wait_counter < WAIT_CYCLE)
            wait_counter <= wait_counter + 1;
    end
  
assign pready = (WAIT_CYCLE == 0)
  ? (access_phase)
  : (access_phase && wait_counter == WAIT_CYCLE);
    assign pslverr = pselx && penable && pready && access_err;
    assign prdata  = (access_phase && pready && !pwrite && !access_err)
                     ? mem[paddr[6:2]]
                     : '0;
  
    always_ff @(posedge pclk or negedge presetn) begin
        if (!presetn) begin
            for (int i = 0; i < MEM_DEPTH; i++) mem[i] <= '0;
        end else begin
          if (access_phase && pready && pwrite && !access_err) begin
                if (pstrb[0]) mem[paddr[6:2]][7:0]   <= pwdata[7:0];
                if (pstrb[1]) mem[paddr[6:2]][15:8]  <= pwdata[15:8];
                if (pstrb[2]) mem[paddr[6:2]][23:16] <= pwdata[23:16];
                if (pstrb[3]) mem[paddr[6:2]][31:24] <= pwdata[31:24];
            end 
        end
    end




endmodule
  
