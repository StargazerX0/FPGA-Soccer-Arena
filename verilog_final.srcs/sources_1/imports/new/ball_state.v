`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2024 02:58:20 PM
// Design Name: 
// Module Name: ball_state
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


module ball_state(input slow_clk, rst, l_c, r_c, u_c, d_c, 
    output reg [2:0] movement_state = 0);
    
    always @ (posedge slow_clk) begin
        if (!rst) begin
           if (r_c && !l_c) begin
                movement_state[2] <= 1;
                movement_state[0] <= 0;
           end else if (l_c && !r_c) begin
                movement_state[0] <= 1;
                movement_state[2] <= 0;
           end else if (l_c && r_c) begin
                movement_state[0] <= 0;
                movement_state[2] <= 0;
           end else begin
                movement_state[2] <= movement_state[2];
                movement_state[0] <= movement_state[0];
           end
           
           if (d_c && !u_c) begin
                movement_state[1] <= 1;
           end else if (u_c && !d_c) begin
                movement_state[1] <= 0;
           end else begin
                movement_state[1] <= movement_state[1];
           end
        end
        else begin
            movement_state <= 3'b000;//STOP;
        end
    end
endmodule