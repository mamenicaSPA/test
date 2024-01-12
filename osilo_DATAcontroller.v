//65536*2
module osilo_DATAcontroller(TRG,CLK,empty,reset,full,write_flag);

	input TRG;
	input CLK;
	input reset;
	input empty;
	input full;
	output write_flag;
	
	reg[15:0] counter;
	
	always@(posedge CLK)begin
		if(~reset & (|counter | (TRG & empty)))
			counter <= counter+1;
		else
			counter <= 16'h0000;
	end
	
	assign write_flag = (|counter) & (~full);
	
endmodule