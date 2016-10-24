`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tecnológico de Costa Rica
// Engineer: Adrian Cervantes S
// 
// Create Date: 30.07.2016 10:22:05 
// Design Name: 
// Module Name: FF_D
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description:  
//					
//////////////////////////////////////////////////////////////////////////////////

module FF_D	#(parameter P = 32)( //REGISTRO DE 32 BITS
    
    //INPUTS
    input wire CLK,         //RELOJ DEL SISTEMA
    input wire RST,         //RESET
    input wire EN,          //ENABLE
    input wire [P-1:0] D,   //ENTRADA
    //OUTPUTS
    output reg [P-1:0] Q    //SALIDA
    );

    always @(posedge CLK, posedge RST)
    begin
        if(RST)
            Q <= 0;
        else if(EN)
            Q <= D;
        else
            Q <= Q;
    end

endmodule