`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2024 10:01:33 AM
// Design Name: 
// Module Name: movement_state
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


module movement_state(input slow_clk, rst, btnC, btnL, btnU, btnR, 
    output reg [2:0] movement_state = 0);
    
    always @ (posedge slow_clk) begin
        if (!rst) begin
            if (btnL) begin
                movement_state[2] <= 1;
            end else begin
                movement_state[2] <= 0;
            end
            if (btnU) begin
                movement_state[1] <= 1;
            end else begin
                movement_state[1] <= 0;
            end
            if (btnR) begin
                movement_state[0] <= 1;
            end else begin
                movement_state[0] <= 0;
            end
        end
        else begin
            movement_state <= 3'b000;
        end
    end
endmodule
