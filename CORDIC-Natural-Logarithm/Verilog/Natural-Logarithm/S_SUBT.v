`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tecnológico de Costa Rica
// Engineer: Adrian Cervantes S
// 
// Create Date: 30.07.2016 10:22:05 
// Design Name: 
// Module Name: S_SUBT
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description:  
//					
//////////////////////////////////////////////////////////////////////////////////

module S_SUBT #(P=8, W=5)( //RESTADOR EXPONENTE FORMATO PUNTO FLOTANTE EN 32 BITS
    
    //INPUTS
    input wire [P-1:0] A,   //ENTRADA A
    input wire [W-1:0] B,   //ENTRADA B
    //OUTPUTS
    output wire [P-1:0] Y   //SALIDA Y
    );

    assign Y = A-B;         //RESTA DE ENTRADAS

endmodule
