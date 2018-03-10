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
                           1) Up count button, 2) Down count button, 3) Reset input, 4) Upper limit on count
                           Since the up count and down count button they need to be toggled. Reset is used to set the counter to 0. Upper limit is the maximum limit of the counter. 
                           The outputs of the main module are
                           1) Power(on/off) 2) Entry door(open/close) 3) Exit door(open/close) 4) 4 digit Decimal display
*/


// Main testbench module
module Verilog_130_247();

   reg up_count;               // Up count input button: Press when person enters the room
   reg down_count;             // Down count input button: Press when person exits the room
   reg reset;                  // Reset input: Press to restart counter from 0
   reg [0:9]upper_limit;       // Upper limit input to the count 
   
   wire [0:3]count_digit_thousands;     // Thousand's place of the output count
   wire [0:3]count_digit_hundreds;     // Hundred's place of the output count
   wire [0:3]count_digit_tens;     // Ten's place of the output count
   wire [0:3]count_digit_ones;     // One's place of the output count
   wire power;                 // Power in the room (on/off)
   wire entry_door;            // Entry door of room (open/close)
   wire exit_door;             // Exit door of room (open/close)    
   
	// Initialising main module. Change the module name to VerilogDM-130-247.vcd for dataflow or VerilogBM-130-247.vcd for behavioral mode 
	VerilogDM_130_247 Main(up_count, down_count, reset, upper_limit, power, entry_door, exit_door, count_digit_thousands, count_digit_hundreds, count_digit_tens, count_digit_ones);
	
	initial
	begin
	$dumpfile("VerilogDM-130-247.vcd");                          // Change the dumpfile name to VerilogDM-130-247.vcd for dataflow wave or  VerilogBM-130-247.vcd for behavioral mode wave
 	$dumpvars;
	end

	initial 
	begin
		$display("\t\t\t\t\t\t\t\t\tCount digits on 7 segment display");
		$display("\t\tTime\tReset\tUp_count\tDown_count\tThousands\tHundreds\tTens\tUnits_place");
		$monitor("%d\t%b\t%b\t\t%b\t\t%d\t\t%d\t\t%d\t%d", $time, reset, up_count, down_count, count_digit_thousands, count_digit_hundreds, count_digit_tens, count_digit_ones);
	end
    
   reg up;        // up signal
   reg down;      // down signal   

	always
	begin
	   if(up == 1)                       // If up signal is 1,  people are entering the room
	   begin                 
		   #1
		   up_count = 1; 
		   #1                            // Toggle up count button
		   up_count = 0;
		   #1;
	   end    
	   else                              //  Else if down signal is 1, people are exiting the room                   
	   begin
			#1
			down_count = 1;
			#1                           // Toggle down count button
			down_count = 0;
			#1; 
	   end
	end

	initial
	begin
	   up_count = 0;              // Initialise up_count button to 0
	   down_count = 0;            // Initialise down_count button to 0
	   reset = 1;                 // Reset the counter
	   upper_limit = 20;          // Set maximum limit on the count: Maximum number of people able to be in the room
	   
	   #1
	   up = 1;                    // Initialise up signal to 1: People start entering the room 
	   down = 0;                  // Initialise down signal to 0
	   
		 
	   #4
	   reset = 0;                 // Unreset the counter
	   
	   #70
	   up = 0;                    // Initialise up signal to 0
	   down = 1;                  // Initialise down signal to 1: People start exiting the room 
	   
	   #60
	   $finish;
	end

endmodule

