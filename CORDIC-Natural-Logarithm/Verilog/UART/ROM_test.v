`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  Tecnológico de Costa Rica
// Engineer: Juan José Rojas Salazar
// 
// Create Date: 30.07.2016 10:22:05 
// Design Name: 
// Module Name: ROM_test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//////////////////////////////////////////////////////////////////////////////////

module ROM_test #(parameter W=32)(
    
    input wire [9:0] address,
    output reg [W-1:0] data
    );

    localparam ROM_FILE32 = "/home/carlos/Documents/0.0066777-0.58495_HEX.txt";
    localparam ROM_FILE64= "C:/Users/XXXXX/Desktop/RTL/NORMALIZACION_V.txt";
    
    //(* rom_style="{distributed | block}" *)
    reg [W-1:0] rom_test [1023:0];

    generate
        if(W==32)
            initial
                begin
                    $readmemh( ROM_FILE32 , rom_test, 0, 1023);
                end
        else
            initial
                begin
                    $readmemh(ROM_FILE64, rom_test, 0, 1023);
                end
    endgenerate

    always @*
    begin
        data = rom_test[address];
    end

endmodule
