`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tecnológico de Costa Rica
// Engineer: Mauricio Carvajal Delgado
// 
// Create Date: 03.17.2013 10:36:22
// Design Name: 
// Module Name: Transmisor_TX 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Transmisor_TX
//					
//////////////////////////////////////////////////////////////////////////////////

module Transmisor_TX(
    
    //INPUTS
    input wire RST,CLK,TX_Start,
    input wire [7:0] DATAIN,
    input wire s_tick,
    //OUTPUTS
    output wire TX,TX_Done
    );
	 
	//wires
	wire WTX_Start;
	wire [7:0] WDATAIN;

    UBuffer TX_Buffer (.clk(CLK), .rst(RST), .r_data(TX_Start), .datain(DATAIN), .dataout(WDATAIN), .ready(WTX_Start));	 
    Transmisor TXTrasmisor (.clk(CLK), .reset(RST), .tx_start(WTX_Start), .s_tick(s_tick), .din(WDATAIN), .TX_Done(TX_Done), .tx(TX));

endmodule
