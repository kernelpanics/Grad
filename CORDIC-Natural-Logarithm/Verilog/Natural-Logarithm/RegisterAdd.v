`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tecnológico de Costa Rica
// Engineer: Juan José Rojas Salazar
// 
// Create Date: 30.07.2016 10:22:05 
// Design Name: 
// Module Name: Register 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description:  
//					
//////////////////////////////////////////////////////////////////////////////////

module RegisterAdd# (parameter W = 16)(

        //INPUTS
		input wire clk, //system clock
		input wire rst, //system reset
		input wire load, //load signal
		input wire [W-1:0] D, //input signal
		//OUTPUTS
		output reg [W-1:0] Q //output signal
    );

	always @(posedge clk, posedge rst)
		if(rst)
			Q <= 0;
		else if(load)
			Q <= D;
		else
			Q <= Q;

endmodule
