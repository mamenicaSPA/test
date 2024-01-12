`timescale 1ns/1ps

//ADC controller for redpitaya STEMlab125-14
//signal delay = 8ns x 3~4clock 
//ADC rate = 125MHz/2 -> 62.5MHz

module DACcontroller(Ain1,Ain2,clk,
	dac_dat,dac_clk,dac_sel,dac_wrt,dac_rst);
	input[13:0] Ain1;  //2's complement
	input[13:0] Ain2;  //2's complement
	input clk;
	output[13:0] dac_dat;
	output dac_clk;
	output dac_sel;
	output dac_wrt;
	output dac_rst;
	
	wire[13:0] step0_1;    //offset binnary
	wire[13:0] step0_2;    //offset binnary
	wire[12:0] temp1;
	wire[12:0] temp2;
	reg[1:0] cnt;
	reg[13:0] data1;
	reg[13:0] data2;
	
	assign step0_1 = {Ain1[13],~Ain1[12:0]};
	assign step0_2 = {Ain2[13],~Ain2[12:0]};
	//assign dac_sel = ~cnt[1];
	assign dac_sel = 1'b1;
	assign dac_clk = clk;
	
	assign dac_dat = data1;
	//assign dac_dat = cnt[1]? data1:data2;
	
	assign dac_wrt = clk;
	assign dac_rst = 1'b0;
	
	always@(posedge clk)begin
		cnt <= cnt +1;
	end
	
	always@(posedge clk)begin
	   data1 <= step0_1;
	   data2 <= step0_2;
	end
	
	endmodule
