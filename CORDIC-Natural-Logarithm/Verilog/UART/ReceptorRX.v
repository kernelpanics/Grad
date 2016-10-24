`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tecnológico de Costa Rica
// Engineer: Mauricio Carvajal Delgado
// 
// Create Date: 03.17.2013 10:36:22
// Design Name: 
// Module Name: ReceptorRX 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Modulo receptor
//					
//////////////////////////////////////////////////////////////////////////////////

module ReceptorRX(
    
    //INPUTS
    input wire MCLK,RST,tick_clk,RX,
    //OUTPUTS
    output wire [7:0]DATAOUT,
    output wire RX_Done
    );
 
    //wire
	wire [7:0] rxdata;
	
	//Buffer para modulo receptor---> se puede crear un submodulo buffer receptor
	UBuffer RX_Buffer(.clk(MCLK),.rst(RST),.r_data(rx_ready),.datain(rxdata),.dataout(DATAOUT),.ready(RX_Done));
    
    //Receptor RX
	Receptor RX_Receptor(.clk(MCLK),.reset(RST),.rx(RX),.s_tick(tick_clk),.rx_done_tick(rx_ready),.dout(rxdata));
	
endmodule
