`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.04.2024 10:06:11
// Design Name: 
// Module Name: match_counter
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


module match_counter(input clk, input [4:0] state, output reg [5:0] count = 60, led, output reg match_over = 0);
    reg [2:0] led_index = 5;
    always @ (posedge clk) begin
        if (state >= 3) begin
            count <= (count > 0) ? count - 1 : count;
            match_over <= (count == 0) ? 1 : 0;
            if ((count < 60) && ((count % 10) == 0)) begin
                led[led_index] <= 0;
                led_index <= (led_index > 0) ? led_index - 1 : 0;
            end
        end
        else begin
            count <= 60;
            match_over <= 0;
            led <= 6'b111111;
            led_index <= 5;
        end
    end
endmodule
