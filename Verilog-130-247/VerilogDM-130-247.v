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

// Main module
module VerilogDM_130_247(up_count, down_count, reset, upper_limit, power, entry_door, exit_door, count_digit4, count_digit3, count_digit2, count_digit1);
    
    input up_count;                //  Input button to count up   
    input down_count;              //  Input button to count down
    input reset;                   //  Reset input to reset count to 0
    input [0:9]upper_limit;        //  Upper limit of counter
     
    output [0:3]count_digit1;      //  One's place count output
    output [0:3]count_digit2;      //  Ten's place count output
    output [0:3]count_digit3;      //  Hundred's place count output
    output [0:3]count_digit4;      //  Thousand's place of count output
    output power;                  //  Power in the room (on/off)
    output entry_door;             //  Entry door of room (open/close)
    output exit_door;              //  Exit door of room (open/close)
    
    wire [0:9]count;               //  Count of people in the room
    wire [0:6]digit1_7seg;         //  Light encoding of one's place of count output in 7 segment display
    wire [0:6]digit2_7seg;         //  Light encoding of ten's place of count output in 7 segment display
    wire [0:6]digit3_7seg;         //  Light encoding of hundred's place of count output in 7 segment display
    wire [0:6]digit4_7seg;         //  Light encoding of thousand's place of count output in 7 segment display
    
    modified_counter counter(up_count, down_count, reset, upper_limit, count, power, entry_door, exit_door);         //  Initialize the modified counter
    binary_to_bcd bin_to_bcd(count, count_digit4, count_digit3, count_digit2, count_digit1);                         //  Initialize the binary to BCD converter 
    
    bcd_to_seven digit1(count_digit1, digit1_7seg);                //  Initialize BCD to 7 segment display for one's place of count                                                    
    bcd_to_seven digit2(count_digit2, digit2_7seg);                //  Initialize BCD to 7 segment display for ten's place of count 
    bcd_to_seven digit3(count_digit3, digit3_7seg);                //  Initialize BCD to 7 segment display for hundred's place of count 
    bcd_to_seven digit4(count_digit4, digit4_7seg);                //  Initialize BCD to 7 segment display for thousand's place of count
    
endmodule

// Modified Counter: Checks overflow and underflow. Maximum limit on count. Controls the power, entry and exit door of room
module modified_counter(up_count, down_count, reset, upper_limit, output_count, light, entry_door, exit_door);
   
   input up_count;                           //  Input button to count up   
   input down_count;                         //  Input button to count down
   input reset;                              //  Reset input to reset count to 0
   input [0:9]upper_limit;                   //  Upper limit of counter
   
   output [0:9]output_count;                 //  Count of number of people in room
   output light;                             //  Light or power in the room(on/off)         
   output entry_door;                        //  Entry door of room(open/close)
   output exit_door;                         //  Exit door of room(open/close)
   
   wire up_count_in;                         //  Up count input to counter
   wire down_count_in;                       //  Down count input to counter
   wire select_up;                           //  Selector signal to up count mux  
   wire select_down;                         //  Selector signal to down count mux
   wire [0:9]up_limit_bit;                   //  Maximum count
   
   mux_2to1 mux_0(~output_count[0], output_count[0], upper_limit[0], up_limit_bit[0]);
   mux_2to1 mux_1(~output_count[1], output_count[1], upper_limit[1], up_limit_bit[1]);
   mux_2to1 mux_2(~output_count[2], output_count[2], upper_limit[2], up_limit_bit[2]);
   mux_2to1 mux_3(~output_count[3], output_count[3], upper_limit[3], up_limit_bit[3]);
   mux_2to1 mux_4(~output_count[4], output_count[4], upper_limit[4], up_limit_bit[4]);
   mux_2to1 mux_5(~output_count[5], output_count[5], upper_limit[5], up_limit_bit[5]);
   mux_2to1 mux_6(~output_count[6], output_count[6], upper_limit[6], up_limit_bit[6]);
   mux_2to1 mux_7(~output_count[7], output_count[7], upper_limit[7], up_limit_bit[7]);
   mux_2to1 mux_8(~output_count[8], output_count[8], upper_limit[8], up_limit_bit[8]);
   mux_2to1 mux_9(~output_count[9], output_count[9], upper_limit[9], up_limit_bit[9]);
   
   assign select_down = !(output_count[0]|output_count[1]|output_count[2]|output_count[3]|output_count[4]|output_count[5]|output_count[6]|output_count[7]|output_count[8]|output_count[9]);
   assign select_up = (up_limit_bit[0]&up_limit_bit[1]&up_limit_bit[2]&up_limit_bit[3]&up_limit_bit[4]&up_limit_bit[5]&up_limit_bit[6]&up_limit_bit[7]&up_limit_bit[8]&up_limit_bit[9]);
   
   mux_2to1 mux_up(up_count, 0, select_up, up_count_in);
   mux_2to1 mux_down(down_count, 0, select_down, down_count_in);
   
   up_down_counter udCounter(up_count_in, down_count_in, reset, output_count);
    
   assign light = !select_down;
   assign entry_door = !select_up;
   assign exit_door = !select_down;
    
endmodule


// 10 bit Manual Sychronous Up-down counter
module up_down_counter(up_count, down_count, reset, output_count);
    
    input up_count;                // Count up signal
    input down_count;              // Count down signal
    input reset;                   // Reset signal
    
    output [0:9]output_count;      // Output count
    
    wire [0:9]cc_in1;              // Intermediate combinational circuit 
    wire [0:9]cc_in2;              // Intermediate combinational circuit 
    wire qn[0:9];                  // Q bar output of each T flip flop in counter
    wire qn_latch;                 // Q bar output of SR latch
    wire [0:8]tff_in;              // Inputs to the 10 T flip flops 
    wire clock;                    // Clock input

    assign clock = (up_count | down_count);

	sr_latch sr(1, up_count, down_count, cc_in1[9], temp);
	tFlipFlop tff9(clock, 1, reset, output_count[9], qn[9]);

	comb_circ cc8(cc_in1[9], output_count[9], qn[9], ~cc_in1[9], cc_in1[8], tff_in[8], cc_in2[8]);
	tFlipFlop tff8(clock, tff_in[8], reset, output_count[8], qn[8]);

	comb_circ cc7(cc_in1[8], output_count[8], qn[8], cc_in2[8], cc_in1[7], tff_in[7], cc_in2[7]);
	tFlipFlop tff7(clock, tff_in[7], reset, output_count[7], qn[7]);

	comb_circ cc6(cc_in1[7], output_count[7], qn[7], cc_in2[7], cc_in1[6], tff_in[6], cc_in2[6]);
	tFlipFlop tff6(clock, tff_in[6], reset, output_count[6], qn[6]);

	comb_circ cc5(cc_in1[6], output_count[6], qn[6], cc_in2[6], cc_in1[5], tff_in[5], cc_in2[5]);
	tFlipFlop tff5(clock, tff_in[5], reset, output_count[5], qn[5]);

	comb_circ cc4(cc_in1[5], output_count[5], qn[5], cc_in2[5], cc_in1[4], tff_in[4], cc_in2[4]);
	tFlipFlop tff4(clock, tff_in[4], reset, output_count[4], qn[4]);

	comb_circ cc3(cc_in1[4], output_count[4], qn[4], cc_in2[4], cc_in1[3], tff_in[3], cc_in2[3]);
	tFlipFlop tff3(clock, tff_in[3], reset, output_count[3], qn[3]);

	comb_circ cc2(cc_in1[3], output_count[3], qn[3], cc_in2[3], cc_in1[2], tff_in[2], cc_in2[2]);
	tFlipFlop tff2(clock, tff_in[2], reset, output_count[2], qn[2]);

	comb_circ cc1(cc_in1[2], output_count[2], qn[2], cc_in2[2], cc_in1[1], tff_in[1], cc_in2[1]);
	tFlipFlop tff1(clock, tff_in[1], reset, output_count[1], qn[1]);

	comb_circ cc0(cc_in1[1], output_count[1], qn[1], cc_in2[1], cc_in1[0], tff_in[0], cc_in2[0]);
	tFlipFlop tff0(clock, tff_in[0], reset, output_count[0], qn[0]);

endmodule


// Master Slave T flip flop
module tFlipFlop(clk, t, reset, q, qn);
   
    input clk;        // Clock input
    input t;          // T input
    input reset;      // Reset signal
    
    output q;         // Output q of t flip flop
    output qn;        // Output q bar of t flip flop
   
    wire   j2;        // Master's J input
    wire   k2;        // Master's K input
    wire   mq;        // Master's Q output.
    wire   mqn;       // Master's Qn output.
    wire   clkn;      // Complement clock to slave
    wire   j1;        // Slave's input
    wire   k1;        // Slave's output
   
    assign j2 = reset ? 0 : j1;   // Upon reset J2 = 0
    assign k2 = reset ? 1 : k1;   // Upon reset K2 = 1
   
    assign j1 = t & qn;
    assign k1 = t & q;
    assign clkn = !clk;
 
    sr_latch master(clk, j2, k2, mq, mqn);
    sr_latch slave(clkn, mq, mqn, q, qn);   
    
endmodule 

// Gated SR Latch
module sr_latch(e, s, r, q, qn);
   
    input e;        // Enable input
    input s;        // S input
    input r;        // R input
    output q;       // Q output
    output qn;      // Q bar output
   
    wire   s1;      // Input wire to S and gate
    wire   r1;      // Input wire to R and gate 
     
    assign s1 = e & s;
    assign r1 = e & r;   
    assign qn = !(s1 | q) === 1;
    assign q = !(r1 | qn) === 1;
endmodule 

// Intermediate Combinational Circuits used in up-down counter
module comb_circ(cc_in1, cc_in2, cc_in3, cc_in4, cc_out1, cc_out2, cc_out3);
	
	input cc_in1;          // Input 1 of combinational circuit
	input cc_in2;          // Input 2 of combinational circuit
	input cc_in3;          // Input 3 of combinational circuit
	input cc_in4;          // Input 4 of combinational circuit

	output cc_out1;        // Output 1 of combinational circuit
	output cc_out2;        // Output 2 of combinational circuit
	output cc_out3;        // Output 3 of combinational circuit

	assign cc_out1 = cc_in1 & cc_in2;
	assign cc_out3 = cc_in3 & cc_in4;
	assign cc_out2 = cc_out1 | cc_out3;

endmodule


// 2 to 1 multiplexer
module mux_2to1(input1, input2, select, out);
	
	input input1;    // Input 1 of mux
	input input2;    // Input 2 of mux
	input select;    // Select signal to mux
	
	output out;      // Output of mux
	
	assign out = ((~select) & input1) | (select & input2);

endmodule

// 10 bit binary to BCD convertor: Converts 10 bit binary number to 12 bit BCD number
module binary_to_bcd(binary_input, bcd_digit4, bcd_digit3, bcd_digit2, bcd_digit1);
	
	input [9:0]binary_input;     //  10 bit binary input
	output [3:0]bcd_digit4;      //  Thousands place of decimal output
	output [3:0]bcd_digit3;      //  Hundreds place of decimal output
	output [3:0]bcd_digit2;      //  Ten's place of decimal output
	output [3:0]bcd_digit1;      //  Unit's place of decimal output
	
	
	wire [3:0]temp0, temp1, temp2, temp3, 
	          temp4, temp5, temp6, temp7,                   // Intermediate wires used
	          temp8, temp13, temp14, temp15, 
	          temp16, temp17, temp18, temp26, 
	          temp27, temp28, temp9, temp19, temp29;

	check_add3 ca0(0, 0, 0, binary_input[9], temp0);

	check_add3 ca1(temp0[2], temp0[1], temp0[0], binary_input[9], temp1);

	check_add3 ca2(temp1[2], temp1[1], temp1[0], binary_input[8], temp2);

	check_add3 ca3(temp2[2], temp2[1], temp2[0], binary_input[7], temp3);
	check_add3 ca13(0, 0, 0, temp2[3], temp13);

	check_add3 ca4(temp3[2], temp3[1], temp3[0], binary_input[6], temp4);
	check_add3 ca14(temp13[2], temp13[1], temp13[0], temp3[3], temp14);

	check_add3 ca5(temp4[2], temp4[1], temp4[0], binary_input[5], temp5);
	check_add3 ca15(temp14[2], temp14[1], temp14[0], temp4[3], temp15);

	check_add3 ca6(temp5[2], temp5[1], temp5[0], binary_input[4], temp6);
	check_add3 ca16(temp15[2], temp15[1], temp15[0], temp5[3], temp16);
	check_add3 ca26(0, 0, 0, temp15[3], temp26);

	check_add3 ca7(temp6[2], temp6[1], temp6[0], binary_input[3], temp7);
	check_add3 ca17(temp16[2], temp16[1], temp16[0], temp6[3], temp17);
	check_add3 ca27(temp26[2], temp26[1], temp26[0], temp16[3], temp27);

	check_add3 ca8(temp7[2], temp7[1], temp7[0], binary_input[2], temp8);
	check_add3 ca18(temp17[2], temp17[1], temp17[0], temp7[3], temp18);
	check_add3 ca28(temp27[2], temp27[1], temp27[0], temp17[3], temp28);

	check_add3 ca9(temp8[2], temp8[1], temp8[0], binary_input[1], temp9);
	check_add3 ca19(temp18[2], temp18[1], temp18[0], temp8[3], temp19);
	check_add3 ca29(temp28[2], temp28[1], temp28[0], temp18[3], temp29);

	assign bcd_digit1[0] = binary_input[0];
	assign bcd_digit1[3:1] = temp9[2:0];
	assign bcd_digit2[0] = temp9[3];
	assign bcd_digit2[3:1] = temp19[2:0];
	assign bcd_digit3[0] = temp19[3];
	assign bcd_digit3[3:1] = temp29[2:0];
	assign bcd_digit4[0] = temp29[3];
	assign bcd_digit4[3:1] = 3'b000;

endmodule

// Intermediate Combinational circuit used in 10 bit binary to BCD converter
module check_add3(in_bit3, in_bit2, in_bit1, in_bit0, bcd_4bit);

	input in_bit0;           // Input bit 1
	input in_bit1;           // Input bit 2
	input in_bit2;           // Input bit 3
	input in_bit3;           // Input bit 4
	
	output [3:0]bcd_4bit;    // 4 bit BCD output
	
	wire temp1, temp2, temp3;       // Intermediate wires
	wire [3:0]summand;              // Summand to full adder
	wire carry;                     // Carry out of full adder
	wire [3:0]input_4bit;           // Input to full adder

   assign temp1 = in_bit0 | in_bit1;
   assign temp2 = in_bit2 & temp1;
   assign temp3 = in_bit3 | temp2;
   assign summand[0] = temp3;
   assign summand[1] = temp3;
   assign summand[3:2] = 2'b00;
   
   assign input_4bit[0] = in_bit0;
   assign input_4bit[1] = in_bit1;
   assign input_4bit[2] = in_bit2;
   assign input_4bit[3] = in_bit3;
   
   fullAdder_4bit full_adder(input_4bit, summand, bcd_4bit, carry);
   
endmodule

// BCD to 7 segment display decoder
module bcd_to_seven(A, out); 					 

	input [0:3]A;     // 4 bit BCD number
	output [0:6]out;  // Outputs to the 7 segments of the 7 segment display

	//assigning desired output
	assign	out[0] = ( A[1] & A[3] ) | ( ~A[1] & ~A[3] ) | A[0] | A[2];
	assign 	out[1] = ( A[2] & A[3] ) | ( ~A[2] & ~A[3] ) | (~A[1]);
	assign	out[2] = A[1] | (~A[2]) | A[3];
	assign	out[3] = A[0] | ( ~A[1] & ~A[3] ) | ( A[2] & ~A[3] ) | ( ~A[1] & A[2] ) | ( A[3] & A[1] & (~A[2]) );
	assign	out[4] = ( ~A[1] & ~A[3] ) | ( A[2] & ~A[3] );
	assign	out[5] = A[0] | ( ~A[2] & ~A[3] ) | ( A[1] & ~A[2] ) | ( A[1] & ~A[3] );
	assign	out[6] = ( ~A[1] & A[2] ) | ( A[2] & ~A[3]) | ( A[1] & ~ A[2]) | A[0];

endmodule

// 4 bit full adder
module fullAdder_4bit(a, b, sum, carry);

	input [3:0] a;      // Input 1 of full adder
	input [3:0] b;      // Input 2 of full adder
	
	output [3:0] sum;   // Output sum
	output carry;       // Output carry

	wire [2:0] c;       // Input carry

	fullAdder_1bit d1(a[0], b[0], 1'b0, sum[0], c[0]);
	fullAdder_1bit d2(a[1], b[1], c[0], sum[1], c[1]);
	fullAdder_1bit d3(a[2], b[2], c[1], sum[2], c[2]);
	fullAdder_1bit d4(a[3], b[3], c[2], sum[3], carry);


endmodule

// 1 bit full adder
module fullAdder_1bit(a, b, c, sum, carry);

	input a;         // Input 1 of full adder
	input b;         // Input 2 of full adder  
	input c;         // Carry In of full adder
	
	output sum;      // Output sum of full adder
	output carry;    // Input sum of full adder

	assign sum = a^b^c;
	assign carry = a&b | c&(a^b);

endmodule
