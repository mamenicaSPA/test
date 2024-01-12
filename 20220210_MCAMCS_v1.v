`timescale 1ns / 1ps

//v1 : 20220210

module mcamcs_v1(clk,trg,rst,Ain,pout,tout,Wflg);
	input clk;			//125MHz.
	input rst;			//H:reset.
	input trg;
	input [13:0] Ain;	//analog input (signed ).
	output signed [13:0]pout;	//peak data out.
	output [17:0]tout;	//timing data out.
	output Wflg;		//FIFO wright flag.
	
	wire signed [13:0] step0;			//signed input
	
	reg trgreg;			//need to trg edge ditect.
	reg [10:0]  Wincnt;	//time window count.
	
	reg [17:0] timing;	//current timing data.
	reg [63:0] cnt;		//counter. reset by rst.
	
	(* dont_touch = "true" *) reg signed [13:0] peak;	//current peak data.
	
	//counter. reset by rst.
	always@(posedge clk)begin
		if(rst)
			cnt<=64'h0000_0000;
		else
			cnt<=cnt+1;
	end
	
	//genelate before 1clock trg input.
	always@(posedge clk)begin
		trgreg <= trg;
	end
	
	//timewindow cont. start by trg edge. stop by overflow.
	always@(posedge clk)begin
		if(Wincnt)
			Wincnt <= Wincnt+1;
		else if(trg&(~trgreg))	//trg edge.
			Wincnt <=11'h001;
		else
			Wincnt <=11'h000;
	end
	
	//capcher peak data, when timewindow is counting.
	always@(posedge clk)begin
		if(|Wincnt)
			if(step0 > peak)
				peak <= step0;
			else
				peak <= peak;
		else
			peak <= 14'h0000;
	end
	
	//timingdata set, when trg edge.
	always@(posedge clk)begin
		if(trg & (~|Wincnt))
			timing <= cnt[24:7];
		else
			timing <= timing;
	end
	
	//offset binary to signed data
	assign step0 =Ain;
	
	assign pout = peak;		//peak data out.
	assign tout = timing;	//timing data out.
	assign Wflg = &Wincnt;	//1clock palse flag when Wincnt = 0x00.
	
endmodule

//rst conect to external reset. Do not conect system reset from cpu.
//-> OK: conect to (external reset OR system) reset.