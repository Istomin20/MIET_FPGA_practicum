`timescale 1ns / 1ps

module counter(
  input        clk100_i,
  input        rstn_i,
  input  [10:0] sw_i,
  input  [1:0] key_i,
  output [9:0] ledr_o,
  output [6:0] hex0_o,
  output [6:0] hex1_o);
    
reg  [9:0] Q;
reg  [7:0] counter;

wire bwp;

key_deb bt(
  .btn_i      ( !key_i[0] ),
  .rst_i      ( key_i[1]  ),
  .btn_down_o ( bwp       ),
  .clk_i      ( clk100_i  )
);

always @( posedge clk100_i or negedge key_i[1] ) begin
  if  ( !key_i[1] ) begin
    Q       <= 10'b0;
    counter <= 8'd0;
  end
  else begin
    if ( bwp ) begin       
      Q       <= sw_i & ( sw_i - 1 );
      if ( sw_i[10] )
        counter <= counter + 1;
      else
        counter <= counter - 1;
      end  
    end
  end  

assign ledr_o = Q;

dc_hex dec0(
  .in(counter[3:0]),
  .out(hex0_o     ));
 
dc_hex dec1
( .in(counter[7:4]),
  .out(hex1_o     ));
 
endmodule

