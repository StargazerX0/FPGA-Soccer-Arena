`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2024 17:04:29
// Design Name: 
// Module Name: placement
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


module placement(
    input clock,
    output reg [4:0] placement = 3,
    input l_signal,
    input r_signal,
    input l_move_time,
    input r_move_time
    );
    
    reg [10:0] count = 0;
    reg [20:0] s_count = 0;
    
    always @(posedge clock) begin
//        s_count = s_count + 1;
        
//        if (s_count >= 4000) begin
//            s_count = 5000;
//        end
        
//        if (s_count >= 4000) begin
            
            if ((l_move_time == 1) || (r_move_time == 1)) begin
                if (count > 0) begin
                    count <= count - 1;
                end
                else begin
                    count <= 0;
                end
            end else begin
                count <= 0;
            end
            
            
            if ((r_signal && (placement == 2))
                 && (count <= 0)) begin
                placement <= 3;
                count <= 2000;
            end
            else if (((r_signal && (placement == 1))
                || (l_signal && (placement == 3))) && (count <= 0)) begin
                placement <= 2;
                count <= 2000;
            end
            else if (((r_signal && (placement == 0))
                || (l_signal && (placement == 2))) && (count <= 0)) begin
                placement <= 1;
                count <= 2000;
            end
            else if (l_signal && (placement == 1) && (count <= 0)) begin
                placement <= 0;
                count <= 2000;
            end
            else begin
                placement <= placement;
            end
//        end
//        else begin
//            placement <= 3;
//        end
    end
    
endmodule
