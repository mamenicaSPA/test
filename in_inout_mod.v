`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/26 15:59:19
// Design Name: 
// Module Name: inout_exchange_mod
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


module in_inout(inp,inout_o,inout_o_,clk

    );
	input inp;
    input clk;
    inout[7:0] inout_o;
    inout[7:0] inout_o_;
    reg[7:0]    regs;
    reg[7:0] count;
    
    always@(posedge clk)begin
        regs <= {6'b000000,~inp,inp};
    end
    
    always@(posedge clk)begin
        count <= count+1;
    end
         
    assign inout_o = regs;
    assign inout_o_ = (count > 8'h20)? 8'hf0:8'h00;
    
endmodule