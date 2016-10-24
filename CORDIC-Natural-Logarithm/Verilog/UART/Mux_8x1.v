`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tecnológico de Costa Rica
// Engineer: Mauricio Carvajal Delgado
// 
// Create Date: 03.17.2013 10:36:22
// Design Name: 
// Module Name: Mux_8x1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module Mux_8x1(

    //INPUTS
    input wire [2:0] select,
    input wire [7:0] ch_0,
    input wire [7:0] ch_1,
    input wire [7:0] ch_2,
    input wire [7:0] ch_3,
    input wire [7:0] ch_4,
    input wire [7:0] ch_5,
    input wire [7:0] ch_6,
    input wire [7:0] ch_7,
    //OUTPUTS
    output reg [7:0] data_out
    );

    always @*
        begin
            case(select)
                3'b111: data_out = ch_0;
                3'b110: data_out = ch_1;
                3'b101: data_out = ch_2;
                3'b100: data_out = ch_3;
                3'b011: data_out = ch_4;
                3'b010: data_out = ch_5;
                3'b001: data_out = ch_6;
                3'b000: data_out = ch_7;
                default : data_out = ch_0;
            endcase
        end
        
endmodule