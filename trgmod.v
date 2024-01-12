`timescale 1ns / 1ps

//14'h2300<- 3V TRG LEVEL

module trig_modv3(ain,clk,trg,TRGLEVEL);
input [0:0]  clk;
input [13:0] ain;
input [13:0] TRGLEVEL;
output  trg;

reg [0:0] flag;
reg [0:0] trgreg;
reg [13:0] predata;

always @(posedge clk)begin
    if(~ain>TRGLEVEL && flag==1'b0)
        flag = 1'b1;
    else
        flag = 1'b0;
end

always @(posedge clk)begin
    if(~ain>TRGLEVEL && flag==1'b0)
        predata = ain;
    else
        predata = 14'b11_1111_1111_1111;
end

always @(posedge clk)begin
    if(flag && ain < predata)
        trgreg = 1'b1;
    else
        trgreg = 1'b0;
end



assign trg = trgreg;
        
        

endmodule
