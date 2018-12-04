//morse 1 dots
//morse 2 dashes 

module reaction_main(
  input clock,reset,confirm,morse1,
  output [7:0] an,
  output a, b, c, d, e, f, g, dp
  );

// Instantiate the 7 segment multiplexing module
muxer display (
    .clock(clock), 
    .reset(reset), 
    .fifth(sseg5),
    .fourth(sseg4), 
    .third(sseg3), 
    .second(sseg2), 
    .first(sseg1), 
    .a_m(a), 
    .b_m(b), 
    .c_m(c), 
    .d_m(d), 
    .e_m(e), 
    .f_m(f), 
    .g_m(g), 
    .dp_m(dp), 
    .an_m(an)
    );
 reg [29:0] clock_timer;
 reg [15:0] sseg1;
 reg [15:0] sseg2;
 reg [15:0] sseg3;
 reg [15:0] sseg4;
 reg [15:0] sseg5;
 reg [15:0] morse_code;
 reg [2:0] letter_counter;
 reg [15:0] count;
 reg conf_temp;
 reg morse_temp;
 reg morse_temp2;
 
 always @(posedge morse1 or posedge clock or posedge confirm)
 begin
    if (morse1 == 1)
    begin
        morse_temp = 1;
        morse_temp2 = 1;
        clock = 0;
    end
    else if (confirm == 1)
    begin
        conf_temp = 1;
        count = 0;
    end
    else if (morse1 == 1 && count < 500000)
    begin
        morse_temp = 1;
        morse_temp2 = 0;
    end
    else if (morse1 == 1 && count >= 500000)
    begin
        count = 0;
        morse_temp = 0;
        morse_temp2 = 1;
    end
    else
    begin
        count = count + 1;
    end
 
 
 end
 
 
 always @(posedge clock or posedge reset)
 begin
 
    if(reset) 
    begin
     morse_code = 0;
     morse_temp = 0;
     morse_temp2 = 0;
     conf_temp = 0;
     sseg1 =0;
     sseg2 =0;
     sseg3 =0;
     sseg4 =0;
     sseg5 =0;
     letter_counter =0;
    end
    if (morse_temp)             //if dot
    begin
        morse_temp <= 0;
        morse_code = morse_code <<1;   
        morse_code = morse_code | 16'b0000000000000001; 
        morse_code = morse_code <<1;
    end
    else if (morse_temp2)
    begin
        morse_temp2 <= 0;
        morse_code = morse_code <<3;            //if dash
        morse_code = morse_code | 16'b0000000000000111; 
        morse_code = morse_code <<1;
    end
    else if (conf_temp)
    begin
        case (letter_counter)               //sends to sseg registers (letters on display)
            3'b000 : sseg1 = morse_code; 
            3'b001 : sseg2 = morse_code; 
            3'b010 : sseg3 = morse_code; 
            3'b011 : sseg4 = morse_code; 
            3'b100 : sseg5 = morse_code; 
        endcase
        conf_temp <= 0;
        morse_code <= 0;
        morse_temp <= 0;
        morse_temp2 <= 0;
        letter_counter <= letter_counter + 1;
        
    end
 
 
 end
 
 
 
 
 endmodule