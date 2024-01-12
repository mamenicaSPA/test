`timescale 1ns / 1ps

//14'h2300<- 3V TRG LEVEL

module trig_modv2(ain,clk,trg,TRGLEVEL);
input [0:0]  clk;
input [13:0] ain;
input signed [13:0] TRGLEVEL;
output  trg;

reg [0:0] flag;
reg [0:0] trgreg;
reg signed [13:0] predata;

wire signed [13:0] step0;

assign step0 = {~ain[13],ain[12:0]};

always @(posedge clk)begin
    if(step0>TRGLEVEL && flag==1'b0)
        flag = 1'b1;
    else
        flag = 1'b0;
end

always @(posedge clk)begin
        predata <= step0;
end

always @(posedge clk)begin
    if(flag && step0 > predata)
        trgreg <= 1'b1;
    else
        trgreg <= 1'b0;
end



assign trg = trgreg;
        
        

endmodule
