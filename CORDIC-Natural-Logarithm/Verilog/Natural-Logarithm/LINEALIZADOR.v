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

module LINEALIZADOR #(parameter P = 32)(
    
    input wire CLK,                 //system clock
    input wire [P-1:0] T,           //VALOR DEL ARGUMENTO DEL LOGARITMO QUE SE DESEA CALCULAR 
    input wire RST_LN,              //system reset
    input wire Begin_FSM_LN,        //INICIAL EL CALCULO 
    output wire ACK_LN,             //INDICA QUE EL CALCULO FUE REALIZADO 
    output wire ACK_SUMX,
    output wire ACK_SUMY,
    output wire ACK_SUMZ,
    output wire O_FX,               //BANDERA DE OVER FLOW
    output wire O_FY,               //BANDERA DE OVER FLOW
    output wire O_FZ,               //BANDERA DE OVER FLOW
    output wire U_FX,               //BANDERA DE UNDER FLOW
    output wire U_FY,               //BANDERA DE UNDER FLOW
    output wire U_FZ,               //BANDERA DE UNDER FLOW  
    output wire [P-1:0] RESULT      //RESULTADO FINAL   
    );
    
    wire [4:0] CONT_ITERA;
    wire RST;
    wire MS_1;
    wire EN_REG3;
    wire EN_REG4;
    wire ADD_SUBT;
    wire Begin_SUMX;
    wire Begin_SUMY;
    wire Begin_SUMZ;
    wire EN_REG1X;
    wire EN_REG1Z;
    wire EN_REG1Y;
    wire MS_2;
    wire MS_3;
    wire EN_REG2;
    wire CLK_CDIR;
    wire EN_REG2XYZ;
//    wire ACK_SUMX;
//    wire ACK_SUMY;
//    wire ACK_SUMZ;
    
    wire EN_MS1;
    wire EN_MS2;
    wire EN_MS3;
    wire EN_ADDSUBT;
    wire MS_1_reg;
    wire MS_2_reg;
    wire MS_3_reg;
    wire ADD_SUBT_reg;
 
Coprocesador_CORDIC C_CORDIC_LN (
                .T(T),
                .CLK(CLK), //RELOJ DEL SISTEMA
                .RST(RST),
                .MS_1(MS_1_reg),
                .EN_REG3(EN_REG3),
                .EN_REG4(EN_REG4),
                .ADD_SUBT(ADD_SUBT_reg),
                .Begin_SUMX(Begin_SUMX),
                .Begin_SUMY(Begin_SUMY),
                .Begin_SUMZ(Begin_SUMZ),
                .EN_REG1X(EN_REG1X),
                .EN_REG1Z(EN_REG1Z),
                .EN_REG1Y(EN_REG1Y),
                .MS_2(MS_2_reg),
                .MS_3(MS_3_reg),
                .EN_REG2(EN_REG2),
                .CLK_CDIR(CLK_CDIR),
                .EN_REG2XYZ(EN_REG2XYZ),
                .ACK_SUMX(ACK_SUMX),
                .ACK_SUMY(ACK_SUMY),
                .ACK_SUMZ(ACK_SUMZ),
                .O_FX(O_FX),
                .U_FX(U_FX),
                .O_FY(O_FY),
                .U_FY(U_FY),
                .O_FZ(O_FZ),
                .U_FZ(U_FZ),
                .RESULT(RESULT),
                .CONT_ITERA(CONT_ITERA)
                );
                
FF_D #(.P(1)) REG_ADDSUBTL(                  //#(.P(1))
                .CLK(CLK),                   //RELOJ DEL SISTEMA
                .RST(RST),                   //RESET
                .EN(EN_ADDSUBT),             //ENABLE
                .D(ADD_SUBT),                //ENTRADA
                .Q(ADD_SUBT_reg)             //SALIDA
                );
                
FF_D #(.P(1)) REG_MS_1(
                .CLK(CLK),                   //RELOJ DEL SISTEMA
                .RST(RST),                   //RESET
                .EN(EN_MS1),                 //ENABLE
                .D(MS_1),                    //ENTRADA
                .Q(MS_1_reg)                 //SALIDA
                );

FF_D #(.P(1)) REG_MS_2(
                .CLK(CLK),                   //RELOJ DEL SISTEMA
                .RST(RST),                   //RESET
                .EN(EN_MS2),                 //ENABLE
                .D(MS_2),                    //ENTRADA
                .Q(MS_2_reg)                 //SALIDA
                );
                          
FF_D #(.P(1)) REG_MS_3(
                .CLK(CLK),                   //RELOJ DEL SISTEMA
                .RST(RST),                   //RESET
                .EN(EN_MS3),                 //ENABLE
                .D(MS_3),                    //ENTRADA
                .Q(MS_3_reg)                 //SALIDA
                );
                          
FSM_C_CORDIC M_E_LN (
                .CLK(CLK),                   //RELOJ DEL SISTEMA
                .RST_LN(RST_LN),             //system reset
                .ACK_ADD_SUBTX(ACK_SUMX),
                .ACK_ADD_SUBTY(ACK_SUMY),
                .ACK_ADD_SUBTZ(ACK_SUMZ),
                .Begin_FSM_LN(Begin_FSM_LN), //inicia la maquina de estados 
                .CONT_ITER(CONT_ITERA),
                .RST(RST),
                .MS_1(MS_1),
                .EN_REG3(EN_REG3),
                .EN_REG4(EN_REG4),
                .ADD_SUBT(ADD_SUBT),
                .Begin_SUMX(Begin_SUMX),
                .Begin_SUMY(Begin_SUMY),
                .Begin_SUMZ(Begin_SUMZ),
                .EN_REG1X(EN_REG1X),
                .EN_REG1Y(EN_REG1Y),
                .EN_REG1Z(EN_REG1Z),
                .MS_2(MS_2),
                .MS_3(MS_3),
                .EN_REG2(EN_REG2),
                .CLK_CDIR(CLK_CDIR),
                .EN_REG2XYZ(EN_REG2XYZ),
                .ACK_LN(ACK_LN),
                .EN_ADDSUBT(EN_ADDSUBT),
                .EN_MS1(EN_MS1),
                .EN_MS2(EN_MS2),
                .EN_MS3(EN_MS3)
                );
endmodule
