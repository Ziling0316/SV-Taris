enum { RED, GREEN, BLUE } colors;

module Color(
  output reg [7:0] Data_R, Data_G, Data_B,
  output reg [2:0] COMM,
  output E,
  input  restart,
  input  CLK
 );
				 
  bit   [0:7] Screen[8];
  logic [0:7] data_out[8];
  int color;
 
 parameter bit [7:0] New_screen[8] = 
'{8'b11111111,
  8'b11111111,
  8'b11111111,
  8'b11111111,
  8'b11111111,
  8'b11111111,
  8'b11111111,
  8'b11111111};
 
 parameter logic[7:0] heart[8] = 
'{8'b10011001,
  8'b01100110,
  8'b01111110,
  8'b01111110,
  8'b10111101,
  8'b11011011,
  8'b11100111,
  8'b11111111};
 
 divfreq1000HZ F0(CLK, CLK_div);
 
 initial
begin
Screen = New_screen;
COMM = 0;
Data_R = 8'b11111111;
Data_G = 8'b11111111;
Data_B = 8'b11111111;
E = 1;
end

  always @(posedge CLK_div) begin
    COMM = (COMM+1)%8;
	 data2out(heart, Screen);
	 if(restart) begin
	   color = (color + 1) % 3;
	   Data_R = 8'b11111111;
      Data_G = 8'b11111111;
      Data_B = 8'b11111111;
	 end
	 
	 case(color)
      RED: Data_R = Screen[COMM];
		GREEN: Data_G = Screen[COMM];
		BLUE: Data_B = Screen[COMM];
	 endcase
  end
endmodule

module divfreq1000HZ(input CLK, output reg CLK_div);
  reg [24:0] Count;
  always @(posedge CLK) begin
    if(Count > 25123) begin
      Count <= 25'b0;
      CLK_div <= ~CLK_div;
    end else Count <= Count + 1'b1;
  end
endmodule

task automatic data2out(
  input  bit  [0:7] data_in [7:0],
  output logic[0:7] data_out[7:0]
);

  for( int i=0; i < 8; ++i ) begin
    data_out[i] <= {data_in[0][i],data_in[1][i],data_in[2][i],data_in[3][i],
                    data_in[4][i],data_in[5][i],data_in[6][i],data_in[7][i],};
  end

endtask
