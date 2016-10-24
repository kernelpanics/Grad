`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tecnológico de Costa Rica
// Engineer: Juan José Rojas Salazar
// 
// Create Date: 30.07.2016 10:22:05 
// Design Name: 
// Module Name: LINEALIZADOR_NORMALIZADOR 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description:  
//					
//////////////////////////////////////////////////////////////////////////////////

module LINEALIZADOR_NORMALIZADOR(
    
    //INPUTS
    input wire CLK,
    input wire [31:0] I,
    input wire [31:0] V,
    input wire RST_LN_FF,
    input wire Begin_FSM_I,
    input wire Begin_FSM_V,
    //OUTPUTS
    output wire ACK_I,
    output wire ACK_V,
    output wire [31:0] RESULT_I,
    output wire [31:0] RESULT_V
    );
    
    wire ACK_LN; 
    wire ACK_FF;
    wire [31:0] LINEAL;

    LINEALIZADOR #(.P(32)) LINEALIZADOR_FLOAT (
        .CLK(CLK),                      //system clock
        .T(I),                          //VALOR DEL ARGUMENTO DEL LOGARITMO QUE SE DESEA CALCULAR 
        .RST_LN(RST_LN_FF),             //system reset
        .Begin_FSM_LN(Begin_FSM_I),     //INICIAL EL CALCULO 
        .ACK_LN(ACK_LN),                //INDICA QUE EL CALCULO FUE REALIZADO 
        .O_FX(),                        //BANDERA DE OVER FLOW X
        .O_FY(),                        //BANDERA DE OVER FLOW Y
        .O_FZ(),                        //BANDERA DE OVER FLOW Z
        .U_FX(),                        //BANDERA DE UNDER FLOW X
        .U_FY(),                        //BANDERA DE UNDER FLOW Y        
        .U_FZ(),                        //BANDERA DE UNDER FLOW Z 
        .RESULT(LINEAL)                 //RESULTADO FINAL 
        );
               
    I_NORM_FLOAT_TO_FIXED NORM_I_FLOAT_FIXED(
        .CLK(CLK),                      //system clock
        .F(LINEAL),                     //VALOR BINARIO EN COMA FLOTANTE 
        .RST_FF(RST_LN_FF),             //system reset
        .Begin_FSM_FF(ACK_LN),          //INICIA LA CONVERSION 
        .ACK_FF(ACK_I),                 //INDICA QUE LA CONVERSION FUE REALIZADA 
        .RESULT(RESULT_I)               //RESULTADO FINAL 
        );
        
    /*V_NORM_FLOAT_TO_FIXED NORM_V_FLOAT_FIXED(
        .CLK(CLK),                      //system clock
        .F(V),                          //VALOR BINARIO EN COMA FLOTANTE 
        .RST_FF(RST_LN_FF),             //system reset
        .Begin_FSM_FF(Begin_FSM_V),     //INICIA LA CONVERSION 
        .ACK_FF(ACK_V),                 //INDICA QUE LA CONVERSION FUE REALIZADA 
        .RESULT(RESULT_V)               //RESULTADO FINAL 
        );*/

endmodule
