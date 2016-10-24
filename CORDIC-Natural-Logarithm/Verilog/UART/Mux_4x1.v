`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tecnológico de Costa Rica
// Engineer: Mauricio Carvajal Delgado
// 
// Create Date: 03.17.2013 10:36:22
// Design Name: 
// Module Name: Mux_4x1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module Mux_4x1(

    //INPUTS
    input wire [1:0] select,
    input wire [7:0] ch_0,
    input wire [7:0] ch_1,
    input wire [7:0] ch_2,
    input wire [7:0] ch_3,
    //OUTPUTS
    output reg [7:0] data_out
    );

    always @*
        begin
            case(select)
                2'b11: data_out = ch_0;
                2'b10: data_out = ch_1;
                2'b01: data_out = ch_2;
                2'b00: data_out = ch_3;
                default : data_out = ch_0;
            endcase
        end

endmodule