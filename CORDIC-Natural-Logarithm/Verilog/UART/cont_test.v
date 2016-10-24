`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tecnológico de Costa Rica
// Engineer: Mauricio Carvajal Delgado
// 
// Create Date: 03.17.2013 10:36:22
// Design Name: 
// Module Name: cont_test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module cont_test #(parameter W=4)(
    
    //INPUTS
    input wire clk,
    input wire rst,
    input wire load,
    input wire enable,
    input wire [W-1:0] d,
    //OUTPUTS
    output wire max_tick,
    output wire min_tick,
    output wire [W-1:0] q
    );

    reg [W-1:0] count;

    always @(posedge clk, posedge rst)
    begin
        if (rst)
            count <= 0;
        else if (enable)
        begin
            if (load)
            begin
                count <= d;
            end
            else
                count <= count + 1'b1;
        end
    end

    assign q = count;
    assign max_tick = (count == 2**W-1) ? 1'b1 : 1'b0;
    assign min_tick = (count == 0) ? 1'b1 : 1'b0;

endmodule
