`timescale 1ns / 1ps

//ver1 

module fifo2dmav1(
            sysclk,din,fifo_read,M_AXIS_tdata,M_AXIS_tkeep,M_AXIS_tlast,M_AXIS_tready,M_AXIS_tvalid
    );
    
	input sysclk;
	input [31:0]din;
	
	output fifo_read;
	output [31:0]M_AXIS_tdata;
	output [3:0]M_AXIS_tkeep;
	output M_AXIS_tlast;
	input M_AXIS_tready;
	output M_AXIS_tvalid;
	
	reg [10:0]count;
	reg [31:0]data;
	
	always@(posedge sysclk)begin
	   data <= din;
	end
	
	always@(posedge sysclk)begin
	   if(count == 0)
	       if(M_AXIS_tready)
	           count <= 1;
	       else
	           count <= count;
	   else
	       count <= count + 1;
	end
	
	/*
	always@(posedge sysclk)begin
		if(cntset)
			datacount <=fifo_count ;
		else if(M_AXIS_tready)
			datacount <= datacount-1;
		else
			datacount <= datacount;
	end
	*/
	
    assign fifo_read = M_AXIS_tready;
	assign M_AXIS_tdata = data;
	assign M_AXIS_tkeep = 4'b1111;
	assign M_AXIS_tlast = (count==15)? 1:0;
	assign M_AXIS_tvalid = 1;
	
endmodule
