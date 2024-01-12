`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/17 21:04:41
// Design Name: 
// Module Name: GPIOcontroller_modv1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

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
//  0010    *TRG Lv set //
//////////////////////////
//  function list ch1   //
//  input   function    //
//  0001    - common ch0//
//  0010    *inquiry    //
//  0100    *read       //
//  1000    - common ch0//
//////////////////////////


module GPIOcontroller_modv1(
            SELECT_in, DATA_in0, DATAcnt_in0, clk,
            GPIO_out, _RESET_out, DATAread_out0, SLEAP_out, ANALOG_out,TRGLEVEL_out
    );
    
    input[31:0] SELECT_in;
    input[31:0] DATA_in0;
    input[15:0]  DATAcnt_in0;
    input       clk;
    output[31:0] GPIO_out;
    output      DATAread_out0;
    output      _RESET_out;
    output      SLEAP_out;
    output[13:0] ANALOG_out;
    output[13:0] TRGLEVEL_out;
    
    reg resetflag;
    reg readflag0;
    reg readflag1;
    reg[13:0] ANALOG_data;
    reg[13:0] TRGLEVEL_data;
    
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
    
    //1_0010 TRG LEVEL data resive from gpio, conect to TRGLEVEL
    always@(posedge clk)begin
        if(32'h0000_0020 ==(32'h0000_ffff&SELECT_in))
            TRGLEVEL_data <= (SELECT_in >> 16);
        else
            TRGLEVEL_data <= TRGLEVEL_data;
    end
    assign TRGLEVEL_out = TRGLEVEL_data;
    
    //0_0010 data num OR 0100 data read selector. conect to GPIO in
    assign  GPIO_out = ((32'h0000_ffff & SELECT_in) == 32'h0000_0002)? 32'h0000_0000|DATAcnt_in0 : 32'h0000_0000|DATA_in0;
    
    //0_1000 stop,sleap conect to FIFO write enable
    assign  SLEAP_out = ((32'h0000_ffff & SELECT_in) == 32'h0000_0008)? 0:1;
    
endmodule
