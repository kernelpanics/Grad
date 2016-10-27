`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2016 09:24:55 AM
// Design Name: 
// Module Name: Deslinealizador
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module DESLINEALIZADOR#(parameter P = 32)(
    
    input wire CLK,             //system clock
    input wire [P-1:0] T,       //VALOR DEL ARGUMENTO DEL EXPONENCIAL QUE SE DESEA CALCULAR 
    input wire RST_EX,          //system reset
    input wire Begin_FSM_EX,    //INICIAL EL CALCULO 
    output wire ACK_EX,         //INDICA QUE EL CALCULO FUE REALIZADO
    output wire ACK_SUMX,
    output wire ACK_SUMY,
    output wire ACK_SUMZ,
    output wire O_FX,           //BANDERA DE OVER FLOW X
    output wire O_FY,           //BANDERA DE OVER FLOW Y
    output wire O_FZ,           //BANDERA DE OVER FLOW Z
    output wire U_FX,           //BANDERA DE UNDER FLOW X
    output wire U_FY,           //BANDERA DE UNDER FLOW Y
    output wire U_FZ,           //BANDERA DE UNDER FLOW Z
    output wire [P-1:0] RESULT  //RESULTADO FINAL
    );
    
    wire [4:0] CONT_ITERA;
    wire RST;
    wire MS_1;
    wire EN_REG3;
    //wire EN_REGMult;
    wire ADD_SUBT;
    wire Begin_SUMX;
    wire Begin_SUMY;
    wire Begin_SUMZ;
    wire EN_REG1X;
    wire EN_REG1Y;
    wire EN_REG1Z;
    wire MS_2;
    wire EN_REG2;
    wire CLK_CDIR;
    wire EN_REG2XYZ;
//    wire ACK_SUMX;
//    wire ACK_SUMY;
//    wire ACK_SUMZ;
//    wire ACK_MULTX,
//    wire ACK_MULTY,

    wire EN_MS1;
    wire EN_MS2;
    wire EN_ADDSUBT;
    wire MS_1_reg;
    wire MS_2_reg;
    wire ADD_SUBT_reg;

    assign BeginSUMX = Begin_SUMX;
    assign BeginSUMY = Begin_SUMY;
    assign BeginSUMZ = Begin_SUMZ;
 
Coprocesador_CORDIC C_CORDIC_EX (
                .T(T),
                .CLK(CLK),              //RELOJ DEL SISTEMA
                .RST(RST),
                .MS_1(MS_1_reg),
                .EN_REG3(EN_REG3),
                //.EN_REGMult(EN_REGMult),
                .ADD_SUBT(ADD_SUBT_reg),
                .Begin_SUMX(Begin_SUMX),
                .Begin_SUMY(Begin_SUMY),
                .Begin_SUMZ(Begin_SUMZ),
                .EN_REG1X(EN_REG1X),
                .EN_REG1Y(EN_REG1Y),
                .EN_REG1Z(EN_REG1Z),
                .MS_2(MS_2_reg),
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
                
FF_D #(.P(1)) REG_ADDSUBTL(             //#(.P(1))
                .CLK(CLK),              //RELOJ DEL SISTEMA
                .RST(RST),              //RESET
                .EN(EN_ADDSUBT),        //ENABLE
                .D(ADD_SUBT),           //ENTRADA
                .Q(ADD_SUBT_reg)        //SALIDA
                );
                             
FF_D #(.P(1)) REG_MS_1(
                .CLK(CLK),              //RELOJ DEL SISTEMA
                .RST(RST),              //RESET
                .EN(EN_MS1),            //ENABLE
                .D(MS_1),               //ENTRADA
                .Q(MS_1_reg)            //SALIDA
                );
                     
FF_D #(.P(1)) REG_MS_2(
                .CLK(CLK),              //RELOJ DEL SISTEMA
                .RST(RST),              //RESET
                .EN(EN_MS2),            //ENABLE
                .D(MS_2),               //ENTRADA
                .Q(MS_2_reg)            //SALIDA
                );
                
FSM_C_CORDIC M_E_EX (           
                .CLK(CLK),              //RELOJ DEL SISTEMA
                .RST_EX(RST_EX),        //system reset
                .ACK_ADD_SUBTX(ACK_SUMX),
                .ACK_ADD_SUBTY(ACK_SUMY),
                .ACK_ADD_SUBTZ(ACK_SUMZ),
                .Begin_FSM_EX(Begin_FSM_EX), 
                .CONT_ITER(CONT_ITERA),
                .RST(RST),
                .MS_1(MS_1),
                .EN_REG3(EN_REG3),
                //.EN_REGMult(EN_REGMult),
                .ADD_SUBT(ADD_SUBT),
                .Begin_SUMX(Begin_SUMX),
                .Begin_SUMY(Begin_SUMY),
                .Begin_SUMZ(Begin_SUMZ),               
                .EN_REG1X(EN_REG1X),
                .EN_REG1Y(EN_REG1Y),
                .EN_REG1Z(EN_REG1Z),
                .MS_2(MS_2),
                .EN_REG2(EN_REG2),
                .CLK_CDIR(CLK_CDIR),
                .EN_REG2XYZ(EN_REG2XYZ),
                .ACK_EX(ACK_EX),
                .EN_ADDSUBT(EN_ADDSUBT),
                .EN_MS1(EN_MS1),
                .EN_MS2(EN_MS2)
                );
endmodule
