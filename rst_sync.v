`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/03 14:51:38
// Design Name: 
// Module Name: rst_sync
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


module rst_sync(rst,sys_clk,adc_clk,sync_rst

    );
    input rst;
    input sys_clk;
    input adc_clk;
    output sync_rst;
    reg rst_flag;
    reg sync_flag;
    
    always@(posedge sys_clk)begin
        if(rst)
            rst_flag<=1'b1;
        else if(sync_flag)
            rst_flag <= 1'b0;
        else
            rst_flag<=rst_flag;
    end
    
    always@(posedge adc_clk)begin
        if(rst_flag)
            sync_flag <= 1'b1;
        else
            sync_flag <= 1'b0;
    end
    assign sync_rst = sync_flag;
    
endmodule
