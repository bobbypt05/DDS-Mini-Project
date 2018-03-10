/*
Title: Automatic Room Power using Bidirectional Visitor Counter

Reg No: 16CO130, 16CO247

Abstract: The aim of the project is to automate the basic components in a room which would otherwise require to be done manually. The basic components addressed here are
          the electricity in a room, maximum occupancy of a room and the entry/exit doors of a room. These components can be controlled based on the number of people in the room.
          It is very important to save energy but very few buildings have the needed technology to automatically control power. This leads to drastic wastage of power. 
          Our model aims to automatically control the power in a room. This model also has the additional functionality of limiting the number of people in the room thus 
          preventing congestion and overuse of resources in the room. This model can be implemented in classrooms(to check attendance also), theatres(limited occupancy), 
          trains(to save power and check no. of passengers), conference rooms etc. 
          
Functionalities: 1) Controls the power in the room to save energy based on the count of people inside the room
                 2) Controls the entry and exit door of the room according to the count of people inside the room
                 3) Accepts input on the maximum occupancy of room and restricts people from entering the room when maximum limit is reached
                 4) Checks for underflow and overflow in count
                 5) 7 Segment Display
                 
Brief Description on code: The main module has the following inputs: 
                           1) Up count button, 2) Down count button, 3) Reset button, 4) Upper limit on count
                           Main module initialises the "modified_counter" module which is a modified 10 bit synchronous up-down counter which has functionalites(1 to 4) described above.
                           It also initialises binary to BCD convertor module("binary_to_bcd") used to convert the 10 bit binary output from counter to BCD
                           It initialises four 7 segment displays to display the 4 digit decimal number which indicates the count
                           The outputs of the main module are
                           1) Power(on/off) 2) Entry door(open/close) 3) Exit door(open/close) 4) 4 digit Decimal display
*/

//Main module
module VerilogBM_130_247(up_count, down_count, reset, upper_limit, power, entry_door, exit_door, count_digit4, count_digit3, count_digit2, count_digit1);
    input up_count;                //  Input button to count up   
    input down_count;              //  Input button to count down
    input reset;                   //  Reset input to reset count to 0
    input [0:9]upper_limit;        //  Upper limit of counter 
	input clk;
    
	output [0:3]count_digit1;      //  One's place count output
    output [0:3]count_digit2;      //  Ten's place count output
    output [0:3]count_digit3;      //  Hundred's place count output
    output [0:3]count_digit4;      //  Thousand's place of count output
    output power;                  //  Power in the room (on/off)
    output entry_door;             //  Entry door of room (open/close)
    output exit_door;              //  Exit door of room (open/close)
    output  [0:9]out;
	
	person_count M1(clk,up_count,down_count,reset,upper_limit,power,entry_door,exit_door,out);
	binary_to_BCD M2(out,count_digit4,count_digit3,count_digit2,count_digit1);
	
	
   
endmodule

//behevioral for BCD to 7 segment display

module bcd_to_seven(out,A); 					//Module for BCD to 7 segment display decoder 

	input [0:3]A;
	output reg [0:6]out;

	initial
	begin
	   out=7'b0000000; 							// Initially all the output of decoder is zero;
	end
	
	always @( A )                              //When there is change in BCD input display should change
	begin
		out[0] = ( A[1] & A[3] ) | ( ~A[1] & ~A[3] ) | A[0] | A[2];
		out[1] = ( A[2] & A[3] ) | ( ~A[2] & ~A[3] ) | (~A[1]);
		out[2] = A[1] | (~A[2]) | A[3];
		out[3] = A[0] | ( ~A[1] & ~A[3] ) | ( A[2] & ~A[3] ) | ( ~A[1] & A[2] ) | ( A[3] & A[1] & (~A[2]) );
		out[4] = ( ~A[1] & ~A[3] ) | ( A[2] & ~A[3] );
		out[5] = A[0] | ( ~A[2] & ~A[3] ) | ( A[1] & ~A[2] ) | ( A[1] & ~A[3] );
		out[6] = ( ~A[1] & A[2] ) | ( A[2] & ~A[3]) | ( A[1] & ~ A[2]) | A[0];
	end
endmodule

//Behavioral Model for converting 10-binary to 16 bit BCD code 

module binary_to_BCD(bin,count_digit1,count_digit2,count_digit3,count_digit4);
	parameter n=10,m=16;   									//parameter for input and output size where n is input bit size and m is output bit size
	input [n-1:0]bin;										// Binary input is stored in bin
	output reg [m-1:0]bcd;									//BCD code's output is stored in bcd
	output reg[0:3] count_digit1,count_digit2,count_digit3,count_digit4;
	
	parameter l = n + m;				
	parameter k = m / 4;
	
	reg [m+n-1:0] z;  										//temparory register used to calculate BCD
	
	integer i,j;						
	
	always @ ( bin )                 						//when input Binary code changes
	begin
		
		for( i = 0 ; i < l ; i=i+1 )						//Initialise the Z to zero as required
		begin
			z[i]=1'b0;
		end
		
		z[n+2:3] = bin;										
															//Main code to convert binary to BCD which shifts the bits to left and checks
		for(i = 0 ;i < (n-3) ; i=i+1)						//in group of four whether it is greater then 4 or not
		begin
			for( j = 0; j < k ;j = j +1 )
			begin 
				if(z[(n+j*4+3)-:4] > 4'b0100)				//If greater than 4 add , add 3 to it. 
					z[(n+j*4+3)-:4] = z[(n+j*4+3)-:4] + 2'b11;
				else
					z[(n+4*j+3)-:4] = z[(n+j*4+3)-:4];		//else keep it as it is
		    end
			z[l-1:1] = z[l-2:0];							//Z=Z<<1
		end
		bcd = z[l-1:n];										//copy the value of z to output BCD code.
	
	count_digit1=bcd[15:12];                         		//copying the values of BCD into four respective parts
	count_digit2=bcd[11:8];
	count_digit3=bcd[7:4];
	count_digit4=bcd[3:0];
	
	end
	
	
	
endmodule		
			


module person_count(clk,up_count,down_count,reset,upper_limit,power,entry_door,exit_door,out);
	
	input up_count,down_count,reset;
	input clk;
	input [0:9]upper_limit;
	
	output reg [0:9]out;
	output reg power,entry_door,exit_door;
	initial
	begin
	                         
	    entry_door=1'b1;										//Entry door should be initially open
		exit_door=1'b1;											//Exit door should be initially open
	end
	always @ (up_count or down_count)  
	begin
		if( reset )												//if reset count will reset to zero
			out = 10'b0000000000;
		else if( up_count == 1'b1 && out < upper_limit )		//if up_down == 1 that is entry button is pressed , Do upcount till 2^10-1
			out = out+1;
		else if(out != 10'b0000000000 && down_count == 1'b1 )	// if up_down == 0 that is the button at exit is pressed , down count 
			out = out-1;
			
		if(out > 0)												//if there are persons in the room, power shold be ON else it should be OFF
			power=1'b1;
		else
			power=1'b0;
        if(out==upper_limit)									//When upper limit is reached entry door should be closed
			entry_door=1'b0;
		else
			entry_door=1'b1;									//else entry door should be open
		if(out==0)												//if no one is in room entry door should be close
			exit_door=1'b0;
		else
		    exit_door=1'b1;										//else should be open
	end
endmodule
