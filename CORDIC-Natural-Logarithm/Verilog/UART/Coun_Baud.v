`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tecnológico de Costa Rica
// Engineer: Mauricio Carvajal Delgado
// 
// Create Date: 03.17.2013 10:36:22
// Design Name: 
// Module Name: Coun_Baud 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Contador de Bauds, lo que genera es un tick
//
//////////////////////////////////////////////////////////////////////////////////

module Coun_Baud#(parameter N=10, M=656)(  // este modo es para generar los pulsos necesarios para el modo receptor y transmisor

     //N= number of bits incounter = log2(M)
	 // mod-M Para una frecuencia de relog 100 MHZ --->9600bauds
	 // M se obtiene de 100MHZ/(2X8X9600)
	
	//INPUTS
	input wire clk, reset,
	//OUTPUTS
	output wire max_tick
	);
	
	// Declaracion de Señales
	reg [N-1:0] r_reg=0;
	wire [N-1:0] r_next;

	// Registro de estado
	always @ (posedge clk , posedge reset)
		if (reset)
			r_reg <= 0 ;
		else
			r_reg <= r_next;
			
	// Logica de estado siguiente
	assign r_next = (r_reg==(M-1)) ? 0 : r_reg + 1;
	
	//Logica de salida
	assign max_tick = (r_reg==(M-1)) ? 1'b1 : 1'b0;

endmodule
