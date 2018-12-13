`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2018 05:23:11 PM
// Design Name: 
// Module Name: segment
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module segment(
    output [6:0] fout,
    output [7:0] an,
    input clk,
    input reset,
    input upordown
    );
    
    reg [6:0] fout;
    reg [7:0] an;
    reg [3:0] ones; 
    reg [3:0] tens; 
    reg [32:0] timer; 
    
    reg newclk;

always @ (*)
begin
	if (timer == 32'd25000000)
	begin
		newclk <= 1;
		timer <= 0;
	
	end
	else
	begin
		timer <= timer+1;
		newclk <= 0;
	end
end

    
    
    always @(posedge newclk or posedge reset)
    begin
    
        if (reset)
        begin
            ones <= 0;
            tens <= 0;
        end
        else if (upordown == 1)
        begin
            if (ones == 4'b1001) //clear after 9
            begin
                if (tens == 4'b1001)
                begin
                    tens <= 0;
                    ones <= 0;
                end
                else
                begin
                tens <= tens +1;
                ones <= 0;
                end
            end
            else
            begin
                ones <= ones + 1;
            end
        end
        else if (upordown == 0)
        begin
            if (ones == 4'b0000)
            begin
                if (tens == 4'b0000)
                begin
                    ones <= 4'b1001;
                    tens <= 4'b1001;
                end
                else
                begin
                    tens <= tens - 1;
                    ones <= 4'b1001;
                end
            end
           else
           begin
               ones <= ones - 1;
           end
        end
    
    end
    
    
//output display
//inputs: morse1, morse2, morse3, morse4, morse5
//decodes and outputs on 7sed display
    reg [17:0] count;
always @ (posedge clk) //this will use clk since it needs to go through each an
begin //really quickly as if all lights are on
count <= count + 1;
end


//outputting to 7seg to each letter
reg [6:0] sseg;
always @ (*)
begin
case(count[17:15]) //using MSBs so it takes longer to count
2'b000 :
begin
sseg = morse1; //this outputs 1st letter
an = 8'b01111111;
end
2'b001 :
begin
sseg = morse2; //this outputs 2nd letter
an = 8'b10111111;
end
2'b010 :
begin
sseg = morse3; //this outputs 3rd letter
an = 8'b11011111;
end
2'b011 :
begin
sseg = morse4; //this outputs 4th letter
an = 8'b11101111;
end
2'b100 :
begin
sseg = morse5; //this outputs 5th letter
an = 8'b11110111;
end
2'b101 :
begin
sseg = morse5; //this outputs no value
an = 8'b11111111;
end
2'b110 :
begin
sseg = morse5; //this outputs no value
an = 8'b11111111;
end
2'b111 :
begin
sseg = morse5; //this outputs no value
an = 8'b11111111;
end

endcase
end

    
    
    //decoder and outputs to 7seg
    always @(*)
    begin
    
    fout = 0;
         case (sseg)
            16'b0000000000101110 : fout = 7'h08; //a
            16'b0000001110101010 : fout = 7'h60; //b
            16'b0000111010111010 : fout = 7'h31; //c
            16'b0000000011101010 : fout = 7'h42; //d
            16'b0000000000000010 : fout = 7'h30; //e
            16'b0000001010111010 : fout = 7'h38; //f
            16'b0000001110111010 : fout = 7'h04; //g
            16'b0000000010101010 : fout = 7'h48; //h
            16'b0000000000001010 : fout = 7'h79; //i
            16'b0010111011101110 : fout = 7'h47; //j
            //16'b0000001110101110 : fout = 7'h1C; //k
            16'b0000001011101010 : fout = 7'h71; //l
            //16'b0000000011101110 : fout = 7'h01; //m
            16'b0000000000111010 : fout = 7'h6A; //n
            16'b0000111011101110 : fout = 7'h62; //o
            16'b0000001011101110 : fout = 7'h18; //p
            //16'b0011101110101110 : fout = 7'h0C; //q
            16'b0000000010111010 : fout = 7'h7A; //r
            16'b0000000000101010 : fout = 7'h24; //s
            16'b0000000000001110 : fout = 7'h70; //t
            16'b0000000010101110 : fout = 7'h41; //u
            //16'b0000001010101110 : fout = 7'h01; //v
            //16'b0000001011101110 : fout = 7'h01; //w
            //16'b0000111010101110 : fout = 7'h01; //x
            16'b0011101011101110 : fout = 7'h44; //y
            //16'b0000111011101010 : fout = 7'h01; //z

        endcase
    
    end

       
        
             
    
    
    
    
endmodule