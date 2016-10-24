`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tecnológico de Costa Rica
// Engineer: Mauricio Carvajal Delgado
// 
// Create Date: 03.17.2013 10:36:22
// Design Name: 
// Module Name: UBuffer
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//					
///////////////////////////////////////////////////////////////////////////////////

module UBuffer(
    
    //INPUTS
    input wire clk,rst,r_data,
    input wire [7:0] datain,
    //OUTPUTS
    output wire [7:0]dataout,
    output wire ready
    );	
	
	//registros
	reg [7:0] datos=0;
	reg listo=0;
	
	always@(posedge clk) begin
		if (rst) begin
			datos<=8'b00000000;
			listo<=1'b0;
			end
		else if(r_data) begin
			datos<=datain;
			listo<=1'b1;
			end
		else
			listo<=1'b0;
		end
		
	assign dataout=datos;
	assign ready=listo;

endmodule
