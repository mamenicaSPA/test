`timescale 1ns / 1ps

module shaping_v5(
inp,shapedout,conf,clk,count,rst
    ,r1,r2);

    input [13:0] inp;
	input [11:0] conf;
    input clk;
    input rst;
	output [13:0] shapedout;
    output[11:0] count;

    output r1;
    output r2;
    
    assign r1 = rst1;
    assign r2 = rst2;

    (* dont_touch = "true" *) wire signed[31:0] step0_0;
    (* dont_touch = "true" *) wire signed[31:0] step0;
    wire signed[31:0] step1;
    wire signed[31:0] step2;
    wire signed[63:0] step3;
    wire signed[63:0] step4;
    wire signed[63:0] step5;
    wire signed[63:0] step6;
    wire signed[63:0] step7;
    
    wire [1:0] sel;
    wire [4:0] m3;
    wire [4:0] tau;
    
    assign tau = conf[4:0];
    assign m3 = conf[9:5];
    assign sel = conf[11:10]; 

    reg [13:0] temp0;
	reg signed[31:0] temp1;
	reg signed[31:0] temp2;
	(* dont_touch = "true" *)reg signed[63:0] temp3;
	(* dont_touch = "true" *)reg signed[63:0] temp4;
	(* dont_touch = "true" *)reg signed[63:0] temp5;
	(* dont_touch = "true" *)reg signed[63:0] temp6;
	(* dont_touch = "true" *)reg signed[63:0] temp7;
	reg signed[63:0] temp8;

    reg signed[31:0]  data[0:4096];
    reg signed[31:0]  data3;
    reg signed[31:0]  data4;
    reg [11:0] cnt;
    reg rst1;
    reg rst2;
    reg rst3;
    reg rst4;
    reg rst5;
    reg rst6;
    reg rst7;
    
    parameter k = 100;
    parameter l = 200;
	parameter TAUMAX = 8'hff;
    localparam depth = $clog2(k+1)-1;

    integer i;
    integer gain = 4;

    always @(posedge clk)begin
    if(rst)
        cnt <= 12'h001;
    else if(|cnt)
            cnt <= cnt+1;
        else
            cnt <= 12'h000;
    end
    
    always@(posedge clk)begin
        temp0 <= inp;
    end
    
    always @(posedge clk)begin
        if(rst)
            rst1 <=1;
        else if(rst1 & cnt<k+l+k+1)
            rst1 <=1;
        else
            rst1 <=12'h000;
    end
    always @(posedge clk)begin
        if(rst)
            rst2 <=1;
        else if(rst1 & cnt<k+l+k+2)
            rst2 <=1;
        else
            rst2 <=12'h000;
    end
    always @(posedge clk)begin
        if(rst)
            rst3 <=1;
        else if(rst1 & cnt<k+l+k+3)
            rst3 <=1;
        else
            rst3 <=12'h000;
    end
    always @(posedge clk)begin
        if(rst)
            rst4 <=1;
        else if(rst1 & cnt<k+l+k+4)
            rst4 <=1;
        else
            rst4 <=12'h000;
    end
    always @(posedge clk)begin
        if(rst)
            rst5 <=1;
        else if(rst1 & cnt<k+l+k+5)
            rst5 <=1;
        else
            rst5 <=12'h000;
    end
    always @(posedge clk)begin
        if(rst)
            rst6 <=1;
        else if(rst1 & cnt<k+l+k+6)
            rst6 <=1;
        else
            rst6 <=12'h000;
    end
    
     always @(posedge clk)begin
        if(rst)
            rst7 <=1;
        else if(rst1 & cnt<k+l+k+7)
            rst7 <=1;
        else
            rst7 <=12'h000;
    end
//--------------------------------------------------
//--------------------------------------------------
    always @(posedge clk)begin
        data[0] <= step0;
        for(i=0+1;i<1024;i=i+1)begin
            data[i]<=data[i-1];
        end
     end

	always @(posedge clk)begin
	   if(rst2)
	        temp1 <=  32'h0000_0000;
	   else 
			temp1 <= step1;
	end
	always @(posedge clk)begin
	   if(rst2)
			temp2 <=  32'h0000_0000;
	   else 
			temp2 <= step2;
	end
	always @(posedge clk)begin
	   if(rst3)
			temp3 <=  64'h0000_0000_0000_0000;
	   else 
			temp3 <= step3;
	end
	
	always @(posedge clk)begin
	   if(rst4)begin
			temp4 <=  64'h0000_0000_0000_0000;
	   end else begin
			temp4 <= step4;
	   end
	end
	
	always @(posedge clk)begin
	   if(rst5)
			temp5 <=  64'h0000_0000_0000_0000;
	   else
			case(tau)
			5'h00:temp5<=step4;				//   0:1
			5'h01:temp5<=temp3+step4;		//   1:1
			5'h02:temp5<=temp3+(step4>>>1);	//   2:1
			5'h03:temp5<=temp3+(step4>>>2);	//   4:1
			5'h04:temp5<=temp3+(step4>>>3);	//   4:1
			5'h05:temp5<=temp3+(step4>>>4);	//   8:1
			5'h06:temp5<=temp3+(step4>>>5);	//  16:1
			5'h07:temp5<=temp3+(step4>>>6);	//  32:1
			5'h08:temp5<=temp3+(step4>>>7);	//  64:1
			5'h09:temp5<=temp3+(step4>>>8);	// 128:1
			5'h0a:temp5<=temp3+(step4>>>9);	// 256:1
			5'h0b:temp5<=temp3+(step4>>>10);	// 512:1
			5'h0c:temp5<=temp3+(step4>>>11);	//1024:1
			5'h0d:temp5<=temp3+(step4>>>12);	//2048:1
			5'h0e:temp5<=temp3+(step4>>>13);	//4096:1
			5'h0f:temp5<=temp3+(step4>>>14);				// inf:1
			5'h10:temp5<=temp3+(step4>>>15);				//   0:1
			5'h11:temp5<=temp3+(step4>>>16);		//   1:1
			5'h12:temp5<=temp3+(step4>>>17);	//   2:1
			5'h13:temp5<=temp3+(step4>>>18);	//   4:1
			5'h14:temp5<=temp3+(step4>>>19);	//   4:1
			5'h15:temp5<=temp3+(step4>>>20);	//   8:1
			5'h16:temp5<=temp3+(step4>>>21);	//  16:1
			5'h17:temp5<=temp3+(step4>>>22);	//  32:1
			5'h18:temp5<=temp3+(step4>>>23);	//  64:1
			5'h19:temp5<=temp3+(step4>>>24);	// 128:1
			5'h1a:temp5<=temp3+(step4>>>25);	// 256:1
			5'h1b:temp5<=temp3+(step4>>>26);	// 512:1
			5'h1c:temp5<=temp3+(step4>>>27);	//1024:1
			5'h1d:temp5<=temp3+(step4>>>28);	//2048:1
			5'h1e:temp5<=temp3+(step4>>>29);	//4096:1
			5'h1f:temp5<=temp3;				// inf:1
			endcase
	end
	
	always @(posedge clk)begin
	   if(rst6)
			temp6 <=  64'h0000_0000_0000_0000;
	   else 
		    temp6 <= step6;
	end
	
	always @(posedge clk)begin
	   if(rst7)begin
			temp7 <=  64'h0000_0000_0000_0000;
	   end else begin
	   case(m3)
	   5'h00:temp7 <= step7;   //input
	   5'h01:temp7 <= step7>>>1;
	   5'h02:temp7 <= step7>>>2;
	   5'h03:temp7 <= step7>>>3;
	   5'h04:temp7 <= step7>>>4;
	   5'h05:temp7 <= step7>>>5;
	   5'h06:temp7 <= step7>>>6;
	   5'h07:temp7 <= step7>>>7;
	   5'h08:temp7 <= step7>>>8;
	   5'h09:temp7 <= step7>>>9;
	   5'h0a:temp7 <= step7>>>10;
	   5'h0b:temp7 <= step7>>>11;
	   5'h0c:temp7 <= step7>>>12;
	   5'h0d:temp7 <= step7>>>13;
	   5'h0e:temp7 <= step7>>>14;
	   5'h0f:temp7 <= step7>>>15;
	   5'h10:temp7 <= step7>>>16;
	   5'h11:temp7 <= step7>>>17;
	   5'h12:temp7 <= step7>>>18;
	   5'h13:temp7 <= step7>>>19;
	   5'h14:temp7 <= step7>>>20;
	   5'h15:temp7 <= step7>>>21;
	   5'h16:temp7 <= step7>>>22;
	   5'h17:temp7 <= step7>>>23;
	   5'h18:temp7 <= step7>>>24;
	   5'h19:temp7 <= step7>>>25;
	   5'h1a:temp7 <= step7>>>26;
	   5'h1b:temp7 <= step7>>>27;
	   5'h1c:temp7 <= step7>>>28;
	   5'h1d:temp7 <= step7>>>29;
	   5'h1e:temp7 <= step7>>>30;
	   5'h1f:temp7 <= step7>>>31;
	   endcase
	   end
	end

    assign step0_0 = {{19{inp[13]}},inp[12:0]};
    assign step0 =step0_0;
    
    //assign step0 = {{19{inp[13]}},inp[12:0]};

    assign step1 = step0 - data[k];         //sum1
    assign step2 = data[k+l] - data[k+l+k]; //sum2
    assign step3 = {{17{temp1[15]}},temp1[14:0]} - {{17{temp2[15]}},temp2[14:0]};           //sum3
    assign step4 = temp3 + temp4;           //acc1
    assign step5 = temp5;
    assign step6 = temp6 + temp5;
    //assign step5 ={{3{temp3[31]}},temp3[31:3]} + step4; //sum4
    //assign step5 ={{3{temp3[31]}},temp3[31:3]} + step4 + temp5;
    //assign step6 = temp7 + temp6;           //acc2
    assign step7 = sel[1]? (sel[0]? temp6:step5):(sel[0]? temp3:{{51{inp[13]}},inp[12:0]}); 

	assign shapedout = temp7[13:0];
    
    assign count = cnt;

endmodule

//	ver2:	Resolve the phenomenon of base-line decline(delete data[] reset)