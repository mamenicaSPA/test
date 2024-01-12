`timescale 1ns / 1ps

//ver1 
//ver2 : low level trg made. v1 <-> v2 compatibility.
//ver3 : more simplecodes. Add SCAtrg. v2 <-> v3 not compatibility. need to trgmod_v4.
//ver4 : add clock division selector.

//*GPIO input-------------
//  0xffff_ffff         //
//    +--+ +--+         //
//     02   01          //
//01: function select   //
//02: send data 16bit   //

//*function code--------------
//  0000_0000_0000_0000     //
//  +--+ +--+ +--+ +--+     //
//   04   03   02   01      //
//01: normal function ch0   //
//02: trg    function       //
//03: division etc			//
//04: reserved              //

//////////////////////////
//  function list ch0   //
//  input   function    //
//  0001    *start      //
//  0010    *inquiry    //
//  0100    *read       //
//  1000    *stop,sleap //
//////////////////////////////
//  function list output	//
//  0001    *H_TRGLv 1 set	//
//  0010	*L_TRGLv 1 set	//
//	0100	*H_TRGLv 2 set	//
//	1000	*L_TRGLv 2 set	//
//////////////////////////////////
//	function list clk division	//
//	0001	*adc,MCS clk div set//
//	0010	*tau set			//
//	0100	*reserved			//
//	1000	*reserved			//
//////////////////////////////////


module GPIOcontroller_modv4(
            SELECT_in, DATA_in0, DATAcnt_in0,full, sys_clk,
            GPIO_out, _RESET_out, DATAread_out0, SLEAP_out, ANALOG_out,TRGLEVEL_1_out,TRGLEVEL_2_out,ADC_clk_div,MCS_clk_div,shape_conf
    );
    
    input[31:0] SELECT_in;
    input[31:0] DATA_in0;
    input[15:0]  DATAcnt_in0;
    input       full;
    input       sys_clk;
    output[31:0] GPIO_out;
    output      DATAread_out0;
    output      _RESET_out;
    output      SLEAP_out;
    output[13:0] ANALOG_out;
    output[27:0] TRGLEVEL_1_out;
	output[27:0] TRGLEVEL_2_out;
	output[3:0] ADC_clk_div;
	output[3:0] MCS_clk_div;
	output[11:0] shape_conf;
    
	reg[11:0] shape_confset;
    reg resetflag;
    reg readflag0;
    reg readflag1;
    reg[13:0] ANALOG_data;
    reg[13:0] H_TRGLEVEL_data_1;
	reg[13:0] L_TRGLEVEL_data_1;
	reg[13:0] H_TRGLEVEL_data_2;
	reg[13:0] L_TRGLEVEL_data_2;
	reg[3:0] ADC_clk_division_data;
	reg[3:0] MCS_clk_division_data;
    
    //0_0001 start,reset conect to count reset    
    always@(posedge sys_clk)begin
        if(SELECT_in[0])
            resetflag <= 1;
        else
            resetflag <= 0;
    end
    assign _RESET_out = SELECT_in[0]/*? ~resetflag:0*/;
	
	//0_0010 data num OR 0100 data read selector. conect to GPIO in
    assign  GPIO_out = SELECT_in[1]? {15'h0000,full,DATAcnt_in0} : DATA_in0;
   
    // 0_0100 read  sys_clk conect to FIFO read sys_clk   
    always@(posedge sys_clk)begin
        if(SELECT_in[2])
            readflag0 <= 1;
        else
            readflag0 <= 0;
    end
    assign DATAread_out0 = SELECT_in[2]? ~readflag0:1'b0;
	
	//0_1000 stop,sleap conect to FIFO write enable
    assign  SLEAP_out = ((32'h0000_ffff & SELECT_in) == 32'h0000_0008)? 0:1;
    
    //1_0001 H TRG LEVEL data 1 resive from gpio
    always@(posedge sys_clk)begin
        if(SELECT_in[4])
            H_TRGLEVEL_data_1 <= SELECT_in[29:16];
        else
            H_TRGLEVEL_data_1 <= H_TRGLEVEL_data_1;
    end
	
	//1_0010 L TRG LEVEL data 1 resive from gpio
    always@(posedge sys_clk)begin
        if(SELECT_in[5])
            L_TRGLEVEL_data_1 <= SELECT_in[29:16];
        else
            L_TRGLEVEL_data_1 <= L_TRGLEVEL_data_1;
    end
    assign TRGLEVEL_1_out = {H_TRGLEVEL_data_1,L_TRGLEVEL_data_1};
	
	//1_0100 H TRG LEVEL data 2 resive from gpio
    always@(posedge sys_clk)begin
        if(SELECT_in[6])
            H_TRGLEVEL_data_2 <= SELECT_in[29:16];
        else
            H_TRGLEVEL_data_2 <= H_TRGLEVEL_data_2;
    end
	
	//1_1000 L TRG LEVEL data 2 resive from gpio
    always@(posedge sys_clk)begin
        if(SELECT_in[7])
            L_TRGLEVEL_data_2 <= SELECT_in[29:16];
        else
            L_TRGLEVEL_data_2 <= L_TRGLEVEL_data_1;
    end
    assign TRGLEVEL_2_out = {H_TRGLEVEL_data_2,L_TRGLEVEL_data_2};
    
	//2_0001 adc clk division set. conect to msmux_mod
	always@(posedge sys_clk)begin
		if(SELECT_in[8])begin
			ADC_clk_division_data <= SELECT_in[19:16];
			MCS_clk_division_data <= SELECT_in[23:20];
		end else begin
			ADC_clk_division_data <= ADC_clk_division_data;
			MCS_clk_division_data <= MCS_clk_division_data;
		end
	end
	assign ADC_clk_div = ADC_clk_division_data;
	assign MCS_clk_div = MCS_clk_division_data;
	
	//2_0010 tau & shaping div set. connect to shaping tau in & div in.
	always@(posedge sys_clk)begin
		if(SELECT_in[9])begin
			shape_confset <= SELECT_in[27:16];
		end else begin
			shape_confset <= shape_confset;
		end
	end
	assign shape_conf = shape_confset;
	
endmodule
