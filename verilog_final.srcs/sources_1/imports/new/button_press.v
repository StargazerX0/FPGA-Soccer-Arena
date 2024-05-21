`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2024 12:07:09 PM
// Design Name: 
// Module Name: button_press
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


module button_press(input clk, pb, inAir, input [16:0] debounce, output reg pb_pressed = 0);
    reg [16:0] counter = 0;
    
    always @ (posedge clk) begin
        if (pb && counter == 0 && !inAir) begin
            pb_pressed <= 1;
            counter <= counter + 1;
        end
        
        if (counter != 0) begin
            counter <= counter + 1;
        end
        
        if (counter == debounce) begin
            counter <= 0;
            pb_pressed <= 0;
        end
    end
endmodule
