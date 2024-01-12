`timescale 1ns / 1ps

module cps_counter(
reset,
trg,
clk,
cnt,
wflag
    );
	input trg;
	input clk;
	input reset;
	output[15:0] cnt;
	output wflag;
	
	reg[15:0] count;
	reg[26:0] timer;
    
	always@(posedge clk)begin
		if(reset)
			timer<=26'h000_0000;
		else
			timer<=timer+1;
	end
	
	always@(posedge trg)begin
		if(timer)
			count <=count+1;
		else
			count <=16'h0000;
	end
		
	assign wflag = (timer == 26'h3_ff_ffff)? 1:0;
	assign cnt = count;	
endmodule