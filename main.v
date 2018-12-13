//morse 1 dots
//morse 2 dashes 

module reaction_main(
  input clock,reset,confirm,morse1,morse2,bouncer,bouncer2,
  output [7:0] an,
  output led,
  output a, b, c, d, e, f, g, dp
  );
wire db_confirm, db_morse1, db_morse2;
reg dffstr1, dffstr2, dffstp1, dffstp2;
reg dffstr3, dffstr4, dffstpl3, dffstpl4;

always @ (posedge clock) dffstr1 <= confirm;
always @ (posedge clock) dffstr2 <= dffstr1;
  
assign db_confirm = ~dffstr1 & dffstr2; //monostable multivibrator to detect only one pulse of the button
  
always @ (posedge clock) dffstp1 <= morse1;
always @ (posedge clock) dffstp2 <= dffstp1;
  
assign db_morse1 = ~dffstp1 & dffstp2; //monostable multivibrator to detect only one pulse of the button

always @ (posedge clock) dffstr3 <= morse2;
always @ (posedge clock) dffstr4 <= dffstr3;
  
assign db_morse2 = ~dffstr3 & dffstr4; //monostable multivibrator to detect only one pulse of the button


reg [15:0]  regd4,regd3, regd2, regd1, regd0; //the main output registers

// Instantiate the 7 segment multiplexing module
muxer display (
    .clock(clock), 
    .reset(reset), 
    .fifth(regd4),
    .fourth(regd3), 
    .third(regd2), 
    .second(regd1), 
    .first(regd0), 
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
 reg [3:0] morse_counter;
 reg [15:0] temp;
 reg [2:0] letter_counter;
 reg [1:0] bounce;
 reg [1:0] bounce2;
 reg [15:0] count;
 reg morse_temp;
 reg morse_temp2;
 
 always @(posedge morse1 or posedge clock)
 begin
    if (morse1 == 1)
    begin
        morse_temp = 1;
        morse_temp2 = 1;
    end
    else if (morse1 == 1 && count >= 250000 && count < 500000)
    begin
        morse_temp = 1;
        morse_temp2 = 0;
        count = 0;
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
 
 
 
 //main 
 always @ (posedge clock or posedge reset)
 begin
    if(reset) 
    begin
     regd0 =  16'b0000000000000000;
     regd1 =  16'b0000000000000000;
     regd2 =  16'b0000000000000000;
     regd3 =  16'b0000000000000000;
     morse_code =16'b0000000000000000;
     morse_counter =0;
     sseg1 =0;
     sseg2 =0;
     sseg3 =0;
     sseg4 =0;
     sseg5 =0;
     letter_counter =0;
     bounce =0;
     bounce2=0;
     
     end
     else if(db_confirm && letter_counter ==0 && bounce2 ==0)
     begin
        
        
            sseg1 = morse_code;
            regd0 = sseg1;
            letter_counter = letter_counter +1;
            morse_counter =0;
            bounce2=1;
    end
     else if(db_confirm && letter_counter ==1 && bounce2 ==0)
     begin
        
            sseg2 = sseg1;
            sseg1 = morse_code;
            regd1 = sseg2;
            regd0 = sseg1;
            letter_counter = letter_counter +1;
            morse_counter =0;
            bounce2=1;
    end
    
     else if(db_confirm && letter_counter ==2 && bounce2 ==0)
     begin
            sseg3 = sseg2;
            sseg2 = sseg1;
            sseg1 = morse_code;
            regd2 = sseg3;
            regd1 = sseg2;
            regd0 = sseg1;
            letter_counter = letter_counter +1;
            morse_counter =0;
            bounce2=1;
    end
    
     else if(db_confirm && letter_counter ==3 && bounce2 ==0)
     begin  
            sseg4 = sseg3;
            sseg3 = sseg2;
            sseg2 = sseg1;
            sseg1 = morse_code;
            regd3 = sseg4;
            regd2 = sseg3;
            regd1 = sseg2;
            regd0 = sseg1;
            letter_counter = letter_counter +1;
            morse_counter =0;
            bounce2=1;
    end
    
     else if(db_confirm && letter_counter ==4 && bounce2 ==0)
     begin
            sseg5 = sseg4;
            sseg4 = sseg3;
            sseg3 = sseg2;
            sseg2 = sseg1;
            sseg1 = morse_code;
            regd4 = sseg5;
            regd3 = sseg4;
            regd2 = sseg3;
            regd1 = sseg2;
            regd0 = sseg1;
            letter_counter = letter_counter +1;
            morse_counter =0;
            bounce2=1;
    end
    
    
    
    
    
    else if(bouncer2)
        begin
            bounce2=0;
        end
    else 
    begin 
        //morse ccont for 1
        //display dot
        if(db_morse1&& bounce==0 && morse_counter ==0 ) 
        begin   
           morse_code = 16'b000000000000000;   
           morse_code = morse_code | 16'b0000000000000001; 
           morse_code = morse_code <<1;
           morse_counter =1;
           bounce =1;

        end
        else if(db_morse2 && bounce==0 && morse_counter ==0)
        begin
            morse_code = 16'b000000000000000;   
            morse_code = morse_code | 16'b0000000000000111; 
            morse_code = morse_code <<1;
            morse_counter =1;
            bounce =1;
           
        end
        if(bouncer)
        begin
         bounce =0;
        end
        //end morse 1
         if(db_morse1 && morse_counter ==1&& bounce==0)
         begin
                
         morse_code = morse_code <<1;
         morse_code = morse_code | 16'b0000000000000001; 
         morse_code = morse_code <<1; 
         morse_counter =2;
         bounce =1;
 
  
         end
        else if(db_morse2 && morse_counter==1&& bounce==0)
        begin
        morse_code = morse_code <<3;     
        morse_code = morse_code | 16'b0000000000000111; 
        morse_code = morse_code <<1; 
        morse_counter =2;
        bounce =1;

        end
          if(bouncer)
        begin
         bounce =0;
        end
        if(db_morse1 && morse_counter ==2&& bounce==0)
         begin
           
         morse_code = morse_code <<1;
         morse_code = morse_code | 16'b0000000000000001; 
         morse_code = morse_code <<1; 
         morse_counter =3;
         bounce =1;
       
         end
        else if(db_morse2 && morse_counter==2&& bounce==0)
        begin
        morse_code = morse_code <<3; 
        morse_code = morse_code | 16'b0000000000000111; 
        morse_code = morse_code <<1; 
        morse_counter =3;
         bounce =1;
        
        end
          if(bouncer)
        begin
         bounce =0;
        end
         if(db_morse1 && morse_counter ==3&& bounce==0)
         begin
         morse_code = morse_code <<1;
         morse_code = morse_code | 16'b0000000000000001; 
         morse_code = morse_code <<1; 
         bounce =1;

         end
        else if(db_morse2 && morse_counter==3&& bounce==0)
        begin
           morse_code = morse_code <<3;
        morse_code = morse_code | 16'b0000000000000111; 
        morse_code = morse_code <<1; 
        bounce =1;

        end
     
        
        
        
    end
 end


// end main 




endmodule