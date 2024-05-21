`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2024 11:34:48 AM
// Design Name: 
// Module Name: centre_button_detector
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


module centre_button_detector(input slow_clk, btnC, output reg btnC_pressed = 0);
    reg [5:0] counter = 0;
    
    always @ (posedge slow_clk) begin
        btnC_pressed <= (btnC ? 1 : btnC_pressed);
        // For debouncing
//        counter <= (counter >= 1 || counter == 20) ? 0 : counter + 1;
//        if (btnC) begin
//            counter <= (counter == 0) ? 1 : counter + 1;
//            btnC_pressed = (counter == 0) ? ~btnC_pressed : btnC_pressed;
//        end
//        btnC_pressed <= (counter == 20) ? ~btnC_pressed : btnC_pressed;
        
    end
endmodule
