`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2024 16:58:16
// Design Name: 
// Module Name: debouncer
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


module debouncer(input CLOCK_100MHZ, input button, output reg debounced_signal = 0, output reg move_time);
parameter counter_ticks = 20000000;
reg [31:0] COUNTER = 0;
reg [31:0] COUNTER_RELEASE = 0;
reg button_pressed = 0;
reg button_released = 0;

always @ (posedge CLOCK_100MHZ) begin
    
    if (button && ~button_pressed) begin
        button_pressed <= 1;
    end
    if (button_pressed && ~button_released) begin
        if(COUNTER <= counter_ticks) begin
            COUNTER <= COUNTER + 1;
        end
        debounced_signal <= 1;
        move_time <= 1;
    end
    //debouncing the button release signal
    if(~button & button_pressed && COUNTER >= counter_ticks) begin
        button_released <= 1;
    end
    if(button_released) begin

        COUNTER_RELEASE <= 0;
        button_pressed <= 0;
        button_released <= 0;
        COUNTER <= 0;
        COUNTER_RELEASE <= 0;
        debounced_signal <= 0;
        move_time <= 0;
    end

end
endmodule
