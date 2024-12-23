`timescale 1ns / 1ps
module Divider_Clock #(
		parameter	Custom_Outputclk_0 = 10'b1,
		parameter	Custom_Outputclk_1 = 10'b1, 
		parameter	Custom_Outputclk_2 = 10'b1 
	)(
		input	clkin,
		input	rst_n,
			
		output	cPlusEvery1mS,	
		output	cPlusEvery10mS,	
		output	cPlusEvery100mS,
		output	cPlusEvery1S,
		output	cPlusEveryCustom0,
		output	cPlusEveryCustom1,
		output	cPlusEveryCustom2,
				
		output  reg clkout_1K,
		output  reg clkout_100,
		output  reg clkout_10,
		output  reg clkout_1,
		output	reg	clkout_Custom_0,
		output	reg	clkout_Custom_1,
		output	reg	clkout_Custom_2
	);
	
	function integer clogb2(input integer bit_Depth);
		begin
		for(clogb2 = 0; bit_Depth > 0 ; clogb2 = clogb2 + 1)
			bit_Depth = bit_Depth >> 1;
		end
	endfunction
	
	parameter Orianal_Clock = 50_000_000;
	
	parameter Divider_Counter_1K = 50_000;
	parameter Divider_Counter_100 = 500_000;
	parameter Divider_Counter_10 = 5_000_000;
	parameter Divider_Counter_1 = 50_000_000;
	
	localparam integer Divider_Counter_C_0 = Orianal_Clock / Custom_Outputclk_0;
	localparam integer Count_Bits_0 = clogb2(Divider_Counter_C_0 - 1);
	
	localparam integer Divider_Counter_C_1 = Orianal_Clock / Custom_Outputclk_1;
	localparam integer Count_Bits_1 = clogb2(Divider_Counter_C_1 - 1);
	
	localparam integer Divider_Counter_C_2 = Orianal_Clock / Custom_Outputclk_2;
	localparam integer Count_Bits_2 = clogb2(Divider_Counter_C_2 - 1);
	
	reg [15:0] Counter_1k = 0;
	reg [18:0] Counter_100 = 0;
	reg [24:0] Counter_10 = 0;
	reg [26:0] Counter_1 = 0;
	reg	[Count_Bits_0 - 1 : 0]	Counter_C_0 = 0;	
	reg	[Count_Bits_1 - 1 : 0]	Counter_C_1 = 0;
	reg	[Count_Bits_2 - 1 : 0]	Counter_C_2 = 0;
	reg	clkout_1K_Dly;
	reg	clkout_100_Dly;
	reg	clkout_10_Dly;
	reg	clkout_1_Dly;
	reg	clkout_Custom_0_Dly;
	reg	clkout_Custom_1_Dly;
	reg	clkout_Custom_2_Dly;
	
	assign	cPlusEvery1mS		= ~clkout_1K_Dly & clkout_1K; 		
	assign	cPlusEvery10mS		= ~clkout_100_Dly & clkout_100;
	assign	cPlusEvery100mS		= ~clkout_10_Dly & clkout_10; 
	assign	cPlusEvery1S		= ~clkout_1_Dly & clkout_1;	
	assign	cPlusEveryCustom0	= ~clkout_Custom_0_Dly & clkout_Custom_0;
	assign	cPlusEveryCustom1	= ~clkout_Custom_1_Dly & clkout_Custom_1;
	assign	cPlusEveryCustom2	= ~clkout_Custom_2_Dly & clkout_Custom_2;
	
	always@(posedge clkin or negedge rst_n)begin
		if(!rst_n) begin
			Counter_1k <= 0;
			Counter_100 <= 0;
			Counter_10 <= 0;
			Counter_1 <= 0;
		end else begin
			//1KHz
			if(Counter_1k == (Divider_Counter_1K - 1))
				Counter_1k <= 0;
			else
				Counter_1k = Counter_1k + 1;
			//100Hz	
			if(Counter_100 == (Divider_Counter_100 - 1))
				Counter_100 <= 0;
			else
				Counter_100 <= Counter_100 + 1;
			//10Hz	
			if(Counter_10 == (Divider_Counter_10 - 1))
				Counter_10 <= 0;
			else
				Counter_10 <= Counter_10 + 1;
			//1Hz	
			if(Counter_1 == (Divider_Counter_1 - 1))
				Counter_1 <= 0;
			else
				Counter_1 <= Counter_1 + 1;
		end	
	end
	
	always@(posedge clkin or negedge rst_n)begin
		if(!rst_n) begin
			Counter_C_0 <= 0;
			Counter_C_1 <= 0;
			Counter_C_2 <= 0;
		end else begin
			//Custom_0 
			if(Divider_Counter_C_0 != Orianal_Clock)begin
				if(Counter_C_0 == (Divider_Counter_C_0 - 1))
					Counter_C_0 <= 0;
				else
					Counter_C_0 <= Counter_C_0 + 1;
			end
			//Custom_1 
			if(Divider_Counter_C_1 != Orianal_Clock)begin
				if(Counter_C_1 == (Divider_Counter_C_1 - 1))
					Counter_C_1 <= 0;
				else
					Counter_C_1 <= Counter_C_1 + 1;
			end
			//Custom_2 
			if(Divider_Counter_C_2 != Orianal_Clock)begin
				if(Counter_C_2 == (Divider_Counter_C_2 - 1))
					Counter_C_2 <= 0;
				else
					Counter_C_2 <= Counter_C_2 + 1;
			end
				
		end	
	end
	
	always@(posedge clkin or negedge rst_n) begin
		if(!rst_n) begin
			clkout_1K <= 0;
			clkout_100 <= 0;
			clkout_10 <= 0;
			clkout_1 <= 0;
			clkout_Custom_0 <= 0;
			clkout_Custom_1 <= 0;
			clkout_Custom_2 <= 0;
		end else begin
			//1KHz
			if(Counter_1k < Divider_Counter_1K>>1)// div 2
				clkout_1K <= 1'b0;
			else             
				clkout_1K <= 1'b1;
			//100Hz	
			if(Counter_100 < Divider_Counter_100>>1)
				clkout_100 <= 1'b0;
			else              
				clkout_100 <= 1'b1;	
			//10Hz	
			if(Counter_10 < Divider_Counter_10>>1)
				clkout_10 <= 1'b0;
			else             
				clkout_10 <= 1'b1;	
			//1Hz
			if(Counter_1 < Divider_Counter_1>>1)
				clkout_1 <= 1'b0;
			else            
				clkout_1 <= 1'b1;	
			//Custom_0
			if(Counter_C_0 < Divider_Counter_C_0>>1)
				clkout_Custom_0 <= 1'b0;
			else                   
				clkout_Custom_0 <= 1'b1;	
			//Custom_0	
			if(Counter_C_1 < Divider_Counter_C_1>>1)
				clkout_Custom_1 <= 1'b0;
			else                   
				clkout_Custom_1 <= 1'b1;	
			//Custom_0
			if(Counter_C_2 < Divider_Counter_C_2>>1)
				clkout_Custom_2 <= 1'b0;
			else                   
				clkout_Custom_2 <= 1'b1;	
		end	
	end
	
	always@(posedge clkin or negedge rst_n)begin
		if(!rst_n) begin
			clkout_1K_Dly 		<= 1'b0;
			clkout_100_Dly 		<= 1'b0;
			clkout_10_Dly 		<= 1'b0;
			clkout_1_Dly 		<= 1'b0;
			clkout_Custom_0_Dly <= 1'b0;
			clkout_Custom_1_Dly <= 1'b0;
			clkout_Custom_2_Dly <= 1'b0;
		end
		else begin
			clkout_1K_Dly <= clkout_1K;
			clkout_100_Dly <= clkout_100;
			clkout_10_Dly <= clkout_10;
			clkout_1_Dly <= clkout_1;
			clkout_Custom_0_Dly <= clkout_Custom_0;
			clkout_Custom_1_Dly <= clkout_Custom_1;
			clkout_Custom_2_Dly <= clkout_Custom_2;
		end
	end
	
endmodule