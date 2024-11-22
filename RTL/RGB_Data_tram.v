module	RGB_Data_tram#(
		parameter	T0H_Clock_Count = 15,
		parameter	T0L_Clock_Count = 40,
		parameter	T1H_Clock_Count = 40,
		parameter	T1L_Clock_Count = 15,
		parameter	RGB_RET_Clock_Count = 5
	)(
		input	Clock,
		input	cRst_n,
		input	cPluesEvery100us,
		input	cPluesEvery50ns,
		
		// input	[1:0] Status,
		input	Begin_Tran_Flag,
		input	RGB_Data_Rst_Req,
		output	OneBit_Tram_Ok,
		output	RGB_Data_Rst_Tram_Ok,
		
		input	DI,
		output	DO
		// output	reg	DO_tram_Ok,
		// output	reg	RET_Done
		
	);
//#########################################################################
// State Assignments
//#########################################################################
	localparam	NState		= 4;	
	localparam	START		= 4'b10_01;//0x09
	localparam	Bit_CHECK	= 4'b10_10;//0x0a
	localparam	END			= 4'b10_11;//0x0b
	localparam	T1H			= 4'b00_11;//0x03
	localparam	T1L			= 4'b00_10;//0x02
	localparam	T0H			= 4'b00_01;//0x01
	localparam	T0L			= 4'b00_00;//0x00
	localparam	RET			= 4'b01_00;//0x04
//#########################################################################
// Reg and wire
//#########################################################################
	wire					TimeClock;
	wire					TimeOutPlues;
	wire					Plues;
	reg						cTimeOutPlues;
	reg						TimeEN_DLY;
	reg						RGB_Data;
	reg						TimeEN;
	reg		[9:0]			TimeValue;
	reg		[NState-1:0]	Prev_State;
	reg		[NState-1:0]	Current_State;
	reg		[NState-1:0]	cNextState;
	
//#########################################################################
// assign Assignments
//#########################################################################
	
	assign	OneBit_Tram_Ok	=  ((Prev_State == T1L) & (Current_State == Bit_CHECK)|
								(Prev_State == T0L) & (Current_State == Bit_CHECK));
	assign	RGB_Data_Rst_Tram_Ok = (Prev_State == RET) & (Current_State == END);
	assign	RET_Statue	= (Current_State == RET);	
	assign	TimeClock 	= (RET_Statue)?cPluesEvery100us:cPluesEvery50ns;
	assign	DO			= RGB_Data;
	
	// wire	TD_Statue;
	// wire	RET_Statue;
	// wire	[9:0] TH_Clock_Count;
	// wire	[9:0] TL_Clock_Count;
	
	// reg		T_DO;  
	// reg		[1:0] T_Statue;
	// reg		[9:0] T_pulse_Count;
	// reg		[3:0] RET_pulse_Count;
	
	// assign	TH_Clock_Count = (Status[0])?T1H_Clock_Count:T0H_Clock_Count;
	// assign	TL_Clock_Count = (Status[0])?T1L_Clock_Count:T0L_Clock_Count;
	// assign	TD_Statue = ~Status[1];
	// assign	RET_Statue = Status[1];
	
	// assign	DO = (RET_Statue) ? 1'b0:T_DO;
//#########################################################################
//RGB Data output
//#########################################################################
	always@(*)begin
		RGB_Data = 1'b0;
		case(Current_State)	
			T1H:	RGB_Data	= 1'b1;
			T1L:	RGB_Data	= 1'b0;
			T0H:	RGB_Data	= 1'b1;
			T0L:	RGB_Data	= 1'b0;
			RET:	RGB_Data	= 1'b0;
			default:	RGB_Data	= RGB_Data;
		endcase	
	end	

//#########################################################################
//State Machine Control
//#########################################################################	

	always@(posedge	Clock or negedge cRst_n)begin
		if(~cRst_n)begin
			Current_State[NState-1:0]	<=	{NState{1'b0}};
			Current_State				<=	START;
		end
		else begin
			Current_State[NState-1:0]	<= 	cNextState[NState-1:0];
			Prev_State[NState-1:0]		<=	Current_State[NState-1:0];		
		end
	end
	
	always@(*)begin
		cNextState[NState-1:0]	= {NState{1'b0}};
		TimeEN               	= 1'b0;
		TimeValue             	= 10'd0;
		
		case(Current_State)
			START:begin
				if(Begin_Tran_Flag)begin
					cNextState = Bit_CHECK;
				end
				else begin
					cNextState = START;
				end
			end
			Bit_CHECK:begin
				if(RGB_Data_Rst_Req)begin
					cNextState = RET;
					TimeValue = RGB_RET_Clock_Count;
				end
				else if(DI)begin
					cNextState = T1H;
					TimeValue = T1H_Clock_Count;
				end
				else if(~DI)begin
					cNextState = T0H;
					TimeValue = T0H_Clock_Count;
				end
				else 
					cNextState = Bit_CHECK;
			end
			T1H:begin
				if(TimeOutPlues)begin
					cNextState	= T1L;
					TimeEN		= 1'b0;   
				end
				else begin
					cNextState 	= T1H;
					TimeEN		= 1'b1;   
				end
				TimeValue = T1L_Clock_Count;
			end
			T1L:begin
				if(TimeOutPlues)begin
					cNextState	= Bit_CHECK;
					TimeEN		= 1'b0; 
				end
				else begin
					cNextState 	= T1L;
					TimeEN		= 1'b1;   
				end
				// TimeValue = T1L_Clock_Count;
			end
			T0H:begin
				if(TimeOutPlues)begin
					cNextState	= T0L;
					TimeEN		= 1'b0;   
				end
				else begin
					cNextState 	= T0H;
					TimeEN		= 1'b1;   
				end
				TimeValue = T0L_Clock_Count;
			end
			T0L:begin
				if(TimeOutPlues)begin
					cNextState	= Bit_CHECK;
					TimeEN		= 1'b0;   
				end
				else begin
					cNextState 	= T0L;
					TimeEN		= 1'b1;   
				end
				// TimeValue = T0L_Clock_Count;
			end
			RET:begin
				if(TimeOutPlues)begin
					cNextState	= END;
					TimeEN		= 1'b0;   
				end
				else begin
					cNextState 	= RET;
					TimeEN		= 1'b1;   
				end
				// TimeValue = RGB_RET_Clock_Count;
			end
			END:begin
				if(~Begin_Tran_Flag)
					cNextState	= START;
				else
					cNextState	= END;
			end
			default:begin
				cNextState[NState-1:0]	= {NState{1'b0}};
				TimeEN               	= 1'b0;
				TimeValue             	= 10'd0;
			end
		endcase	
	end	
	
	
	TimePlues u_TimePlues(
		.Clock(Clock),
		.cRst_n(cRst_n),
		.CLK_Enable(TimeClock),
		.Reload(~TimeEN),
		.Value(TimeValue),
		.TimeOutPlues(Plues)
	);
	
	always@(posedge	Clock )begin
		TimeEN_DLY <= TimeEN;
	end
	
	// always@(posedge	Clock)begin
		// if(Current_State == Prev_State)
			// cTimeOutPlues <= TimeOutPlues;
	// end
	
	// assign	TimeOutPlues = Plues & TimeEN_DLY;
	assign	TimeOutPlues = Plues ;
	// always@(posedge Clock or negedge cRst_n)begin
		// if(~cRst_n)begin
			// T_pulse_Count 	<= {6{1'b0}};
			// T_Statue 		<= H;	
			// DO_tram_Ok		<= 1'b0;
		// end
		// else begin
			// if(TD_Statue) begin
				// case(T_Statue)
					// H:	begin
						// if(T_pulse_Count == TH_Clock_Count) begin
							// T_pulse_Count 	<= {6{1'b0}};
							// T_Statue 		<= L;
							// DO_tram_Ok		<= 1'b0;
						// end
						// else begin
							// T_pulse_Count 	<= T_pulse_Count + 1'b1;
							// T_Statue 		<= H;
							// DO_tram_Ok		<= 1'b0;
						// end
					// end
					// L: 	begin
						// if(T_pulse_Count == TL_Clock_Count) begin
							// T_pulse_Count 	<= {6{1'b0}};
							// T_Statue 		<= H;
							// DO_tram_Ok		<= 1'b1;
						// end
						// else begin
							// T_pulse_Count 	<= T_pulse_Count + 1'b1;
							// T_Statue 		<= L;
							// DO_tram_Ok		<= 1'b0;
						// end
					// end
					// default: begin
						// T_pulse_Count	<= T_pulse_Count;
						// T_Statue 		<= T_Statue;
						// DO_tram_Ok		<= DO_tram_Ok;
					// end
				// endcase
			// end
			// else begin
				// T_pulse_Count	<= T_pulse_Count;
				// T_Statue 		<= T_Statue;
				// DO_tram_Ok		<= 1'b0;
			// end
			
			// T_DO <= T_Statue;
		// end
	// end	
	
	// always@(posedge Clock or negedge cRst_n)begin
		// if(~cRst_n)begin
			// RET_pulse_Count <= {4{1'b0}};
		// end
		// else begin
			// if(RET_Statue & cPluesEvery100us)begin
				// if(RET_pulse_Count == RGB_RET_Clock_Count)
					// RET_pulse_Count <= {4{1'b0}};
				// else	
					// RET_pulse_Count <= RET_pulse_Count + 1'b1;
			// end
			// else begin
				
			// end
		// end
	// end
	// always@(posedge Clock or negedge cRst_n)begin
		// if(~cRst_n)begin
			// RET_Done <= 1'b0;
		// end
		// else begin
			// if(RET_Statue)begin
				// if(RET_pulse_Count == RGB_RET_Clock_Count)
					// RET_Done	<= 1'b1;
				// else	
					// RET_Done	<= 1'b0;
			// end
			// else begin
				
			// end
		// end
	// end
endmodule		