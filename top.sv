module top(
	  ///// 8x8 LED Screen /////
	  output[0:7] DATA_R, DATA_G, DATA_B,
	  output[2:0] S,
	  output      En,
	  
	  
	  
	  ///// check for score or timer //////
	  output[7:0] seg,
	  output[3:0] com,
	  
	  ///// CLK /////
	  input clk,
	  
	  // /// User Control /////
	  input down, left, right, rotate, 
	  input restart, 
	  
	  ///// music ///////
	  output  wire  beep
);

		logic[0:7] data_r[7:0], data_g[7:0], data_b[7:0];
		logic[0:7] data[7:0];
		logic[3:0] com_timer;
		logic[7:0] seg_timer;
		logic[3:0] com_score;
		logic[7:0] seg_score;
		
		parameter bit[0:7] NEW_GAME[8] = 
					   '{8'b11111111,
						 8'b11111111,
						 8'b11111111,
						 8'b11111111,
						 8'b11111111,
						 8'b11111111,
						 8'b11111111,
						 8'b11111111};

		initial 
		begin
			DATA_R = 8'b11111111;
			DATA_G = 8'b11111111;
			//DATA_B = 8'b11111111;
			data_r = NEW_GAME;
			data_g = NEW_GAME;
			data_b = NEW_GAME;
			En = 1;
			S = 0;
		end

		divfreq1000HZ HZ_1000(clk, clk_1000);
		divfreq6HZ    HZ_6(clk, clk_6);
		divfreq1HZ    HZ_1(clk, clk_1);


		game Tetris(
		  .data_out(data),
		  .com_score(com_score),
		  .seg_score(seg_score),
		  .clk_1000(clk_1000),
		  .clk_6(clk_6),
		  .restart(restart), 
		  .op( { ~down, ~left, right, rotate} )
		 );
		 

		timer GAME_TIMER(
		  .com(com_timer),
		  .seg(seg_timer),
		  .clk_1HZ(clk_1),
		  .clk_1000HZ(clk_1000),
		  .reset(restart)
		);


		music GAME_MUSIC(
			.clk(clk),
			.rst(!restart),
			.buzz(beep)
		);
		
		//always	@(posedge clk_1000)
		//begin
		//	S = (S + 1) % 8;
		//	for(int i = 0; i < 8; i++)
		//	begin
		//		case(data[S][i])
		//			1	:	data_r[S][i] = 0;
		//			2	:	data_b[S][i] = 0;
		//			3	:	begin data_r[S][i] = 0; data_g[S][i] = 0; data_b[S][i] = 0; end
		//			4	:	begin data_r[S][i] = 0; data_g[S][i] = 0; end
		//			5	:	begin data_r[S][i] = 0; data_b[S][i] = 0; end
		//			6	:	begin data_g[S][i] = 0; data_b[S][i] = 0; end
		//			7	:	data_g[S][i] = 0;
		//		endcase
		//	end
		//	DATA_R = data_r[S];
		//	DATA_G = data_g[S];
		//	DATA_B = data_b[S];
		//end
		
		always	@( posedge clk_1000 ) 
		begin
		  S = (S + 1) % 8;
		  DATA_B = data[S];
		  seg = seg_score;
		  com = com_score;
		end

endmodule
