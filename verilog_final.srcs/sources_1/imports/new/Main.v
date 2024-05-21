`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2024 09:43:07 AM
// Design Name: 
// Module Name: Main
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


module Main(input basys3_clk, sw1, sw2, reset, btnC, btnL, btnU, btnR, player2_C, player2_L, player2_U, player2_R, input [2:0] player1, input [2:0] player2, output [7:0] JC,
    output reg [3:0] p1_count = 0, output reg [3:0] p2_count = 0);
    // 6.25MHz clock for Oled
    reg [15:0] background [0:6143];
    reg [15:0] ps0 [0:6143];
    reg [15:0] ps1 [0:6143];
    reg [15:0] ani0_mem [0:6143];
    reg [15:0] ani3_mem [0:6143];
    reg [15:0] ani5_mem [0:6143];
    initial begin
        $readmemh("background_mem.mem", background);
        $readmemh("ps0.mem", ps0);
        $readmemh("ps1.mem", ps1);
        $readmemh("ani0.mem", ani0_mem);
        $readmemh("ani3.mem", ani3_mem);
        $readmemh("ani5.mem", ani5_mem);
    end
    
    wire clk_6p25m;
    slow_clock clock_6p25m(basys3_clk, 7, clk_6p25m);
    
    // 25MHz clock for operation
    wire clk_25m;
    slow_clock clock_25m(basys3_clk, 1, clk_25m);
    
    // 1kHz clock for pushbutton detection
    wire clk_1k;
    slow_clock clock_1k(basys3_clk, 49999, clk_1k);
    
    // Clocks for square animation
    wire clk_60hz, clk_45hz, clk_30hz, clk_15hz, clk_3hz;
    slow_clock clock_60hz(basys3_clk, 833332, clk_60hz);
    slow_clock clock_45hz(basys3_clk, 1111110, clk_45hz);
    slow_clock clock_30hz(basys3_clk, 1666665, clk_30hz);
    slow_clock clock_15hz(basys3_clk, 3333332, clk_15hz);
    slow_clock clock_3hz(basys3_clk, 16666665, clk_3hz);
    
    // Oled display module instantiation
    reg [15:0] pixel_data = 16'b00000_000000_00000;
    wire frame_begin, sending_pixels, sample_pixel;
    wire [12:0] pixel_index;
    
    Oled_Display unit_oled(
        .clk(clk_6p25m),
        .reset(0),
        .frame_begin(frame_begin),
        .sending_pixels(sending_pixels),
        .sample_pixel(sample_pixel),
        .pixel_index(pixel_index),
        .pixel_data(pixel_data),
        .cs(JC[0]),
        .sdin(JC[1]),
        .sclk(JC[3]),
        .d_cn(JC[4]),
        .resn(JC[5]),
        .vccen(JC[6]),
        .pmoden(JC[7]));
    
    // Coordinates module instantiation
    wire [7:0] x, y;
    get_coordinates coordinates(pixel_index, x, y);
    
    // Centre push button detector module instantiation
    wire btnU_d, u2;
    reg inAir, inAir2 = 0;
    button_press ub1(clk_1k, btnU, inAir, 666, btnU_d);
    button_press ub2(clk_1k, player2_U, inAir2, 666, u2);
    //button_press rb(clk_1k, btnR, 0, btnR_d);
    //button_press ub(clk_1k, btnU, 0, btnU_d);
      
    
    
    // Movement state module instantiation
    wire [2:0] move_state_p1;
    wire [2:0] move_state_p2;
    wire [2:0] move_state_ball;
    wire p_contacted, l_c, r_c, u_c, d_c, sandwich_p1p2, sandwich_p2p1, sandwich_g1, sandwich_g2;

//    reg rst = 0;
//    always @ (posedge basys3_clk) begin
//        if (rst_player1 || rst_player2) begin
//            rst <= 1;
//        end
//        else begin
//            rst <= 0;
//        end
//    end
    
    wire rst;
    
    movement_state sq_move_state(
        .slow_clk(clk_1k),
        .rst(rst),
        .btnC(btnC),
        .btnL(btnL),
        .btnU(btnU_d),
        .btnR(btnR),
        .movement_state(move_state_p1));
    
    movement_state p2(
        .slow_clk(clk_1k),
        .rst(rst),
        .btnC(player2_C),
        .btnL(player2_L),
        .btnU(u2),
        .btnR(player2_R),
        .movement_state(move_state_p2));
        
    ball_state bs(clk_1k, rst, l_c, r_c, u_c, d_c, move_state_ball);
    
    // Update square pos module instantiation
    wire [7:0] p1_xpos, p1_ypos,
    p2_xpos, p2_ypos,
    ball_xpos, ball_ypos,
    p1_xpos_60hz, p1_ypos_60hz,
    p2_xpos_60hz, p2_ypos_60hz,
    ball_xpos_60hz, ball_ypos_60hz;
    
    
    collision_p cp(p1_xpos, p2_xpos, p_contacted);
    collision_ball cb(p1_xpos, p1_ypos, p2_xpos, p2_ypos, ball_xpos, ball_ypos, 
        l_c, r_c, u_c, d_c, sandwich_p1p2, sandwich_p2p1, sandwich_g1, sandwich_g2);
        
    update_square_pos p1_pos_30hz(
        .slow_clk(clk_60hz),
        .clk45(clk_45hz),
        .clk30(clk_30hz),
        .clk15(clk_15hz),
        .rst(rst),
        .contacted(p_contacted),
        .movement_state(move_state_p1),
        .sandwich_p1p2(sandwich_p1p2), 
        .sandwich_p2p1(sandwich_p2p1), 
        .sandwich_g1(sandwich_g1),
        .curr_xstart(p1_xpos),
        .curr_ystart(p1_ypos),
        .new_xstart(p1_xpos_60hz),
        .new_ystart(p1_ypos_60hz));
    
     p2_pos p2_pos_30hz(
       .slow_clk(clk_60hz),
       .clk45(clk_45hz),
       .clk30(clk_30hz),
       .clk15(clk_15hz),
       .rst(rst),
       .contacted(p_contacted),
       .movement_state(move_state_p2), 
       .sandwich_p1p2(sandwich_p1p2), 
       .sandwich_p2p1(sandwich_p2p1), 
       .sandwich_g2(sandwich_g2),
       .curr_xstart(p2_xpos),
       .curr_ystart(p2_ypos),
       .new_xstart(p2_xpos_60hz),
       .new_ystart(p2_ypos_60hz));
       
     ball_pos b_pos_30hz(
      .slow_clk(clk_60hz),
      .rst(rst),
      .movement_state(move_state_ball),
      .curr_xstart(ball_xpos),
      .curr_ystart(ball_ypos),
      .new_xstart(ball_xpos_60hz),
      .new_ystart(ball_ypos_60hz));

    
    assign p1_xpos = p1_xpos_60hz;
    assign p1_ypos = p1_ypos_60hz;
    assign p2_xpos = p2_xpos_60hz;
    assign p2_ypos = p2_ypos_60hz;
    assign ball_xpos = ball_xpos_60hz;
    assign ball_ypos = ball_ypos_60hz;
    assign rst = ((ball_ypos > 29 && (ball_xpos < 6 || ball_xpos > 90)) || reset ||
        p1_count > 8 || p2_count > 8) ? 1 : 0;
        
    reg [31:0] counter = 0;
    reg [11:0] px1, px2;
    reg [31:0] count = 0;
    reg activate = 0;
    
    always @ (posedge clk_25m) begin
            if (player1 == 0) begin
                px1 <= 7;
            end
            else if (player1 == 1) begin
                px1 <= 30;
            end
            else if (player1 == 2) begin
                px1 <= 53;
            end
            else if (player1 == 3) begin
                px1 <= 77;
            end
            else begin
                px1 <= px1;
            end   
    
            if (player2 == 0) begin
                px2 <= 79;
            end
            else if (player2 == 1) begin
                px2 <= 56;
            end
            else if (player2 == 2) begin
                px2 <= 33;
            end
            else if (player2 == 3) begin
                px2 <= 9;
            end
            else begin
                px2 <= px2;
            end   
    
        if (reset) begin
            p1_count <= 0;
            p2_count <= 0;
            counter <= 0;
        end else begin
            if (sw2) begin
                pixel_data <= 0;    
            end else 
            if ((x >= p1_xpos && x <= p1_xpos + 9 && y >= p1_ypos && y <= p1_ypos + 18) || 
                (x >= p2_xpos && x <= p2_xpos + 9 && y >= p2_ypos && y <= p2_ypos + 18) ||
                (((x - ball_xpos)*(x - ball_xpos)) + ((y - ball_ypos)*(y - ball_ypos)) <= 10)) begin
                if ((x >= p1_xpos && x <= p1_xpos + 9 && y >= p1_ypos && y <= p1_ypos + 18))begin
                    pixel_data <= ps1[(y - p1_ypos + 17) * 96 + (x - p1_xpos + px1)];
                end
                if ((x >= p2_xpos && x <= p2_xpos + 9 && y >= p2_ypos && y <= p2_ypos + 18))begin
                    pixel_data <= ps0[(y - p2_ypos + 17) * 96 + (x - p2_xpos + px2)];
                end
                if (((x - ball_xpos)*(x - ball_xpos)) + ((y - ball_ypos)*(y - ball_ypos)) <= 10) begin
                    pixel_data <= 16'b11111_000000_00000;
                end
            end
            else begin
                pixel_data <= background[pixel_index];
            end
            
            if ((!sw2) && activate && (count <= 480000000)) begin
                count <= count + 1;
                if (count <= 18000000) begin
                     pixel_data <= ani3_mem[pixel_index];
                end
                else begin
                     pixel_data <= ani5_mem[pixel_index];
                end
            end 
            else begin
                count <= 0;
            end
            
            if (count >= 48000000) begin
                activate <= 0;
                count <= 0;
            end
            
            
            if (p1_ypos < 45) begin
                inAir <= 1;
            end else begin
                inAir <= 0;
            end
            
            if (p2_ypos < 45) begin
                inAir2 <= 1;
            end else begin
                inAir2 <= 0;
            end
            
            if (ball_ypos > 29) begin
                if (ball_xpos < 6 && counter == 0) begin
                    counter <= counter + 1;
                    p2_count <= p2_count + 1;
                    activate <= 1;
                end 
                else if (ball_xpos > 90 && counter == 0) begin
                    counter <= counter + 1;
                    p1_count <= p1_count + 1;
                    activate <= 1;
                end
            end
            
            if (counter != 0) begin
                counter <= counter + 1;
            end
            if (counter == 12500000) begin
                counter <= 0;
            end
        end
    end
    
    
endmodule