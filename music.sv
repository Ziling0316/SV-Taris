module music(

			input  wire    clk,
			input  wire    rst,
			
			output wire    buzz
);

			wire	 [5:0]   cnt;
			wire   [4:0]   music;
			wire   [31:0]  divnum;
			
			//divfreq6HZ F0(clk, clk_div);
			
	speed_control speed_control_tool(
				.clk		(clk),
				.rst     (rst),
				
				.cnt     (cnt)
	);

	music_mem music_mem_tool(
				.clk		(clk),
				.rst     (rst),
				.cnt     (cnt),
				
				.music   (music)
	);
	cal_divnum cal_divnum_tool(
				.clk		(clk),
				.rst     (rst),
				.music   (music),
				
				.divnum  (divnum)
	);
	wave_gen wave_gen_tool(
				.clk		(clk),
				.rst     (rst),
				.divnum  (divnum),
				
				.buzz		(buzz)
	);
	
endmodule

module speed_control(
		input   wire         clk,
		input   wire         rst, 
		
		output  reg  [5:0]   cnt
);

		parameter  T_250ms = 12_500_000;
		
		reg    [25:0]   count;
		wire            flag_250ms; 
		
		always	@(posedge clk, negedge rst)	begin
			if(!rst)
				count <= 26'd0;
			else	begin
				if(count >= T_250ms - 1'b1)
					count <= 26'd0;
				else
					count <= count + 1'b1;
			end
		end
		
		assign flag_250ms = (count == T_250ms - 1'b1) ? 1'b1 : 1'b0;
		
		always	@(posedge clk, negedge rst)	begin
			if(!rst)
				cnt <= 6'd0;
			else	begin
				if(flag_250ms)
					cnt <= cnt + 1'b1;
				else
					cnt <= cnt;
			end
		end
endmodule

module music_mem(
		input   wire         clk,
		input   wire         rst, 
		input   reg  [5:0]   cnt,
		
		output  reg  [4:0]   music
);
		
		always	@(posedge clk, negedge rst)	begin
			if(!rst)
				music <= 5'd0;
			else	
				case (cnt)
				  6'd0    :   music <= 5'd17;
				  6'd1    :   music <= 5'd17;
				  6'd2    :   music <= 5'd14;
				  6'd3    :   music <= 5'd15;
				  6'd4    :   music <= 5'd16;
				  6'd5    :   music <= 5'd17;
				  6'd6    :   music <= 5'd15;
				  6'd7    :   music <= 5'd14;
				  
				  6'd8    :   music <= 5'd13;
				  6'd9    :   music <= 5'd13;
				  6'd10   :   music <= 5'd13;
				  6'd11   :   music <= 5'd15;
				  6'd12   :   music <= 5'd17;
				  6'd13   :   music <= 5'd17;
				  6'd14   :   music <= 5'd16;
				  6'd15   :   music <= 5'd15;
				  
				  6'd16   :   music <= 5'd14;
				  6'd17   :   music <= 5'd14;
				  6'd18   :   music <= 5'd14;
				  6'd19   :   music <= 5'd15;
				  6'd20   :   music <= 5'd16;
				  6'd21   :   music <= 5'd16;
				  6'd22   :   music <= 5'd17;
				  6'd23   :   music <= 5'd17;
				  
				  6'd24   :   music <= 5'd15;
				  6'd25   :   music <= 5'd15;
				  6'd26   :   music <= 5'd13;
				  6'd27   :   music <= 5'd13;
				  6'd28   :   music <= 5'd13;
				  6'd29   :   music <= 5'd13;
				  6'd30   :   music <= 5'd0;
				  6'd31   :   music <= 5'd0;
				  
				  6'd32   :   music <= 5'd16;
				  6'd33   :   music <= 5'd16;
				  6'd34   :   music <= 5'd16;
				  6'd35   :   music <= 5'd18;
				  6'd36   :   music <= 5'd20;
				  6'd37   :   music <= 5'd20;
				  6'd38   :   music <= 5'd19;
				  6'd39   :   music <= 5'd18;
				  
				  6'd40   :   music <= 5'd17;
				  6'd41   :   music <= 5'd17;
				  6'd42   :   music <= 5'd17;
				  6'd43   :   music <= 5'd15;
				  6'd44   :   music <= 5'd17;
				  6'd45   :   music <= 5'd17;
				  6'd46   :   music <= 5'd16;
				  6'd47   :   music <= 5'd15;
				  
				  6'd48   :   music <= 5'd14;
				  6'd49   :   music <= 5'd14;
				  6'd50   :   music <= 5'd14;
				  6'd51   :   music <= 5'd15;
				  6'd52   :   music <= 5'd16;
				  6'd53   :   music <= 5'd16;
				  6'd54   :   music <= 5'd17;
				  6'd55   :   music <= 5'd17;
				  
				  6'd56   :   music <= 5'd15;
				  6'd57   :   music <= 5'd15;
				  6'd58   :   music <= 5'd13;
				  6'd59   :   music <= 5'd13;
				  6'd60   :   music <= 5'd13;
				  6'd61   :   music <= 5'd13;
				  6'd62   :   music <= 5'd0;
				  6'd63   :   music <= 5'd0;
				  default  :   music <= 5'd0;
				endcase
			end
endmodule

module cal_divnum(
		input   wire         clk,
		input   wire         rst, 
		input   wire  [4:0]  music,

		output  reg   [31:0] divnum
	
);

		reg           [31:0] freq;
		
		always	@(*)	begin
			case (music)
				5'd1    : freq =    32'd262;
				5'd2    : freq =    32'd294;
				5'd3    : freq =    32'd330;
				5'd4    : freq =    32'd349;
				5'd5    : freq =    32'd392;
				5'd6    : freq =    32'd440;
				5'd7    : freq =    32'd494;
				
				5'd8    : freq =    32'd523;
				5'd9    : freq =    32'd587;
				5'd10   : freq =    32'd659;
				5'd11   : freq =    32'd699;
				5'd12   : freq =    32'd784;
				5'd13   : freq =    32'd880;
				5'd14   : freq =    32'd988;
				
				5'd15   : freq =    32'd1050;
				5'd16   : freq =    32'd1175;
				5'd17   : freq =    32'd1319;
				5'd18   : freq =    32'd1397;
				5'd19   : freq =    32'd1568;
				5'd20   : freq =    32'd1760;
				5'd21   : freq =    32'd1976;
				default : freq =    32'd1;
			 endcase
			end
			
			always	@(posedge clk, negedge rst)	begin
				if (!rst)
					divnum <= 32'd50_000_000;
				 else
					divnum <= 50_000_000/freq;
			  end
endmodule

module wave_gen(
		input   wire         clk,
		input   wire         rst,
		input   reg   [31:0] divnum,
		
		output  reg          buzz
);
		reg           [31:0]    cnt;
  
		always	@(posedge clk, negedge rst)	begin
			if (!rst)
				cnt <= 32'd0;
		 else
			if (cnt >= divnum - 1'b1)
			  cnt <= 32'd0;
			else
			  cnt <= cnt + 1'b1;
		end
  
	   always @ (posedge clk, negedge rst) begin
			if (!rst)
				buzz <= 1'b0;
			else
				if (cnt < divnum[31:1])
					buzz <= 1'b0;
				else
					buzz <= 1'b1;
	  end
		
endmodule



