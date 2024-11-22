`timescale 1ns / 1ps
module	RGB_Ex_Top_TB();
	
	reg		Clock;
	reg		cRst_n;
	wire	OB_LED_RGB_D;
	
	initial begin
		Clock 	= 1'b0;
		cRst_n 	= 1'b1;
		#10
		cRst_n 	= 1'b0;
	end

	always #10 Clock = ~Clock;	
	
	RGB_Ex_Top u_RGB_Ex_Top(
		.MAX10_CLK1_50(Clock),
		.KEY({1'b1,cRst_n}),
		.OB_LED_RGB_D(OB_LED_RGB_D)
	);
endmodule