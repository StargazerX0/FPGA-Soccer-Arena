`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2024 02:08:38 PM
// Design Name: 
// Module Name: collision_ball
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


module collision_ball(input [7:0] p1_x, p1_y, p2_x, p2_y, ball_x, ball_y, 
    output l_c, r_c, u_c, d_c, sandwich_p1p2, sandwich_p2p1, sandwich_g1, sandwich_g2);
    wire [7:0] p1_left, p1_right, p1_up, p1_down;
    wire [7:0] p2_left, p2_right, p2_up, p2_down;
    wire [7:0] ball_left, ball_right, ball_up, ball_down;
    assign p1_left = p1_x;
    assign p1_right = p1_x + 10;
    assign p1_up = p1_y;
    assign p1_down = p1_y + 18;
    assign p2_left = p2_x;
    assign p2_right = p2_x + 10;
    assign p2_up = p2_y;
    assign p2_down = p2_y + 18;
    assign ball_left = ball_x - 2;
    assign ball_right = ball_x + 2;
    assign ball_up = ball_y - 2;
    assign ball_down = ball_y + 2;
    
    assign l_c =  ((ball_left <= p1_right && ball_down >= p1_up && ball_left > p1_left) ||
                    (ball_y == 29 && ball_left <= 6) ||
                    (ball_left <= 0) ||
                    (ball_left <= p2_right && ball_down >= p2_up && ball_left > p2_left)) ? 1 : 0;
                    
    assign r_c =  ((ball_right >= p1_left && ball_down >= p1_up && ball_right < p1_right) ||
                    (ball_y == 29 && ball_right >= 90) ||
                    (ball_right >= 96) ||
                    (ball_right >= p2_left && ball_down >= p2_up && ball_right < p2_right)) ? 1 : 0;
                    
    assign u_c =  ((ball_up <= p1_down && ball_x <= p1_right && ball_x >= p1_left && ball_y > p1_down) ||
                    (ball_up <= 0) ||
                    (ball_up <= p2_down && ball_x <= p2_right && ball_x >= p2_left && ball_y > p2_down)) ? 1 : 0;
                                        
    assign d_c =  ((ball_down >= p1_up && ball_x <= p1_right && ball_x >= p1_left && ball_y < p1_up) ||
                    (ball_down >= 64) ||
                    (ball_down >= p2_up && ball_x <= p2_right && ball_x >= p2_left && ball_y < p2_up)) ? 1 : 0;
                    
    assign sandwich_p1p2 = ((ball_left <= p1_right && ball_up >= p1_up && ball_left > p1_left) &&
                            (ball_right >= p2_left && ball_up >= p2_up && ball_right < p2_right)) ? 1 : 0;
    assign sandwich_p2p1 = ((ball_left <= p2_right && ball_up >= p2_up && ball_left > p2_left) &&
                            (ball_right >= p1_left && ball_up >= p1_up && ball_right < p1_right)) ? 1 : 0;
    assign sandwich_g1 = ((ball_up <= p1_down && ball_x <= p1_right && ball_x >= p1_left && ball_down > p1_down) && ball_down >= 64) ? 1 : 0;
    assign sandwich_g2 = ((ball_up <= p2_down && ball_x <= p2_right && ball_x >= p2_left && ball_down > p2_down) && ball_down >= 64) ? 1 : 0;
endmodule
