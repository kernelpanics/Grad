`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tecnológico de Costa Rica
// Engineer: Juan José Rojas Salazar 
// 
// Create Date: 30.07.2016 10:22:05 
// Design Name: 
// Module Name: Convert_Float_To_Fixed
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module Convert_Float_To_Fixed(
    
    //INPUTS
    input wire CLK,                 //CLOCK 
    input wire [31:0] FLOAT,        //VALOR DEL NUMERO EN PUNTO FLOTANTE 
    input wire EN_REG1,             //ENABLE PARA EL REGISTRO 1 QUE GUARDA EL NUMERO EN PUNTO FLOTANTE 
    input wire LOAD,                //SELECCION CARGA REGISTRO DE DESPLZAMIENTOS  
    input wire MS_1,                //SELECCIONA EL MUX PARA UN VALOR DIFERENTE O IGUAL A 127 SEGUN SEA EL CASO 
    input wire RST,
    input wire EN_REG2,
    //OUTPUTS
    output wire Exp_out,            //INIDICA SI EL EXPONENTE ES MAYOR QUE 127 
    output wire [31:0] FIXED,       //CONTIENE EL RESULTADO EN COMA FIJA  
    output wire [7:0] Exp           //CONTIENE EL VALOR INICIAL DEL EXPONENTE 
    );

    parameter P = 32;
    parameter W = 8;
    wire [31:0] float; 

FF_D #(.P(P)) REG_FLOAT_I ( 
    .CLK(CLK), 
    .RST(RST),
    .EN(EN_REG1), 
    .D(FLOAT), 
    .Q(float)
    );

Comparador_Mayor EXP127_I(
    .CLK(CLK),
    .A(float[30:23]),
    .B(8'b01111111),
    .Out(Exp_out)
    );

    wire [31:0] IN_BS;
    wire [31:0] P_RESULT;
    wire [31:0] MUX32;
    wire [31:0] MUX32_OUT; 
    wire [31:0] NORM;
    wire [7:0] MUX1;
    wire [7:0] MUX2;
    wire [7:0] SUBT_1;
    wire [7:0] SUBT_2;

    assign IN_BS [31:27] = 5'b00000;
    assign IN_BS [26] = 1'b1;  
    assign IN_BS [25:3] = float[22:0];
    assign IN_BS [2:0] = 3'b000;
    assign Exp = float[30:23];

Barrel_Shifter #(.SWR(32),.EWR(8)) S_REG_I(
    .clk(CLK),
    .rst(RST),
    .load_i(LOAD),
    .Shift_Value_i(MUX2),
    .Shift_Data_i(IN_BS),
    .Left_Right_i(Exp_out),
    .Bit_Shift_i(1'b0),
    .N_mant_o(P_RESULT)
    );
    
S_SUBT #(.P(W),.W(W)) SUBT_EXP_1_I ( 
    .A(float[30:23]), 
    .B(8'b01111111), 
    .Y(SUBT_1)
     );

S_SUBT #(.P(W),.W(W)) SUBT_EXP_2_I ( 
    .A(8'b01111111), 
    .B(float[30:23]), 
    .Y(SUBT_2)
     );
         
Mux_2x1_8Bits MUX2x1_1_I ( 
    .MS(Exp_out), 
    .D_0(SUBT_2), 
    .D_1(SUBT_1), 
    .D_out(MUX1)
    );

Mux_2x1_8Bits MUX2x1_2_I ( 
    .MS(MS_1), 
    .D_0(8'b00000000), 
    .D_1(MUX1), 
    .D_out(MUX2)
    );
              
SUBT_32Bits SUBT_RESULT_I ( 
    .A(32'b00000000000000000000000000000000), 
    .B(P_RESULT), 
    .Y(MUX32)
     );

Mux_2x1 #(.P(P)) MUX2x1_32Bits ( 
    .MS(float[31]), 
    .D_0(P_RESULT), 
    .D_1(MUX32), 
    .D_out(MUX32_OUT)
    );

FF_D #(.P(P)) REG_FIXED ( 
    .CLK(CLK), 
    .RST(RST),
    .EN(EN_REG2), 
    .D(MUX32_OUT), 
    .Q(FIXED)
    );

endmodule