
module apb_master #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
)(
    input  wire                    pclk,
    input  wire                    presetn,
    input  wire                    req,
    input  wire                    wr,
    input  wire [ADDR_WIDTH-1:0]   addr,
    input  wire [DATA_WIDTH-1:0]   wdata,
    input  wire [3:0]              strb,
    input  wire [2:0]              prot,
    output reg  [DATA_WIDTH-1:0]   rdata,
    output reg                     done,
    output reg                     error,

    input  wire [DATA_WIDTH-1:0]   prdata,
    input  wire                    pslverr,
    input  wire                    pready,

    output reg                     psel,
    output reg                     penable,
    output reg                     pwrite,
    output reg  [ADDR_WIDTH-1:0]   paddr,
    output reg  [DATA_WIDTH-1:0]   pwdata,
    output reg  [3:0]              pstrb,
    output reg  [2:0]              pprot
);

    typedef enum logic [1:0] {
        idle   = 2'b00,
        setup  = 2'b01,
        access = 2'b10
    } state_t;

    state_t state;

     always_ff @(posedge pclk or negedge presetn) begin
        if (!presetn) begin
            state   <= idle;
            psel    <= 1'b0;
            penable <= 1'b0;
            pwrite  <= 1'b0;
            paddr   <= '0;
            pwdata  <= '0;
            pstrb   <= 4'h0;
            pprot   <= 3'b000;
            rdata   <= '0;
            done    <= 1'b0;
            error   <= 1'b0;
        end else begin
            done  <= 1'b0;
            error <= 1'b0;

            case (state)

                idle: begin
                    psel    <= 1'b0;
                    penable <= 1'b0;
                    if (req) begin
                        paddr   <= addr;
                        pwdata  <= wdata;
                        pwrite  <= wr;
                        pstrb   <= strb;
                        pprot   <= prot;
                        psel    <= 1'b1;
                        state   <= setup;
                    end
                end

                setup: begin
                    penable <= 1'b1;
                    state   <= access;
                end

                access: begin
                    if (pready) begin
                        done    <= 1'b1;
                        error   <= pslverr;
                        rdata   <= prdata;
                        penable <= 1'b0;
                        if (req) begin
                            paddr   <= addr;
                            pwdata  <= wdata;
                            pwrite  <= wr;
                            pstrb   <= strb;
                            pprot   <= prot;
                            psel    <= 1'b1;
                            penable <= 1'b0;
                            state   <= setup;
                        end else begin
                            psel <= 1'b0;
                            state <= idle;
                        end
                    end
                end

                default: state <= idle;

            endcase
        end
    end

endmodule


