`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tecnológico de Costa Rica
// Engineer: Mauricio Carvajal Delgado
// 
// Create Date: 03.17.2013 10:36:22
// Design Name: 
// Module Name: Uart 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Interfaz UART
//					
//////////////////////////////////////////////////////////////////////////////////

module Uart( 

    //INPUTS
    input wire RST,CLK,RX,TX_START,
	input wire [7:0] TX_DATA,
	//OUTPUTS
	output wire [7:0] RX_DATA,
    output wire RX_DONE,TX,TX_DONE
    );
 
    //WIRES
	wire Tclk;										//salida del contador

    //Contador	 
	Coun_Baud ICONT(.clk(CLK), .reset(RST), .max_tick(Tclk));
    
    //Receptor RX
    ReceptorRX IRECEPTOR (.MCLK(CLK), .RST(RST), .tick_clk(Tclk), .RX(RX), .DATAOUT(RX_DATA), .RX_Done(RX_DONE));
    
    //Transmisor TX
    Transmisor_TX ITRANSMISOR(.RST(RST), .CLK(CLK), .TX_Start(TX_START), .DATAIN(TX_DATA), .s_tick(Tclk), .TX(TX), .TX_Done(TX_DONE));

endmodule
