`timescale 1ns / 1ps

module shaping(
inp,outp,outp2,clk,count
    );
    
    input [13:0] inp;
    input clk;
    output [15:0] outp;
    output [15:0] outp2;
    output[7:0] count;
    
    (* dont_touch = "true" *) wire signed[31:0] step0;
    wire signed[31:0] step1;
    wire signed[31:0] step2;
    wire signed[31:0] step3;
    wire signed[31:0] step4;
    wire signed[31:0] step5;
    
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
        data1[0] <= step1;
        for(i=0+1;i<1024;i=i+1)begin
            data1[i]<=data1[i-1]; 
        end
    end
    
    always @(posedge clk)begin

        data2[0] <= step2;
        for(i=0+1;i<1024;i=i+1)begin
            data2[i]<=data2[i-1]; 
        end
    end
     
    always @(posedge clk)begin
            data3 <= step4;
    end
    
    always @(posedge clk)begin
            data4 <= step5;
    end
    
    assign step0 = {{19{inp[13]}},inp[12:0]};
    
    assign step1 = step0 - data[511];
    assign step2 = step1 - data1[511];
    assign step3 = step2 + data2[511];
    assign step4 = step3+ data3;
    assign step5 = step3>>2 + step4 + data4;
    
    assign outp ={{3{inp[13]}},inp[12:0]};
    assign outp2 =step3[15:0];
    assign count = cnt;
    
endmodule