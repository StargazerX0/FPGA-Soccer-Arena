`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2024 10:04:26 AM
// Design Name: 
// Module Name: update_square_pos
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


module update_square_pos(input slow_clk, clk45, clk30, clk15, rst, contacted, sandwich_p1p2, sandwich_p2p1, sandwich_g1,
    input [2:0] movement_state, input [7:0] curr_xstart, curr_ystart,
    output reg [7:0] new_xstart = 6, new_ystart = 45);
    reg [4:0] counter = 0;
    wire gravity_clk;
    wire clk_3hz;
    
    assign gravity_clk = counter == 0 ? slow_clk :
                            counter == 1 ? clk45 :
                            counter == 2 ? clk30 : clk15;
    slow_clock c3hz(slow_clk, 5, clk_3hz);
    // always @ (posedge slow_clk) begin
    //     if (rst) begin
    //         new_xstart <= 6;
    //     end else begin
    //         if (movement_state[0] == 1 && !contacted && !sandwich_p2p1) begin
    //             new_xstart <= (curr_xstart >= 86) ? 86 : curr_xstart + 1;
    //         end else if (movement_state[2] == 1 && !sandwich_p1p2) begin
    //             new_xstart <= (curr_xstart == 0) ? 0 : curr_xstart - 1;
    //         end else begin
    //             new_xstart <= new_xstart;
    //         end 
    //     end
    // end
    
    always @ (posedge clk_3hz) begin
        if (rst || curr_ystart >= 45) begin
            counter <= 0;
        end else begin
            if (movement_state[1] == 1) begin
                if (counter < 3) begin
                   counter <= counter + 1;
                end else begin
                   counter <= counter; 
                end
            end else begin
                if (counter > 0) begin
                    counter <= counter - 1;
                end else begin
                    counter <= 0;
                end
            end
        end
    end
    
    always @ (posedge gravity_clk) begin
        if (rst) begin
            new_xstart <= 6;
            new_ystart <= 45;
        end else begin
            if (movement_state[0] == 1 && !contacted && !sandwich_p2p1) begin
                new_xstart <= (curr_xstart >= 86) ? 86 : curr_xstart + 1;
            end else if (movement_state[2] == 1 && !sandwich_p1p2) begin
                new_xstart <= (curr_xstart == 0) ? 0 : curr_xstart - 1;
            end else begin
                new_xstart <= new_xstart;
            end

            if (movement_state[1] == 1) begin
                new_ystart <= (curr_ystart == 20) ? 20 : curr_ystart - 1;
            end else if (sandwich_g1) begin
                new_ystart <= new_ystart;
            end else begin
                new_ystart <= (curr_ystart >= 45) ? 45 : curr_ystart + 1;
            end
        end
    end
endmodule
