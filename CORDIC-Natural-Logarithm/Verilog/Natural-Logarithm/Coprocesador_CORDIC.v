`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tecnológico de Costa Rica
// Engineer: Juan José Rojas Salazar
// 
// Create Date: 30.07.2016 10:22:05 
// Design Name: 
// Module Name: Coprocesador_CORDIC 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description:  
//					
//////////////////////////////////////////////////////////////////////////////////

module Coprocesador_CORDIC #(parameter P = 32, parameter S=8, parameter D=5, parameter W_Exp = 8, parameter W_Sgf = 23,
		parameter S_Exp = 9) (
   
    //INPUTS
    input wire [31:0] T,
    input wire CLK,                 //RELOJ DEL SISTEMA
    input wire RST,                 //RESET PARA LOS REGISTROS 
    input wire MS_1,                //SELECCION DEL MUX 1 VALOR INICIAL DE Z 
    input wire EN_REG3,             //ENABLE REG 3 VALOR INIICIAL ESCALADO POR 16
    input wire EN_REG4,             //ENABLE REG 4 RESULTADO FINAL 
    input wire ADD_SUBT,            //SELECCION DE OPERACION PARA EL ADD/SUBT FLOTANTE 
    input wire Begin_SUMX,          //INICIA LA OPERACION EN ADD/SUBT FLOTANTE x
    input wire Begin_SUMY,          //INICIA LA OPERACION EN ADD/SUBT FLOTANTE Y
    input wire Begin_SUMZ,          //INICIA LA OPERACION EN ADD/SUBT FLOTANTE Z 
    input wire EN_REG1X,            //ENABLE PARA EL REGISTRO X DE LA PRIMERA ETAPA 
    input wire EN_REG1Z,            //ENABLE PARA EL REGISTRO Z DE LA PRIMERA ETAPA
    input wire EN_REG1Y,            //ENABLE PARA EL REGISTRO Y DE LA PRIMERA ETAPA
    input wire MS_2,                //SELECCION MUX 2
    input wire MS_3,                //SELECCION MUX 3
    input wire EN_REG2,             //ENABLE PARA EL REGISTRO QUE GUARDA LOS VALORES DESPLAZADOS EN LA SEGUNDA ETAPA
    input wire CLK_CDIR,            //CLK PARA EL CONTADOR DE ITERACIONES 
    input wire EN_REG2XYZ,          //ENABLE PARA EL REGISTRO QUE GUARDA EL VALOR ANTERIOR DE XYZ 
    
    //OUTPUTS
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
    
    //salidas mux MS_1 a REG1Z 
    wire [P-1:0] MUX1; 
    
    //salidas registros 1 a mux MS_2, signo y desplazador de exponente
    wire [P-1:0] X_ant; 
    wire [P-1:0] Y_ant;
    wire [P-1:0] Z_ant;  
        
    //salidas de exponentes con calculo de desplazamiento desde la LUT  
    wire [S-1:0] EXP_X;
    wire [S-1:0] EXP_Y;
    
    //salida LUT valores arctan 
    wire [P-1:0] LUT_arctan; 
      
    //salida CONTADOR DE ITER A LUT'S
    wire [D-1:0] DIR_LUT;
       
    //salida de signos
    wire SIGNO_X;
    wire SIGNO_Y;
    wire SIGNO_Z;
    
    //SIGNO + EXPONENTE + MANTISA
    wire [P-1:0] X_act; 
    wire [P-1:0] Y_act;
    wire [P-1:0] Z_act;
    
    //salidas registros 2 a mux de sumadores punto flotante, signo y desplazador de exponente
    wire [P-1:0] REG2X; 
    wire [P-1:0] REG2Y;
    wire [P-1:0] REG2Z; 
    wire [P-1:0] REG2Xa;
    wire [P-1:0] REG2Ya;
    wire [P-1:0] REG2Za;
    wire [D-1:0] DESP; 
    
    //salida exponente T a REG3
    wire [S-1:0] EXP_T; 
    wire [P-1:0] T_SUM;  
    
    //salida REG3 a MUX Xa y MUX Ya
    wire [P-1:0] REG3;
    
    //salidas mux MS_1 a REG1Z 
    wire [P-1:0] MUX1Xa;
    wire [P-1:0] MUX2Xb;
    wire [P-1:0] MUX1Ya;
    wire [P-1:0] MUX2Yb;   
    wire [P-1:0] MUX1Za;
    wire [P-1:0] MUX2Zb;
    
    //resultado ADD/SUBT flotante X,Y,Z 
    wire [P-1:0] X_RESULT;
    wire [P-1:0] Y_RESULT;
    wire [P-1:0] Z_RESULT;
    
    // ASIGNA VALOR DE LA ITERACION A LA DIRECCION DE LAS LUT 
    assign CONT_ITERA = DIR_LUT;
    
Mux_2x1 #(.P(P)) MUX2x1_1 ( 
    .MS(MS_1), 
    .D_0(Z_RESULT), 
    .D_1(32'b00000000000000000000000000000000), //0 CONSTANTE INICIAL DE Z0
    .D_out(MUX1)
    );

FF_D #(.P(P)) REG1_X ( 
    .CLK(CLK), 
    .RST(RST),
    .EN(EN_REG1X), 
    .D(X_RESULT), 
    .Q(X_ant)
    );

FF_D #(.P(P)) REG1_Y ( 
    .CLK(CLK), 
    .RST(RST),
    .EN(EN_REG1Y), 
    .D(Y_RESULT), 
    .Q(Y_ant)
    );
    
FF_D #(.P(P)) REG1_Z ( 
    .CLK(CLK), 
    .RST(RST),
    .EN(EN_REG1Z), 
    .D(MUX1), 
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
    );                              //registros nuevos
      
COUNTER_5B #(.P(D)) CONT_ITER ( 
    .CLK(CLK), 
    .RST(RST),
    .EN(CLK_CDIR),  
    .Y(DIR_LUT)
    );
                                              
LUT_SHIFT #(.P(D)) LUT_ITER ( 
    .CLK(CLK),
    .EN_ROM1(1'b1), 
    .ADRS(DIR_LUT), 
    .O_D(DESP)
    );                        

LUT_Z #(.P(P),.D(D)) LUT_ARCTAN (   //LUT DE VALORES DE Z 
    .CLK(CLK),
    .EN_ROM1(1'b1), 
    .ADRS(DIR_LUT), 
    .O_D(LUT_arctan)
    );    

S_SUBT #(.P(S),.W(5)) SUB_EXP_X ( 
    .A(X_ant[30:23]), 
    .B(DESP), 
    .Y(EXP_X)
    );
    
S_SUBT #(.P(S),.W(5)) SUB_EXP_Y ( 
    .A(Y_ant[30:23]), 
    .B(DESP), 
    .Y(EXP_Y)
    );        
    
SIGN SIGNXYZ (
    .SIGN_X0(X_ant[31]),
    .SIGN_Y0(Y_ant[31]),
    .SIGN_Z0(LUT_arctan[31]),
    .SIGN_X(SIGNO_X),
    .SIGN_Y(SIGNO_Y),
    .SIGN_Z(SIGNO_Z)
    );
 
assign X_act[31] = SIGNO_Y;
assign X_act[30:23] = EXP_Y;
assign X_act[22:0] = Y_ant[22:0];

assign Y_act[31] = SIGNO_X;
assign Y_act[30:23] = EXP_X;
assign Y_act[22:0] = X_ant[22:0];

assign Z_act[31] = SIGNO_Z;
assign Z_act[30:0] = LUT_arctan[30:0];

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
    
S_ADD #(.P(S)) ADD_EXP_T (                      //SUMA DE 4 AL EXPONENTE PARA CORRIMIENTO DEL RANGO
    .A(T[30:23]), 
    .B(5'b00100),               
    .Y(EXP_T)
     );

assign T_SUM [31] = T [31];
assign T_SUM[30:23] = EXP_T;
assign T_SUM[22:0] = T[22:0];

FF_D #(.P(P)) REG_3 ( 
    .CLK(CLK), 
    .RST(RST),
    .EN(EN_REG3), 
    .D(T_SUM), 
    .Q(REG3)
    ); 
         
Mux_2x1 #(.P(P)) MUX2x1_Xa ( 
    .MS(MS_2), 
    .D_0(REG2Xa), 
    .D_1(REG3), 
    .D_out(MUX1Xa)
    ); 
    
Mux_2x1 #(.P(P)) MUX2x1_Xb ( 
    .MS(MS_2), 
    .D_0(REG2X), 
    .D_1(32'b00111111100000000000000000000000), //1 EN PUNTO FLOTANTE
    .D_out(MUX2Xb)
    );    
    
Mux_2x1 #(.P(P)) MUX2x1_Ya ( 
    .MS(MS_2), 
    .D_0(REG2Ya), 
    .D_1(REG3), 
    .D_out(MUX1Ya)
    ); 
    
Mux_2x1 #(.P(P)) MUX2x1_Yb ( 
    .MS(MS_2), 
    .D_0(REG2Y), 
    .D_1(32'b10111111100000000000000000000000), //-1 EN PUNTO FLOTANTE
    .D_out(MUX2Yb)
    ); 

Mux_2x1 #(.P(P)) MUX2x1_Za ( 
    .MS(MS_3), 
    .D_0(REG2Za), 
    .D_1(Z_ant), 
    .D_out(MUX1Za)
    ); 
    
Mux_2x1 #(.P(P)) MUX2x1_Zb ( 
    .MS(MS_3), 
    .D_0(REG2Z),
    .D_1(32'b11000000001100010111001000011000), //LN(16) EN PUNTO FLOTANTE
    .D_out(MUX2Zb)
    );     
                                 
FPU_Add_Subtract_Function #(.W(32),.EW(8),.SW(23),.SWR(26), .EWR(5)) SUM_SUBTX(
    .clk(CLK),
    .rst(RST),
    .beg_FSM(Begin_SUMX),
    .ack_FSM(ACK_SUMX),
    .Data_X(MUX1Xa),
    .Data_Y(MUX2Xb),
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
    .Data_X(MUX1Ya),
    .Data_Y(MUX2Yb),
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
    .Data_X(MUX1Za),
    .Data_Y(MUX2Zb),
    .add_subt(ADD_SUBT),
    .r_mode(2'b00),
    .overflow_flag(O_FZ),
    .underflow_flag(U_FZ),
    .ready(ACK_SUMZ),
    .final_result_ieee(Z_RESULT)
    );
		
FF_D #(.P(P)) REG_4 ( 
    .CLK(CLK), 
    .RST(RST),
    .EN(EN_REG4), 
    .D(Z_RESULT), 
    .Q(RESULT)
    );
                    
endmodule
