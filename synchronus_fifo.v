`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2025 14:31:15
// Design Name: seenu
// Module Name: synchronus_fifo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
//2d register
//flags
//parameters
//logfunctions

module synchronus_fifo(clk,reset, wr_en,rd_en,wdata,rdata ,full, overflow, empty ,underflow);
    parameter WIDTH = 8;
    parameter FIFO_SIZE = 16;
    parameter PTR = $clog2(FIFO_SIZE);
    input clk,reset, wr_en, rd_en;
    input[WIDTH-1 : 0] wdata;
    output reg [WIDTH -1 : 0] rdata;
    output reg full, overflow, empty, underflow;
    reg [WIDTH-1 : 0] fifo [FIFO_SIZE-1 :0];
    reg [PTR-1 :0 ]rd_p,wr_p;
    reg wr_toggle , rd_toggle;
    integer i;
    
    
    always @(posedge clk) begin
    
        if (reset == 1'b1) begin
            rdata <= 1'b0;
            full <= 1'b0;
            overflow <= 1'b0;
            empty <= 1'b1;
            underflow <= 1'b0;
            rd_p  <= 1'b0;
            wr_p <= 1'b0;
            wr_toggle <= 1'b0;
            rd_toggle <= 1'b0;
            for (i = 0 ; i <FIFO_SIZE ; i = i+1) fifo[i] <= 1'b0;
        end
        
        else begin
            if (wr_en == 1'b1) begin
                if(full == 1'b1) overflow <= 1'b1;
                else begin
                    fifo [wr_p] <= wdata ;
                    if (wr_p == FIFO_SIZE -1) begin
                        wr_p <= 1'b0;
                        wr_toggle <= ~wr_toggle ;
                    end
                    else wr_p <= wr_p + 1'b1;
                end
            end
            else if (rd_en == 1'b1) begin
                if (empty == 1'b1) underflow = 1'b1;
                else begin
                    rdata = fifo[rd_p];
                    if (rd_p == FIFO_SIZE-1) begin
                        rd_p <= 1'b0;
                        rd_toggle <= ~rd_toggle ;
                    end
                    else rd_p <= rd_p + 1'b1;
                end
            end
        end
    end
    
    always @(*) begin
         if ((wr_p ==rd_p)&&(wr_toggle != rd_toggle)) full = 1'b1;
         else full = 1'b0;
         if ((wr_p ==rd_p)&&(wr_toggle == rd_toggle)) empty = 1'b1;
         else empty = 1'b0 ;
    end
endmodule
