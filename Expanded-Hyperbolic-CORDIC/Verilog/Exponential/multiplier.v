`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tecnológico de Costa Rica
// Engineer: Juan José Rojas Salazar
// 
// Create Date: 10/22/2016 08:49:25 PM
// Design Name: 
// Module Name: multiplier
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Floating Point Multiplier
// 
//////////////////////////////////////////////////////////////////////////////////

module FP_Mul #(parameter P=32, biasSP=8'd127)(
	
	input wire clk,
	input wire [P-1:0] a,       //Dato entrada x
	input wire [P-1:0] b,       //Dato entrada y
	output wire [P-1:0] p       //Dato de Salida
	);
	
	wire [22:0] am, bm; 	    //Mantisa de entrada
	wire [7:0] ae,be;           //exponente de salida
	
	assign am = a[22:0];
	assign bm = b[22:0];
	assign ae = a[30:23];
	assign be = b[30:23];
	
	reg [22:0] pm;		 	    //Mantisa de salida
	reg [7:0] pe;			    //Exponente salida
    	                         
	//Registros internos
	reg [47:0] pmTemp;		    //Mantisa
	reg [7:0] peTemp;	      	    //Exponente
	reg [22:0] sm;			    //Mantisa después de desplazamiento
	reg [23:0] xm;			    //Redondeo/Incremento
	
    always@*
    begin
        pmTemp = {1'b1,am}*{1'b1,bm};                    //Multiplicación mantisas
        peTemp = (ae+be)-biasSP;                         //Suma de exponentes y resta del valor de bias
        xm = pmTemp[47] ? pmTemp[46:24] : pmTemp[45:23]; //Asignar mantisa
        pe = pmTemp[47] ? peTemp+1 : peTemp;             //Asignar exponente
        pm = xm[22:0];                                   //Mantisa salida
        pe = xm[23] ? pe+1 : pe;                         //Exponente salida
	end
	
	assign p = {(a[31]^b[31]),{pe,pm}};              //Concatenación signo+exponente+mantisa

endmodule
