`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2024 12:24:41 PM
// Design Name: 
// Module Name: collision_p
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


module collision_p(input [7:0] p1_x, p2_x, output contacted);
    
    assign contacted = (p1_x + 10) >= p2_x ? 1 : 0;
  
endmodule
