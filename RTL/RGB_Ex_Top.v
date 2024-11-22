`timescale 1ns / 1ps
module	RGB_Ex_Top(
		input	MAX10_CLK1_50,
		input	[1:0]	KEY,
		output	[3:0]	LED,
		output	[7:0]	TMD_D,
		output	OB_LED_RGB_D	
	);
	
	localparam	T0H_Clock_Count = 7;  // 50nS * 7   = 350nS
	localparam	T0L_Clock_Count = 18; // 50nS * 18  = 900nS	
	localparam	T1H_Clock_Count = 18; // 50nS * 18  = 900nS
	localparam	T1L_Clock_Count = 7;  // 50nS * 7   = 350nS	
	localparam	RGB_RET_Clock_Count = 4; // 100u * 5 = 500uS
	localparam	RGB_DATA_SIZE	= 24;
	localparam	SINGAL_COLOUY_DATA_SIZE	= 8;
	localparam	WS2812B_NUM	= 3;
	localparam	TOTAL_DATA_SIZE = RGB_DATA_SIZE*WS2812B_NUM;

	
	reg		[RGB_DATA_SIZE - 1 : 0]	RGB_Data_1;
	reg		[RGB_DATA_SIZE - 1 : 0]	RGB_Data_2;
	reg		[RGB_DATA_SIZE - 1 : 0]	RGB_Data_3;
	reg		[TOTAL_DATA_SIZE - 1 : 0]	buff_RGB_Data;
	wire	[TOTAL_DATA_SIZE - 1 : 0]	Total_RGB_Data;
	
	reg		[SINGAL_COLOUY_DATA_SIZE - 1 : 0] G_Data = {SINGAL_COLOUY_DATA_SIZE{1'b1}};
	reg		[SINGAL_COLOUY_DATA_SIZE - 1 : 0] R_Data = {SINGAL_COLOUY_DATA_SIZE{1'b0}};
	reg		[SINGAL_COLOUY_DATA_SIZE - 1 : 0] B_Data = {SINGAL_COLOUY_DATA_SIZE{1'b0}};
	reg		[6:0] Array_Count;
	
	reg		clk_dly;
	reg		LEDStauts = 1'b0;
	reg		[3:0]	led_db;
	
	wire	Clock;
	wire	cRst_n;
	wire	cPluesEvery100us;
	wire	cPluesEvery50ns;
	wire	clkout_40MHz;
	wire	clk_1Hz;
	wire	clk_plus;
	
	// wire	Init_Tran_Flag;
	reg		Begin_Tran_Flag;
	wire	RGB_Data_Rst_Req;
	wire	OneBit_Tram_Ok;
	wire	RGB_Data_Rst_Tram_Ok;
	
	wire	shift_Data;
	
		
	assign	Clock 	= MAX10_CLK1_50;
	assign	cRst_n 	= KEY[0];
	assign	TMD_D[0] = clkout_20MHz;
	assign	LED = led_db;
	
	always@(posedge Clock or negedge cRst_n)begin
		if(~cRst_n)begin
			RGB_Data_1 <= {RGB_DATA_SIZE{1'b0}}; 
		end
		else begin
			RGB_Data_1 <= {G_Data,R_Data,B_Data};
		end
	end
	always@(posedge Clock or negedge cRst_n)begin
		if(~cRst_n)begin
			RGB_Data_2 <= {RGB_DATA_SIZE{1'b0}}; 
		end
		else begin
			RGB_Data_2 <= {G_Data,R_Data,B_Data};
		end
	end
	always@(posedge Clock or negedge cRst_n)begin
		if(~cRst_n)begin
			RGB_Data_3 <= {RGB_DATA_SIZE{1'b0}}; 
		end
		else begin
			RGB_Data_3 <= {G_Data,R_Data,B_Data};
		end
	end
	
	assign	Total_RGB_Data = {RGB_Data_1,RGB_Data_2,RGB_Data_3};
	
	always@(posedge Clock or negedge cRst_n)begin
		if(~cRst_n)begin 
			Begin_Tran_Flag	<= 1'b0; 
		end
		else begin
			if(RGB_Data_Rst_Tram_Ok)
				Begin_Tran_Flag <= 1'b0;
			else
				Begin_Tran_Flag	<= 1'b1;
		end
	end
	
	always@(posedge Clock or negedge cRst_n)begin
		if(~cRst_n)begin 
			buff_RGB_Data	<= {TOTAL_DATA_SIZE{1'b0}}; 
			Array_Count		<=	TOTAL_DATA_SIZE-1;
		end
		else begin
			if(Begin_Tran_Flag)begin
				if(OneBit_Tram_Ok)begin
					buff_RGB_Data[TOTAL_DATA_SIZE-1:0] <= buff_RGB_Data[TOTAL_DATA_SIZE-1:0] << 1;
					Array_Count	<= Array_Count - 1'b1;
				end
				else if (RGB_Data_Rst_Tram_Ok)begin
					buff_RGB_Data[TOTAL_DATA_SIZE-1:0] <= Total_RGB_Data[TOTAL_DATA_SIZE-1:0];
					Array_Count	<= TOTAL_DATA_SIZE-1;
				end	
				else begin
					buff_RGB_Data[TOTAL_DATA_SIZE-1:0] <= buff_RGB_Data[TOTAL_DATA_SIZE-1:0];
					Array_Count	<= Array_Count;
				end
			end
			else begin
				buff_RGB_Data[TOTAL_DATA_SIZE-1:0] <= Total_RGB_Data[TOTAL_DATA_SIZE-1:0];
				Array_Count		<=	TOTAL_DATA_SIZE-1;
			end
		end
	end
	
	// assign	buff_Data = RGB_Data_1[array];
	// assign	Begin_Tran_Flag = |{RGB_Data_1};
	assign	shift_Data = buff_RGB_Data[TOTAL_DATA_SIZE-1];
	assign	RGB_Data_Rst_Req = (Array_Count == 0) ? 1'b1 : 1'b0;
	
	RGB_Data_tram#(
		.T0H_Clock_Count(T0H_Clock_Count),
		.T0L_Clock_Count(T0L_Clock_Count),
		.T1H_Clock_Count(T1H_Clock_Count),
		.T1L_Clock_Count(T1L_Clock_Count),
		.RGB_RET_Clock_Count(RGB_RET_Clock_Count)
	)u_RGB_Data_tram(
		.Clock(Clock),
		.cRst_n(cRst_n),
		.cPluesEvery100us(cPluesEvery100us),
		.cPluesEvery50ns(clkout_40MHz),
		
		.Begin_Tran_Flag(Begin_Tran_Flag),
		.RGB_Data_Rst_Req(RGB_Data_Rst_Req),
		.OneBit_Tram_Ok(OneBit_Tram_Ok),
		.RGB_Data_Rst_Tram_Ok(RGB_Data_Rst_Tram_Ok),
		.DI(shift_Data),
		.DO(OB_LED_RGB_D)
	);

	
	Divider_Clock#(
		.Custom_Outputclk_0(10_000),	//10KHz
		.Custom_Outputclk_1(20_000_000)	//20MKz
	)u_Divider_Clock(
		.clkin(Clock),
		.rst_n(cRst_n),
		.clkout_Custom_0(),
		.cPlusEveryCustom0(cPluesEvery100us),
		.cPlusEveryCustom1(),
		.clkout_1K(),	
		.clkout_100(),
		.clkout_10(),
		.clkout_1(clk_1Hz)
	);
	
	Pll_40MHz u_Pll_40MHz(
		.inclk0(Clock),
		.c0(clkout_40MHz)
	);

	reg		clk20M_dly;
	wire	clkout_20MHz;
	
	always@(posedge Clock)begin
		clk20M_dly <= clkout_20MHz;
	end
	
	assign	cPluesEvery50ns = clk20M_dly ^ clkout_20MHz;
	
	assign	clk_plus = clk_1Hz ^ clk_dly;
	always@(posedge Clock)begin
		clk_dly <= clk_1Hz;
	end
	
	always@(posedge Clock)begin
		if(~cRst_n)
			LEDStauts <= 1'b0;
		if(clk_plus)begin
			LEDStauts	<= ~LEDStauts;
		end
	end
	always@(*)begin
		case(LEDStauts)
			1'd0:
				led_db = 4'b1001;
			1'd1:
				led_db = 4'b0110;
			default:
				led_db = led_db;
		endcase
	end
	
	Dual_Config	u_Dual_Config(
		.clk_clk		(Clock),
		.reset_reset_n	(1'b1)
	);
	
endmodule