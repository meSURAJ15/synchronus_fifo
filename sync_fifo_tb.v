`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2025 14:57:05
// Design Name: 
// Module Name: sync_fifo_tb
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

`include "synchronus_fifo.v"
module sync_fifo_tb;
        parameter WIDTH = 8;
        parameter FIFO_SIZE = 16;
        parameter PTR = $clog2(FIFO_SIZE);
        reg clk,reset, wr_en, rd_en;
        reg [WIDTH-1 : 0] wdata;
        wire [WIDTH -1 : 0] rdata;
        wire full, overflow, empty, underflow;
        integer i,j,k,l,wr_delay, rd_delay;
        reg [20*8 - 1 : 0] test_data;
        synchronus_fifo # (.WIDTH(WIDTH), .FIFO_SIZE(FIFO_SIZE), .PTR(PTR)) dut(clk, reset, wr_en,rd_en, wdata,rdata,full,overflow, empty,underflow);
        initial clk = 0;
        always #5 clk = ~clk;
        initial begin
            $value$plusargs("test_data = %0s", test_data);
            clk = 0;
            reset = 1 ;
            wr_en = 0;
            rd_en = 0;
            wdata = 0;
            repeat(2)@(posedge clk);
            reset = 0;
            case(test_data)
                    "FULL":begin
                           write(FIFO_SIZE);
                           end
                    "EMPTY":begin
                            write(FIFO_SIZE);
                            read(FIFO_SIZE);
                            end
                    "OVERFLOW":begin
                               write(FIFO_SIZE+1);
                               read(FIFO_SIZE);
                               end
                    "UNDERFLOW":begin
                                write(FIFO_SIZE);
                                read(FIFO_SIZE+1);
                               end  
                     "CONCURRENT" : begin
                                        fork
                                            begin
                                                for (k = 0; k <FIFO_SIZE; k = k+1) begin
                                                    write(1);
                                                    wr_delay = $urandom_range(5,10);
                                                    #(wr_delay);                                                end
                                            end
                                            begin
                                                wait (empty == 1'b0);
                                                for(l = 0 ; l <FIFO_SIZE; l = l+1)begin
                                                    read (1);
                                                    rd_delay = $urandom_range(5,10);
                                                    #(rd_delay);
                                                end
                                            end
                                        join
                                    end
            endcase
            
            
            //write(FIFO_SIZE);
            //read(FIFO_SIZE);
                 #100;
                 $finish;
            end
            
        	task write(input integer num_writes);
            begin
                for(i=0;i<num_writes;i=i+1)begin
                    @(posedge clk);
                    wr_en=1;
                    wdata=$random;
                end
                @(posedge clk);
                wr_en=0;
                wdata=0;
            end
            endtask
            task read(input integer num_reads);
            begin
                for(j=0;j<num_reads;j=j+1)begin
                    @(posedge clk);
                    rd_en=1;
                end
                @(posedge clk);
                rd_en=0;
            end
            endtask
        
        
        
endmodule
