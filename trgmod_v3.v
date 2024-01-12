`timescale 1ns / 1ps

//14'h2300<- 3V TRG LEVEL
//v0 : simple compalator
//v1 : posedge detection
//v2 : more simple code
//v3 : Schmitt trigger

module trig_modv3(ain,clk,trg,trgLv_H,trgLv_L);
input [0:0]  clk;
input [13:0] ain;
input signed [13:0] trgLv_H;
input signed [13:0] trgLv_L;
output  trg;

reg Hflg;					//Analog comparator flag(trgLv_H)
reg Lflg;					//Analog comparator flag(trgLv_L)
reg trgreg;					//trigger out reg
reg signed [13:0] predata;	//before 1 clk Analog data reg

wire LH_edge;				//Analog posedge flag
wire HL_edge;				//Analog negedge flag
wire signed [13:0] step0;	//converted Analoginput

assign step0 = ~{ain[13],~ain[12:0]};	//offset binary to signed data

always @(posedge clk)begin		//when step0 > trgLv_H, Hflg:H
    if(step0>trgLv_H && Hflg==1'b0)
        Hflg = 1'b1;
    else
        Hflg = 1'b0;
end

always @(posedge clk)begin		//when step0 < trgLv_L, Lflg:H
    if(step0<trgLv_L && Lflg==1'b0)
        Lflg = 1'b1;
    else
        Lflg = 1'b0;
end

always @(posedge clk)begin		//before 1clk data
        predata <= step0;
end

always @(posedge clk)begin		//posedge:L->H, negedge:H->L, else X->X
    if(LH_edge)
        trgreg <= 1'b1;
    else if(HL_edge)
        trgreg <= 1'b0;
	else 
		trgreg <= trgreg;
end


assign LH_edge = (Hflg && step0 > predata)? 1'b1:1'b0;	//posedge
assign HL_edge = (Lflg && step0 < predata)? 1'b1:1'b0;  //negedge

assign trg = trgreg;

endmodule

//                *normal palse	*noisy palse				*impalse nois
//																*low level nois
//				       __		     _   _                 	
//trgLv_H---	      /	 \		    / \_/ \   _            	|
//				     /	  \		   /       \_/ \   _       	|
//trgLv_L---	    /	   \	  /             \_/ \      	|
//				   /	    \	 /                   \     	|	 	/\
//				__/			 \__/                     \_____|___/\_/  \__
//Hflg			______----__________---_---_________________-____________
//Lflg			-----______--------_____________---_--------_------------
//LHedge		______-_____________-___-________________________-___--__
//HLedge		___________---__________________-___---__________________
//trgreg		______-----_________------------_________________________
//
//	If Hflg is falsely detected by impalse noise,
//	it will be canceled by the HLedge by low level nois.
//
//	LH(HL)edge is detect Analog edge. ex:3V->5V(5V->3V) (*not disital edge, ex: Hflg L->H)
