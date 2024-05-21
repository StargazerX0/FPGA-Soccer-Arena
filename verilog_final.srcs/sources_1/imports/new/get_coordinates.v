`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2024 09:47:20 AM
// Design Name: 
// Module Name: get_coordinates
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module get_coordinates(input [12:0] pixel_index, output [7:0] x, y);
    assign x = pixel_index % 96;
    assign y = pixel_index / 96;
endmodule