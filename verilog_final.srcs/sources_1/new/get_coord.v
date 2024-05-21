`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2024 17:23:35
// Design Name: 
// Module Name: get_coord
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


module get_coord(
    input [12:0] p_idx,
    output [12:0] X,
    output [12:0] Y
    );
    
    assign X = p_idx % 96;
    assign Y = p_idx / 96;
    
endmodule
