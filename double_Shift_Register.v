`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/25 00:31:29
// Design Name: 
// Module Name: 2channel_Shift_Register
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


module double_Shift_Register(
    clk,inA,inB,outA,outB
    );
    input [15:0] inA;
    input [15:0] inB;
    input clk;
    output [15:0] outA;
    output [15:0] outB;
    
     reg [15:0] bufA[0:1024];
     reg [15:0] bufB[0:1024];
     
     integer i;
     
     always @(posedge clk)begin
        bufA[0] <= inA;
        for(i=0+1;i<1024;i=i+1)begin
            bufA[i]<=bufA[i-1];
        end
     end
     
     always @(posedge clk)begin
        bufB[0] <= inB;
        for(i=0+1;i<1024;i=i+1)begin
            bufB[i]<=bufB[i-1];
        end
     end
     
     assign outA = bufA[63];
     assign outB = bufB[63];
     
endmodule
