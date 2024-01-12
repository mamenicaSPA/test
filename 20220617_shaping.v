`timescale 1ns / 1ps

module shaping(
inp,outp,outp2,outp3,clk,count,rst
    );

    input [13:0] inp;
    input clk;
    input rst;
    output [15:0] outp;
    output [15:0] outp2;
    output[7:0] count;
    output [13:0] outp3;

    (* dont_touch = "true" *) wire signed[31:0] step0;
    wire signed[31:0] step1;
    wire signed[31:0] step2;
    wire signed[31:0] step3;
    wire signed[31:0] step4;
    wire signed[31:0] step5;

	reg signed[31:0] temp1;
	reg signed[31:0] temp2;
	reg signed[31:0] temp3;
	reg signed[31:0] temp4;
	reg signed[31:0] temp5;

    reg signed[31:0]  data[0:1024];
    reg signed[31:0]  data1[0:1024];
    reg signed[31:0]  data2[0:1024];
    reg signed[31:0]  data3;
    reg signed[31:0]  data4;
    reg [12:0] cnt = 0;

    integer i;
    integer gain = 4;

    always @(posedge clk)begin
        cnt = cnt+1;
    end

    always @(posedge clk)begin
        data[0] <= step0;
        for(i=0+1;i<1024;i=i+1)begin
            data[i]<=data[i-1];
        end
     end

    always @(posedge clk)begin
        data1[0] <= temp1;
        for(i=0+1;i<1024;i=i+1)begin
            data1[i]<=data1[i-1]; 
        end
    end

    always @(posedge clk)begin
        data2[0] <= temp2;
        for(i=0+1;i<1024;i=i+1)begin
            data2[i]<=data2[i-1]; 
        end
    end

    always @(posedge clk)begin
        if(rst)
            data3 <= 32'h0000_0000;
        else
            data3 <= step4; 
    end

    always @(posedge clk)begin
        if(rst)
            data4 <= 32'h0000_0000;
        else
            data4 <= step5;
    end

	always @(posedge clk)begin
			temp1 <= step1;
			temp2 <= step2;
			temp3 <= step3;
			temp4 <= step4;
			temp5 <= step5;
	end

    assign step0 = {{19{inp[13]}},inp[12:0]};

    assign step1 = step0 - data[511];
    assign step2 = temp1 - data1[511];
    assign step3 = temp2 + data2[511];
    assign step4 = temp3 + data3;
    assign step5 = temp3>>2 + step4 + data4;

    assign outp ={{3{inp[13]}},inp[12:0]};
    assign outp2 =temp4[23:8];
    assign outp3 = data[511];
    assign count = cnt;

endmodule