
module mycounter(clk,out);
	input clk;
	output[31:0] out;
	
	reg[31:0] cnt;
	
	always @(posedge clk)begin
		cnt <= cnt+1;
	end
	
	assign out = cnt;
	
endmodule