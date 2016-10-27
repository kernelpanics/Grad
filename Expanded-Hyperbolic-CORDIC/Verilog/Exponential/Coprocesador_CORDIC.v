`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Juan Jose Rojas Salazar
// 
// Create Date: 07/07/2016 09:29:49 AM
// Design Name: 
// Module Name: Coprocesador_CORDIC
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

module Coprocesador_CORDIC#(parameter P = 32, parameter S=8, parameter D=5, parameter W_Exp = 8, 
        parameter W_Sgf = 23, parameter S_Exp = 9) (
        
    input wire [31:0] T,
    input wire CLK,                 //RELOJ DEL SISTEMA
    input wire RST,                 //RESET PARA LOS REGISTROS 
    input wire MS_1,                //SELECCION DEL MUX 1 VALOR INICIAL DE Z 
    input wire EN_REG3,             //ENABLE REG 3 RESULTADO EXP
    //input wire EN_REGMult,          //ENABLE REG MULT
    input wire ADD_SUBT,            //SELECCION DE OPERACION PARA EL ADD/SUBT FLOTANTE 
    input wire Begin_SUMX,          //INICIA LA OPERACION EN ADD/SUBT FLOTANTE
    input wire Begin_SUMY,          //INICIA LA OPERACION EN ADD/SUBT FLOTANTE
    input wire Begin_SUMZ,          //INICIA LA OPERACION EN ADD/SUBT FLOTANTE  
    input wire EN_REG1X,            //ENABLE PARA REGISTROS X,Y,Z DE LA PRIMERA ETAPA
    input wire EN_REG1Y,            //ENABLE PARA REGISTROS X,Y,Z DE LA PRIMERA ETAPA
    input wire EN_REG1Z,            //ENABLE PARA REGISTROS X,Y,Z DE LA PRIMERA ETAPA 
    input wire MS_2,                //SELECCION MUX 2
    input wire EN_REG2,             //ENABLE PARA EL REGISTRO QUE GUARDA LOS VALORES DESPLAZADOS EN LA SEGUNDA ETAPA
    input wire CLK_CDIR,            //CLK PARA EL CONTADOR DE ITERACIONES 
    input wire EN_REG2XYZ,          //ENABLE PARA REGISTROS QUE GUARDAN EL VALOR ANTERIOR DE X,Y,Z 
    output wire ACK_SUMX,           //ACK PARA DETERMINAR CUANDO LA SUMA FLOTANTE X SE COMPLETO
    output wire ACK_SUMY,           //ACK PARA DETERMINAR CUANDO LA SUMA FLOTANTE Y SE COMPLETO
    output wire ACK_SUMZ,           //ACK PARA DETERMINAR CUANDO LA SUMA FLOTANTE Z SE COMPLETO 
    output wire O_FX,               //BANDERA DE OVERFLOW X
    output wire O_FY,               //BANDERA DE OVERFLOW Y
    output wire O_FZ,               //BANDERA DE OVERFLOW Z
    output wire U_FX,               //BANDERA DE UNDERFLOW X
    output wire U_FY,               //BANDERA DE UNDERFLOW Y
    output wire U_FZ,               //BANDERA DE UNDERFLOW Z
    output wire [P-1:0] RESULT,     //RESULTADO FINAL 
    output wire [D-1:0] CONT_ITERA  //NUMERO DE LA ITERACION 
    );

    //salidas mux MS_1 a REG1X,Y,Z 
    wire [P-1:0] MUX0;
    wire [P-1:0] MUX1;
    wire [P-1:0] MUX2;   

    //salidas registros 1 a mux MS_2, signo y desplazador de exponente
    wire [P-1:0] X_ant; 
    wire [P-1:0] Y_ant;
    wire [P-1:0] Z_ant;  

    //salida LUT valores arctan 
    wire [P-1:0] LUT_arctan; 
    
    //salida valores exponentes y mantissas desplazados)
    wire [P-1:0] MULT_RESULTX;
    wire [P-1:0] MULT_RESULTY;
    
    //salida CONTADOR DE ITER A LUT'S
    wire [D-1:0] DIR_LUT;
          
    // salida de signos
    wire SIGNO_Z;

    //SIGNO + EXPONENTE + MANTISA
    wire [P-1:0] X_act; 
    wire [P-1:0] Y_act;
    wire [P-1:0] Z_act;

    //salidas registros 2 a sumadores punto flotante, signo y desplazador de exponente
    wire [P-1:0] REG2X; 
    wire [P-1:0] REG2Y;
    wire [P-1:0] REG2Z; 
    wire [P-1:0] REG2Xa;
    wire [P-1:0] REG2Ya;
    wire [P-1:0] REG2Za;
    wire [P-1:0] DESP;
    //wire [P-1:0] DESPX;
    //wire [P-1:0] DESPXY;
    //wire [P-1:0] DESPY; 
    //wire [P-1:0] DESPZ;
    
    //salidas MUX's MS_2 a ADD/SUBT flotante (esto pertenece al registro de Z)

    wire [P-1:0] A;
    wire [P-1:0] B;

    //resultado ADD/SUBT flotante X,Y,Z

    wire [P-1:0] X_RESULT;
    wire [P-1:0] Y_RESULT;
    wire [P-1:0] Z_RESULT;
    
    //ASIGNA VALOR DE LA ITERACION A LA DIRECCION DE LAS LUT 
    assign CONT_ITERA = DIR_LUT;

Mux_2x1 #(.P(P)) MUX2x1_0 ( 
    .MS(MS_1), 
    .D_0(X_RESULT), 
    .D_1(32'b01000110001100000010010110011010), //11273.4 7 iteraciones negativas (0,1,2,3,4,5,6)
    //.D_1(32'b01000001101011101100001010001111), //21.845 4 iteraciones negativas (0,1,2,3)
    //.D_1(32'b00111111111100010101100000010000), //1.8855 2 iteraciones negativas (0 y 1)
    .D_out(MUX0)
    );

Mux_2x1 #(.P(P)) MUX2x1_1 ( 
    .MS(MS_1), 
    .D_0(Y_RESULT),
    .D_1(32'b01000110001100000010010110011010), //11273.4 7 iteraciones negativas (0,1,2,3,4,5,6)
    //.D_1(32'b01000001101011101100001010001111), //21.845 4 iteraciones negativas (0,1,2,3) 
    //.D_1(32'b00111111111100010101100000010000), //1.8855 2 iteraciones negativas (0 y 1)
    .D_out(MUX1)
    );
    
Mux_2x1 #(.P(P)) MUX2x1_2 ( 
    .MS(MS_1), 
    .D_0(Z_RESULT), 
    .D_1(T),  //Entrada T, dato en coma flotante para calcular el exp(T)=sinh(T)+cosh(T)
    .D_out(MUX2)
    );
    
FF_D #(.P(P)) REG1_X ( 
    .CLK(CLK), 
    .RST(RST),
    .EN(EN_REG1X), 
    .D(MUX0), 
    .Q(X_ant)
    );

FF_D #(.P(P)) REG1_Y ( 
    .CLK(CLK), 
    .RST(RST),
    .EN(EN_REG1Y), 
    .D(MUX1), 
    .Q(Y_ant)
    );  
    
FF_D #(.P(P)) REG1_Z ( 
    .CLK(CLK), 
    .RST(RST),
    .EN(EN_REG1Z), 
    .D(MUX2), 
    .Q(Z_ant)
    );                                  

FF_D #(.P(P)) REG2_Xa ( 
    .CLK(CLK), 
    .RST(RST),
    .EN(EN_REG2XYZ), 
    .D(X_ant), 
    .Q(REG2Xa)
    );   
        
FF_D #(.P(P)) REG2_Ya ( 
    .CLK(CLK), 
    .RST(RST),
    .EN(EN_REG2XYZ), 
    .D(Y_ant), 
    .Q(REG2Ya)
    );   

FF_D #(.P(P)) REG2_Za ( 
    .CLK(CLK), 
    .RST(RST),
    .EN(EN_REG2XYZ), 
    .D(Z_ant), 
    .Q(REG2Za)
    );         
            
COUNTER_5B #(.P(D)) CONT_ITER ( 
    .CLK(CLK), 
    .RST(RST),
    .EN(CLK_CDIR),  
    .Y(DIR_LUT)
    );
                                           
LUT_SHIFT #(.P(P),.D(D)) LUT_ITER ( 
    .CLK(CLK),
    .EN_ROM1(1'b1), 
    .ADRS(DIR_LUT), 
    .O_D(DESP)
    );                        

LUT_Z #(.P(P),.D(D)) LUT_ARCTAN ( 
    .CLK(CLK),
    .EN_ROM1(1'b1), 
    .ADRS(DIR_LUT), 
    .O_D(LUT_arctan)
    ); 
    
FP_Mul #(.P(P)) MULTX(
    .clk(CLK),
    .a(X_ant),
    .b(DESP),
    .p(MULT_RESULTX)
    );
    
/*FP_Mul #(.P(P)) MULTY(
    .clk(CLK),
    .a(Y_ant),
    .b(DESP),
    .p(MULT_RESULTY)
    ); */
                                                       
assign X_act = {Z_ant[31],MULT_RESULTX[30:0]};
assign Y_act = {Z_ant[31],MULT_RESULTX[30:0]};
assign Z_act = {~Z_ant[31],LUT_arctan[30:0]};

FF_D #(.P(P)) REG2_X ( 
    .CLK(CLK), 
    .RST(RST),
    .EN(EN_REG2), 
    .D(X_act), 
    .Q(REG2X)
    ); 
            
FF_D #(.P(P)) REG2_Y ( 
    .CLK(CLK), 
    .RST(RST),
    .EN(EN_REG2), 
    .D(Y_act), 
    .Q(REG2Y)
    ); 

FF_D #(.P(P)) REG2_Z ( 
    .CLK(CLK), 
    .RST(RST),
    .EN(EN_REG2), 
    .D(Z_act), 
    .Q(REG2Z)
    );   
      
Mux_2x1 #(.P(P)) MUX2x1_4_1 ( 
    .MS(MS_2), 
    .D_0(X_ant), 
    .D_1(REG2Za),  
    .D_out(A)
    );
       
Mux_2x1 #(.P(P)) MUX2x1_4_2 ( 
    .MS(MS_2), 
    .D_0(Y_ant), 
    .D_1(REG2Z),  
    .D_out(B)
    ); 
                                          
FPU_Add_Subtract_Function #(.W(32),.EW(8),.SW(23),.SWR(26), .EWR(5)) SUM_SUBTX(
    .clk(CLK),
	.rst(RST),
	.beg_FSM(Begin_SUMX),
	.ack_FSM(ACK_SUMX),
	.Data_X(REG2Xa),
	.Data_Y(REG2X),
	.add_subt(ADD_SUBT),
	.r_mode(2'b00),
	.overflow_flag(O_FX),
	.underflow_flag(U_FX),
	.ready(ACK_SUMX),
	.final_result_ieee(X_RESULT)
    );
    
FPU_Add_Subtract_Function #(.W(32),.EW(8),.SW(23),.SWR(26), .EWR(5)) SUM_SUBTY(
    .clk(CLK),
    .rst(RST),
    .beg_FSM(Begin_SUMY),
    .ack_FSM(ACK_SUMY),
    .Data_X(REG2Ya),
    .Data_Y(REG2Y),
    .add_subt(ADD_SUBT),
    .r_mode(2'b00),
    .overflow_flag(O_FY),
    .underflow_flag(U_FY),
    .ready(ACK_SUMY),
    .final_result_ieee(Y_RESULT)
    );  
    
FPU_Add_Subtract_Function #(.W(32),.EW(8),.SW(23),.SWR(26), .EWR(5)) SUM_SUBTZ(
    .clk(CLK),
    .rst(RST),
    .beg_FSM(Begin_SUMZ),
    .ack_FSM(ACK_SUMZ),
    .Data_X(A),
    .Data_Y(B),
    .add_subt(ADD_SUBT),
    .r_mode(2'b00),
    .overflow_flag(O_FZ),
    .underflow_flag(U_FZ),
    .ready(ACK_SUMZ),
    .final_result_ieee(Z_RESULT)
    );   
		
FF_D #(.P(P)) REG_3 ( 
    .CLK(CLK), 
    .RST(RST),
    .EN(EN_REG3), 
    .D(Z_RESULT), 
    .Q(RESULT)
    );
                       
endmodule
