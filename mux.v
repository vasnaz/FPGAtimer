`timescale 1ns / 1ps

module muxer(
    input clock,
    input reset,
    input [15:0] fifth,
    input [15:0] fourth,
    input [15:0] third,
    input [15:0] second,
    input [15:0] first,
    output a_m,
    output b_m,
    output c_m,
    output d_m,
    output e_m,
    output f_m,
    output g_m,
    output dp_m,
    output [7:0] an_m
    );
 
//The Circuit for 7 Segment Multiplexing - 
 
localparam N = 18; 
 
reg [N-1:0]count; //the 18 bit counter which allows us to multiplex at 1000Hz
 
always @ (posedge clock or posedge reset)
 begin
  if (reset)
   count <= 0;
  else
   count <= count + 1;
 end
 
reg [15:0]sseg; //the 4 bit register to hold the data that is to be output
reg [7:0]an_temp; //register for the 4 bit enable
reg reg_dp;
always @ (*)
 begin
  case(count[N-1:N-2]) //MSB and MSB-1 for multiplexing
    
  3'b000 :
  begin
  sseg = first; //this outputs 1st letter
  an_temp = 8'b01111111;
  end
  3'b001 :
  begin
  sseg = second; //this outputs 2nd letter
  an_temp = 8'b10111111;
  end
  3'b010 :
  begin
  sseg = third; //this outputs 3rd letter
  an_temp = 8'b11011111;
  end
  3'b011 :
  begin
  sseg = fourth; //this outputs 4th letter
  an_temp = 8'b11101111;
  end
  3'b100 :
  begin
  sseg = fifth; //this outputs 5th letter
  an_temp = 8'b11110111;
  end
  3'b101 :
  begin
  sseg = fifth; //this outputs no value
  an_temp = 8'b11111111;
  end
  3'b110 :
  begin
  sseg = fifth; //this outputs no value
  an_temp = 8'b11111111;
  end
  3'b111 :
  begin
  sseg = fifth; //this outputs no value
  an_temp = 8'b11111111;
  end
    
  
  
     
  endcase
 end
 
 
 
assign an_m = an_temp;
 
reg [6:0] sseg_temp; 
always @ (*)
 begin
  case(sseg)
            16'b0000000000000000 : sseg_temp = 7'h00; //clear
            16'b0000000000101110 : sseg_temp = 7'h08; //a
            16'b0000001110101010 : sseg_temp = 7'h60; //b
            16'b0000111010111010 : sseg_temp = 7'h31; //c
            16'b0000000011101010 : sseg_temp = 7'h42; //d
            16'b0000000000000010 : sseg_temp = 7'h30; //e
            16'b0000001010111010 : sseg_temp = 7'h38; //f
            16'b0000001110111010 : sseg_temp = 7'h04; //g
            16'b0000000010101010 : sseg_temp = 7'h48; //h
            16'b0000000000001010 : sseg_temp = 7'h79; //i
            16'b0010111011101110 : sseg_temp = 7'h47; //j
            //16'b0000001110101110 : sseg_temp; = 7'h1C; //k
            16'b0000001011101010 : sseg_temp = 7'h71; //l
            //16'b0000000011101110 : sseg_temp; = 7'h01; //m
            16'b0000000000111010 : sseg_temp = 7'h6A; //n
            16'b0000111011101110 : sseg_temp = 7'h62; //o
            16'b0000001011101110 : sseg_temp = 7'h18; //p
            //16'b0011101110101110 : sseg_temp; = 7'h0C; //q
            16'b0000000010111010 : sseg_temp = 7'h7A; //r
            16'b0000000000101010 : sseg_temp = 7'h24; //s
            16'b0000000000001110 : sseg_temp = 7'h70; //t
            16'b0000000010101110 : sseg_temp = 7'h41; //u
            //16'b0000001010101110 : sseg_temp; = 7'h01; //v
            //16'b0000001011101110 : sseg_temp; = 7'h01; //w
            //16'b0000111010101110 : sseg_temp; = 7'h01; //x
            16'b0011101011101110 : sseg_temp = 7'h44; //y
            //16'b0000111011101010 : sseg_temp; = 7'h01; //z
   default : sseg_temp = 7'b1111111; //nothing
  endcase
 end
assign {g_m, f_m, e_m, d_m, c_m, b_m, a_m} = sseg_temp; 
assign dp_m = reg_dp;
 
endmodule