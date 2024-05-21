`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2024 02:55:28 PM
// Design Name: 
// Module Name: ball_pos
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


module ball_pos(input slow_clk, rst, input [2:0] movement_state, input [7:0] curr_xstart, curr_ystart,
output reg [7:0] new_xstart = 48, new_ystart = 20);
    
    always @ (posedge slow_clk) begin
        if (rst) begin
            new_xstart <= 48;
            new_ystart <= 20;
        end else begin
            if (movement_state[0] == 1) begin
                new_xstart <= curr_xstart + 1;
            end else if (movement_state[2] == 1) begin
                new_xstart <= curr_xstart - 1;
            end else begin
                new_xstart <= new_xstart;
            end
            
            if (movement_state[1] == 1) begin
                new_ystart <= curr_ystart - 1;
            end else begin
                new_ystart <= curr_ystart + 1;
            end
        end
    end
endmodule
