
module adcFIFO(adc_CLK,sys_CLK,Ain,Aout);
	input adc_CLK;
	input sys_CLK;
	input [13:0] Ain;
	output [13:0] Aout;
	
	reg[13:0] data0;
	reg[13:0] data1;
	reg[13:0] data2;
	
	always @(posedge adc_CLK)begin
		data0 <= Ain;
		end
		
	always @(posedge sys_CLK)begin
		data1 <= data0;
		end
	
	always @(posedge sys_CLK)begin
		data2 <= data1;
		end
		
	assign Aout = ~data2;
	
endmodule