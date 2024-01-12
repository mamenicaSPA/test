`timescale 1ns / 1ps

module beseline_rem(
clk,rst,inp,outp,LFSR_out,startflg
    );
	input clk;
	input rst;
	input signed	[13:0]	inp;
	output signed	[13:0]	outp;
	output  [15:0]  LFSR_out;
	output startflg;
	
	
	(* dont_touch = "true" *)reg 	[13:0]	data0;
	reg signed [13:0]  data[0:255];
	reg 	[15:0]  count;
	reg signed [32:0] sum;
	reg [7:0]lfsr_cnt;
	reg signed [13:0] temp;
	wire 	nextLFSR;
	
	parameter 	seed = 10;
	integer 	i;

	reg    [15:0] r;
	
	always @(posedge clk)begin
	if(count==r)begin
	   data0<=inp;
	   data[0]<=data0;
	   for(i=0+1;i<256;i=i+1)begin
		  data[i]<=data[i-1];
		  end
	    end 
	    else begin
		data0   <= data0;
	    for(i=0;i<256;i=i+1)begin
		  data[i]<=data[i];
		end
		end
	end
	
	always @(posedge clk)begin
	   if(rst)
	       lfsr_cnt <=1;
	   else if(count == r)
	       lfsr_cnt <=(lfsr_cnt==8'hff)? 8'hff:(1 + lfsr_cnt);
	   else
	       lfsr_cnt <= lfsr_cnt;
	end
	
	always @(posedge clk)begin
	   if(rst)
	       sum <= 0;
	   else if(count==r)
	       sum <= sum + inp - ((lfsr_cnt==8'hff)? data[254]:0);
	   else
	       sum <= sum;
	end
	
	always @(posedge clk)begin
	   if(count==r | rst)
	       count <=0;
	   else
	       count <= count +1;
	end
	
	always @(posedge clk)begin
        if(rst)
            r<=seed;
        else if(count==r)
            //r <= {r[0], r[7], r[0]^r[6], r[0]^r[5], r[0]^r[4], r[3], r[2], r[1]};
            r <= {r[0],r[15],r[0]^r[14],r[0]^r[13],r[12],r[0]^r[11],r[10],r[9],r[8],r[7],r[6],r[5],r[4],r[3],r[2],r[1]};
        else
            r<=r;
    end
    
/*    always @(posedge clk)begin
        temp <= inp - sum[21:8];
    end*/

    assign outp = inp-sum[21:8];
	assign LFSR_out = sum[21:8];
	assign startflg = (lfsr_cnt==8'hff)? 0:1;
    

endmodule