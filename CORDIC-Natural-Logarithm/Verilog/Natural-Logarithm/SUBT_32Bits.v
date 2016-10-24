`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tecnológico de Costa Rica
// Engineer: Adrian Cervantes S
// 
// Create Date: 30.07.2016 10:22:05 
// Design Name: 
// Module Name: SUBT_32Bits
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description:  
//					
//////////////////////////////////////////////////////////////////////////////////

module SUBT_32Bits(
    
    //INPUTS
    input wire [31:0] A,  //ENTRADA A
    input wire [31:0] B,  //ENTRADA B
    //OUTPUTS
    output wire [31:0] Y  //SALIDA Y
    );
    
    assign Y = A-B;       //RESTA DE ENTRADAS

endmodule
