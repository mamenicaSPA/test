`timescale 1ns / 1ps

module clk_div_v1(
clk,sel,div_clk
    );
    
    input clk;
	input[3:0] sel;
	output div_clk;
	
	wire[7:0] step0;
	wire[3:0] step1;
	wire[1:0] step2;
	wire step3;
	
	reg [15:0] div;
	reg out_reg;
    
    
    always @(posedge clk)begin
        div = div+1;
    end
    
    assign step0 = (sel[0])? {div[15],div[13],div[11],div[9],div[7],div[5],div[3],div[1]}:{div[14],div[12],div[10],div[8],div[6],div[4],div[2],div[0]};
    assign step1 = (sel[1])? {step0[7],step0[5],step0[3],step0[1]}:{step0[6],step0[4],step0[2],step0[0]};
    assign step2 = (sel[2])? {step1[3],step1[1]}:{step1[2],step1[0]};
    assign step3 = (sel[3])? step2[1]:step2[0];
    
    assign div_clk = step3;
    
endmodule