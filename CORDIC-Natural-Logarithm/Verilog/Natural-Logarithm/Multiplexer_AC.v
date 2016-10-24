`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tecnológico de Costa Rica
// Engineer: Juan José Rojas Salazar
// 
// Create Date: 30.07.2016 10:22:05 
// Design Name: 
// Module Name: Multiplexer_AC 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description:  
//					
//////////////////////////////////////////////////////////////////////////////////

module Multiplexer_AC# (parameter W = 32)(
    
    //INPUTS
    input wire ctrl,
    input wire [W-1:0] D0,
    input wire [W-1:0] D1,
    //OUTPUTS
    output reg [W-1:0] S
    );
    
   always @(ctrl, D0, D1)
      case (ctrl)
         1'b0: S <= D0;
         1'b1: S <= D1;
      endcase
		
endmodule