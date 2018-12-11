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

    always @(posedge clk or posedge reset)
begin
	 if(reset)
	 begin
		timer <= 0;
	 end
	else
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
    
    

    reg [17:0] count;
always @ (posedge clk) //this will use clk since it needs to go through each an
begin //really quickly as if all lights are on
count <= count + 1;
end



reg [6:0] sseg;
always @ (*)
begin
case(count[17:16]) //using MSBs so it takes longer to count
2'b00 :
begin
sseg = ones; //this outputs the ones value
an = 8'b11111110;
end
2'b01 :
begin
sseg = tens; //this outputs the tens value
an = 8'b11111101;
end
2'b10 :
begin
sseg = ones; //this outputs the ones value
an = 8'b11111110;
end
2'b11 :
begin
sseg = tens; //this outputs the tens value
an = 8'b11111101;
end
endcase
end

    
    
    
    always @(*)
    begin
    
    fout = 0;
         case (sseg)
            4'h0 : fout = 7'h01;
            4'h1 : fout = 7'h4F;
            4'h2 : fout = 7'h12;
            4'h3 : fout = 7'h06;
            4'h4 : fout = 7'h4C;
            4'h5 : fout = 7'h24;
            4'h6 : fout = 7'h20;
            4'h7 : fout = 7'h0F;
            4'h8 : fout = 7'h00;
            4'h9 : fout = 7'h04;
        endcase
    
    end

       
        
             
    
    
    
    
endmodule