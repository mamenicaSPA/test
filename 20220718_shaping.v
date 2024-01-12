`timescale 1ns / 1ps

module shaping_v2(
inp,outp0,outp1,outp2,outp3,outp4,outp5,outp6,clk,count,rst
    );

    input [13:0] inp;
    input clk;
    input rst;
    output [15:0] outp0;
    output [15:0] outp1;
    output [15:0] outp2;
    output [15:0] outp3;
    output [15:0] outp4;
    output [15:0] outp5;
    output [13:0] outp6;
    output[7:0] count;

    (* dont_touch = "true" *) wire signed[31:0] step0;
    wire signed[31:0] step1;
    wire signed[31:0] step2;
    wire signed[31:0] step3;
    wire signed[31:0] step4;
    wire signed[31:0] step5;
    wire signed[31:0] step6;

	reg signed[31:0] temp1;
	reg signed[31:0] temp2;
	reg signed[31:0] temp3;
	reg signed[31:0] temp4;
	reg signed[31:0] temp5;
	reg signed[31:0] temp6;

    reg signed[31:0]  data[0:4096];
    reg signed[31:0]  data3;
    reg signed[31:0]  data4;
    reg [12:0] cnt = 0;
    
    parameter k = 100;
    parameter l = 200;
    localparam depth = $clog2(k+l+k)*2-3;

    integer i;
    integer gain = 4;

    always @(posedge clk)begin
        cnt = cnt+1;
    end

    always @(posedge clk)begin
        if(rst)
            for(i=0;i<1024;i=i+1)begin
                data[i]<=32'h0000_0000;
            end
        else begin
            data[0] <= step0;
            for(i=0+1;i<1024;i=i+1)begin
                data[i]<=data[i-1];
            end
        end
     end

	always @(posedge clk)begin
	   if(rst)begin
	        temp1 <=  32'h0000_0000;
			temp2 <=  32'h0000_0000;
			temp3 <=  32'h0000_0000;
			temp4 <=  32'h0000_0000;
			temp5 <=  32'h0000_0000;
			temp6 <=  32'h0000_0000;
	   end else begin
			temp1 <= step1;
			temp2 <= step2;
			temp3 <= step3;
			temp4 <= step4;
			temp5 <= step5;
			//temp5 <= {{depth{step5[31]}},step5[31:depth]};
			temp6 <= step6;
	   end
	end

    assign step0 = {{19{inp[13]}},inp[12:0]};

    assign step1 = step0 - data[k];         //sum1
    assign step2 = data[k+l] - data[k+l+k]; //sum2
    assign step3 = temp1 - temp2;           //sum3
    assign step4 = temp3 + temp4;           //acc1
    //assign step5 ={{3{temp3[31]}},temp3[31:3]} + step4; //sum4
    assign step5 ={{3{temp3[31]}},temp3[31:3]} + step4 + temp5;
    assign step6 = temp5 + temp6;           //acc2

    assign outp0 = step0[15:0];
    assign outp1 = step1[15:0];
    assign outp2 = step2[15:0];
    assign outp3 = step3[15:0];
    assign outp4 = step4[depth+15:depth];
    assign outp5 = step5[depth+15:depth];
    assign outp6 = step5[depth+13:depth];
    
    assign count = cnt;

endmodule