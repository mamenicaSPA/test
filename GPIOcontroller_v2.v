`timescale 1ns / 1ps

//ver1 
//ver2 : low level trg made. v1 <-> v2 compatibility.

//*GPIO input-------------
//  0x0000_0000         //
//    +--+ +--+         //
//     02   01          //
//01: function select   //
//02: send data 16bit   //

//*function code--------------
//  0000_0000_0000_0000     //
//  +--+ +--+ +--+ +--+     //
//   04   03   02   01      //
//01: normal function ch0   //
//02: output function       //
//03: normal function ch1   //
//04: reserved              //

//////////////////////////
//  function list ch0   //
//  input   function    //
//  0001    *start      //
//  0010    *inquiry    //
//  0100    *read       //
//  1000    *stop,sleap //
//////////////////////////
//  function list output//
//  0001    *DACdata    //
//  0010    *H_TRGLv set//
//  0100	*L_TRGLv set//
//////////////////////////
//  function list ch1   //
//  input   function    //
//  0001    - common ch0//
//  0010    *inquiry    //
//  0100    *read       //
//  1000    - common ch0//
//////////////////////////


module GPIOcontroller_modv2(
            SELECT_in, DATA_in0, DATAcnt_in0,full, clk,
            GPIO_out, _RESET_out, DATAread_out0, SLEAP_out, ANALOG_out,H_TRGLEVEL_out,L_TRGLEVEL_out
    );
    
    input[31:0] SELECT_in;
    input[31:0] DATA_in0;
    input[15:0]  DATAcnt_in0;
    input       full;
    input       clk;
    output[31:0] GPIO_out;
    output      DATAread_out0;
    output      _RESET_out;
    output      SLEAP_out;
    output[13:0] ANALOG_out;
    output[13:0] H_TRGLEVEL_out;
	output[13:0] L_TRGLEVEL_out;
    
    reg resetflag;
    reg readflag0;
    reg readflag1;
    reg[13:0] ANALOG_data;
    reg[13:0] H_TRGLEVEL_data;
	reg[13:0] L_TRGLEVEL_data;
    
    //0_0001 start,reset conect to count reset    
    always@(posedge clk)begin
        if(32'h0000_0001 == (32'h0000_ffff & SELECT_in))
            resetflag <= 1;
        else
            resetflag <= 0;
    end
    assign _RESET_out = (32'h0000_0001&SELECT_in)? ~resetflag:0;
   
    // 0_0100 read  clk conect to FIFO read clk   
    always@(posedge clk)begin
        if(32'h0000_0004 == (32'h0000_ffff & SELECT_in))
            readflag0 <= 1;
        else
            readflag0 <= 0;
    end
    assign DATAread_out0 = (32'h0000_0004&SELECT_in)? ~readflag0:0;
    
    //1_0010 H TRG LEVEL data resive from gpio, conect to H_TRGLEVEL
    always@(posedge clk)begin
        if(32'h0000_0020 ==(32'h0000_ffff&SELECT_in))
            H_TRGLEVEL_data <= (SELECT_in >> 16);
        else
            H_TRGLEVEL_data <= H_TRGLEVEL_data;
    end
    assign H_TRGLEVEL_out = H_TRGLEVEL_data;
	
	//1_0100 L TRG LEVEL data resive from gpio, conect to L_TRGLEVEL
    always@(posedge clk)begin
        if(32'h0000_0040 ==(32'h0000_ffff&SELECT_in))
            L_TRGLEVEL_data <= (SELECT_in >> 16);
        else
            L_TRGLEVEL_data <= L_TRGLEVEL_data;
    end
    assign L_TRGLEVEL_out = L_TRGLEVEL_data;
    
    //0_0010 data num OR 0100 data read selector. conect to GPIO in
    assign  GPIO_out = ((32'h0000_ffff & SELECT_in) == 32'h0000_0002)? 32'h0000_0000|{full,DATAcnt_in0} : 32'h0000_0000|DATA_in0;
    
    //0_1000 stop,sleap conect to FIFO write enable
    assign  SLEAP_out = ((32'h0000_ffff & SELECT_in) == 32'h0000_0008)? 0:1;
    
endmodule
