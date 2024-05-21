`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2024 16:15:06
// Design Name: 
// Module Name: my_clock
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


module my_clock(
    input clock,
    input [31:0] m,
    output reg s_clock = 0
    );
    
    reg [31:0] count = 0; 
                    
    always @ (posedge clock) begin
        count <= (count == m) ? 0 : count + 1;
        s_clock <= (count == 0) ? ~s_clock : s_clock;
    end  
    
endmodule
