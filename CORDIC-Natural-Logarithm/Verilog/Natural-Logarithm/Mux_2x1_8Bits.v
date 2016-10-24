`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tecnológico de Costa Rica
// Engineer: Adrian Cervantes S
// 
// Create Date: 30.07.2016 10:22:05 
// Design Name: 
// Module Name: Mux_2x1_8Bits
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description:  
//					
//////////////////////////////////////////////////////////////////////////////////

module Mux_2x1_8Bits(
    
    //INPUTS
    input wire MS,           //SELECTOR
    input wire [7:0] D_0,    //DATO DE EN LA ENTRADA 0
    input wire [7:0] D_1,    //DATO DE EN LA ENTRADA 1
    
    //OUTPUTS
    output reg [7:0] D_out   //SALIDA 
    );

    always @*
        begin
            case(MS)
                1'b0: D_out = D_0;
                1'b1: D_out = D_1;
                default : D_out = D_0;
            endcase
        end

endmodule
