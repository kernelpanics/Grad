`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tecnológico de Costa Rica
// Engineer: Adrian Cervantes S
// 
// Create Date: 30.07.2016 10:22:05 
// Design Name:
// Module Name: Comparador_Mayor
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description:  
//					
//////////////////////////////////////////////////////////////////////////////////

module Comparador_Mayor(
    
    //INPUTS
    input wire CLK,
    input wire [7:0] A,
    input wire [7:0] B,
    //OUTPUTS
    output reg Out
    );
       
    always @(posedge CLK)
      if (A > B)
          Out <= 1'b1;
      else
          Out <= 1'b0;
    
endmodule
