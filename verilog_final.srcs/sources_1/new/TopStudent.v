`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2024 15:02:49
// Design Name: 
// Module Name: TopStudent
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

 module TopStudent(
    input clk,
    input sw0,//reset
    input sw1,
    input sw2,
    input btnC,
    input btnL,
    input btnR,
    input btnD,
    input btnU,
    output reg [6:0] seg = 7'b1111111,
    output reg [3:0] an = 4'b1111,
    input [2:0] RX,
    output reg [2:0] TX = 0,
    output reg [7:0] JC = 0,
    output reg [5:0] led = 0
    );

    reg player2_C = 0;
    reg player2_L = 0;
    reg player2_U = 0;
    reg player2_R = 0;

    localparam UP = 3'b001;
    localparam DOWN = 3'b010; 
    localparam LEFT = 3'b011;   
    localparam RIGHT = 3'b100;  
    localparam CENTER = 3'b101;
    localparam UPLEFT = 3'b110;
    localparam UPRIGHT = 3'b111;

    localparam BLACK = 3'b001;  
    localparam BROWN = 3'b010;  
    localparam YELLOW = 3'b011;   
    localparam CXK = 3'b100;  

    localparam START = 4'b0000;
    localparam SELECT = 4'b0001;
    localparam BACKGROUND = 4'b0010;
    localparam ANIMATION = 4'b0011;
    localparam GOAL_ANIMATION = 4'b0100;
    localparam WIN_SCREEN = 4'b0101;

    wire [4:0] stage;


     always @ (posedge clk) begin
        if (stage >= BACKGROUND) begin
            if (RX == UP) begin
                player2_U <= 1;
                player2_L <= 0;
                player2_R <= 0;
                player2_C <= 0;
            end
            else if (RX == LEFT) begin
                player2_U <= 0;
                player2_L <= 1;
                player2_R <= 0;
                player2_C <= 0;
            end
            else if (RX == RIGHT) begin
                player2_U <= 0;
                player2_L <= 0;
                player2_R <= 1;
                player2_C <= 0;
            end
            else if (RX == CENTER) begin
                player2_U <= 0;
                player2_L <= 0;
                player2_R <= 0;
                player2_C <= 1;
            end
            else if (RX == UPLEFT) begin
                player2_U <= 1;
                player2_L <= 1;
                player2_R <= 0;
                player2_C <= 0;
            end
            else if (RX == UPRIGHT) begin
                player2_U <= 1;
                player2_L <= 0;
                player2_R <= 1;
                player2_C <= 0;
            end
            else begin
                player2_U <= 0;
                player2_L <= 0;
                player2_R <= 0;
                player2_C <= 0;
            end
        end
    end

    wire btnC_D, btnU_D, btnR_D, btnL_D, btnD_D;

    debouncer_k debouncer_btnC(
        .clk(clk),
        .btn(btnC),
        .btn_D(btnC_D)
    );

    debouncer_k debouncer_btnU(
        .clk(clk),
        .btn(btnU),
        .btn_D(btnU_D)
    );

    debouncer_k debouncer_btnR(
        .clk(clk),
        .btn(btnR),
        .btn_D(btnR_D)
    );

    debouncer_k debouncer_btnL(
        .clk(clk),
        .btn(btnL),
        .btn_D(btnL_D)
    );

    debouncer_k debouncer_btnD(
        .clk(clk),
        .btn(btnD),
        .btn_D(btnD_D)
    );

    wire s_clock, fb, send_p, samp_p;
    wire [12:0] p_index, x, y;
    
    // Read memory file
    reg [15:0] select_mem [0:6143];
    reg [15:0] start_page_mem [0:6143];
    reg [15:0] background [0:6143];
    reg [15:0] play0_mem [0:6143];
    reg [15:0] play3_mem [0:6143];
    reg [15:0] play5_mem [0:6143];
    reg [15:0] p1_mem [0:6143];
    reg [15:0] p4_mem [0:6143];
    reg [15:0] p1_win_mem [0:6143];
    reg [15:0] p2_win_mem [0:6143];
    
    initial begin
        $readmemh("select.mem", select_mem);
        $readmemh("start_page.mem", start_page_mem);
        $readmemh("background_mem.mem", background);
        $readmemh("play0.mem", play0_mem);
        $readmemh("play3.mem", play3_mem);
        $readmemh("play5.mem", play5_mem);
        $readmemh("p2.mem", p1_mem);
        $readmemh("p4.mem", p4_mem);
        $readmemh("p1_win.mem", p1_win_mem);
        $readmemh("p2_win.mem", p2_win_mem);
    end

    wire [7:0] JC_GAME;

    reg [3:0] left_signal = 0;
    reg [3:0] right_signal = 0;

    //register for player information
    reg [2:0] player1 = 0;//player1 is the current player
    reg [2:0] player2 = 0;//player2 is the opponent player

    wire reset_engine;

    assign reset_engine = (stage >= ANIMATION) ? 0 : 1;

    wire [3:0] left_goal, right_goal;
    
    Main engine(clk, sw1, sw2, reset_engine, btnC_D, btnL_D, btnU_D, btnR_D, 
        player2_C, player2_L, player2_U, player2_R, player1, player2, JC_GAME, left_goal, right_goal);
                
    // 6.25MHz clock for Oled
    wire clk_6p25m;
    my_clock clock_6p25m(clk, 7, clk_6p25m);
                
    // 25MHz clock for operation
    wire clk_25m;
    my_clock clock_25m(clk, 1, clk_25m);
    
    wire clk_1000;
    my_clock my_1000hz_clk(clk, 49999, clk_1000);
    
    wire l_signal, r_signal, c_signal;
    wire l_move_time, r_move_time, c_move_time;
                
    // Oled display module instantiation
    reg [15:0] oled_data = 16'b00000_000000_00000;
    wire frame_begin, sending_pixels, sample_pixel;
    wire [12:0] pixel_index;
    wire [4:0] place;
    
    debouncer my_left_debounce (clk, btnL, l_signal, l_move_time);
    debouncer my_right_debounce(clk, btnR, r_signal, r_move_time);
    debouncer my_centre_debounce(clk, btnC, c_signal, c_move_time);
    
    // Match counter, 1Hz clock for match counting
    wire clk_1hz;
    my_clock clock_1hz(clk, 49999999, clk_1hz);
    wire match_over;
    wire [5:0] match_timer, match_led;
    match_counter match_count(.clk(clk_1hz), .state(stage), .count(match_timer), .led(match_led), .match_over(match_over));

    reg player1_select = 0;
    reg player2_select = 0;
    
    placement my_placement (clk_1000, place, l_signal, r_signal, l_move_time, r_move_time);
    stateSet my_state(.clock(clk_1000), .reset(sw0), .c_signal(c_signal), .player1_select(player1_select),
        .player2_select(player2_select), .match_over(match_over), .stage(stage), .move_time(c_move_time));


    //control block for TX and RX
    always @(posedge clk) begin
        if (sw0) begin
            TX <= 0;
        end
        else if (stage == SELECT) begin
            TX <= place + 1;
        end
        else if (stage >= BACKGROUND) begin
            if (btnC_D) begin
                TX <= CENTER;
            end
            else if (btnU_D && ~ btnL_D && ~ btnR_D) begin
                TX <= UP;
            end
            else if (~btnU_D && btnL_D) begin
                TX <= LEFT;
            end
            else if (~btnU_D && btnR_D) begin
                TX <= RIGHT;
            end
            else if (btnU_D && btnL_D) begin
                TX <= UPLEFT;
            end
            else if (btnU_D && btnR_D) begin
                TX <= UPRIGHT;
            end
            else begin
                TX <= 0;
            end
        end
        else begin
            TX <= TX;
        end
    end

    //control block for player selection
    always @(posedge clk) begin
        if (stage == START) begin
            player1 <= 0;
            player2 <= 0;
            player1_select <= 0;
            player2_select <= 0;
        end
        else if (stage == SELECT) begin
            if (btnC_D) begin
                player1_select <= 1;
            end else begin
                player1_select <= player1_select;
            end
            
            if (place + 1 == BLACK) begin
                player1 <= 0;
            end
            else if (place + 1 == BROWN) begin
                player1 <= 1;
            end
            else if (place + 1 == YELLOW) begin
                player1 <= 2;
            end
            else if (place + 1 == CXK) begin
                player1 <= 3;
            end
            else begin
                player1 <= player1;
            end
            
            if (RX == BLACK) begin
                player2 <= 0;
                player2_select <= 1;
            end
            else if (RX == BROWN) begin
                player2 <= 1;
                player2_select <= 1;
            end
            else if (RX == YELLOW) begin
                player2 <= 2;
                player2_select <= 1;
            end
            else if (RX == CXK) begin
                player2 <= 3;
                player2_select <= 1;
            end
            else begin
                player2 <= player2;
                player2_select <= player2_select;
            end
        end
    end
    
    get_coord coord (pixel_index, x, y);

    wire [7:0] JC_INT; //jc for initialization

    always @ (posedge clk) begin
        if ((stage <= BACKGROUND) || ((!sw2) && stage >= WIN_SCREEN)) begin
            JC <= JC_INT;
        end
        else begin
            JC <= JC_GAME;
        end
    end

    Oled_Display unit_oled(
       .clk(clk_6p25m),
       .reset(0),
       .frame_begin(frame_begin),
       .sending_pixels(sending_pixels),
       .sample_pixel(sample_pixel),
       .pixel_index(pixel_index),
       .pixel_data(oled_data),
       .cs(JC_INT[0]),
       .sdin(JC_INT[1]),
       .sclk(JC_INT[3]),
       .d_cn(JC_INT[4]),
       .resn(JC_INT[5]),
       .vccen(JC_INT[6]),
       .pmoden(JC_INT[7]));
    
    reg [31:0] count = 0;
    reg [7:0] seg1, seg2;
    reg [7:0] dash = 7'b0111111;
    reg [3:0] an1 = 4'b1011; 
    reg [3:0] an2 = 4'b1110;
    reg [3:0] anD = 4'b1101; 
    always @ (posedge clk) begin
        if (stage >= BACKGROUND) begin
            if (right_goal == 0) begin
                seg2 <= 7'b1000000;
            end
            else if (right_goal == 4'b0001) begin
                seg2 <= 7'b1111001;
            end
            else if (right_goal == 4'b0010) begin
                seg2 <= 7'b0100100;
            end
            else if (right_goal == 4'b0011) begin
                seg2 <= 7'b0110000;
            end
            else if (right_goal == 4'b0100) begin
                seg2 <= 7'b0011001;
            end
            else if (right_goal == 4'b0101) begin
                seg2 <= 7'b0010010;
            end
            else if (right_goal == 4'b0110) begin
                seg2 <= 7'b0000010;
            end
            else if (right_goal == 4'b0111) begin
                seg2 <= 7'b1111000;
            end
            else if (right_goal == 4'b1000) begin
                seg2 <= 7'b0000000;
            end
            else if (right_goal == 4'b1001) begin
                seg2 <= 7'b0011000;
            end
            else begin
                seg2 <= 7'b1000000;
            end
            
            if (left_goal == 0) begin
                seg1 <= 7'b1000000;
            end
            else if (left_goal == 4'b0001) begin
                seg1 <= 7'b1111001;
            end
            else if (left_goal == 4'b0010) begin
                seg1 <= 7'b0100100;
            end
            else if (left_goal == 4'b0011) begin
                seg1 <= 7'b0110000;
            end
            else if (left_goal == 4'b0100) begin
                seg1 <= 7'b0011001;
            end
            else if (left_goal == 4'b0101) begin
                seg1 <= 7'b0010010;
            end
            else if (left_goal == 4'b0110) begin
                seg1 <= 7'b0000010;
            end
            else if (left_goal == 4'b0111) begin
                seg1 <= 7'b1111000;
            end
            else if (left_goal == 4'b1000) begin
                seg1 <= 7'b0000000;
            end
            else if (left_goal == 4'b1001) begin
                seg1 <= 7'b0011000;
            end
            else begin
                seg1 <= 7'b1000000;
            end
        end
    end
    
    reg [1:0] s_count = 0;
    
    always @ (posedge clk_1000) begin
        if (stage >= ANIMATION && !sw2) begin
            if (s_count >= 2) begin
                s_count <= 0;
            end else begin
                s_count <= s_count + 1;
            end 
            
            case(s_count) 
                2'b00: begin
                    seg <= seg1;
                    an <= an1;
                end
                2'b01: begin
                    seg <= seg2;
                    an <= an2;
                end
                2'b10: begin
                    seg <= dash;
                    an <= anD;
                end
                default: begin
                    seg <= 7'b0000000;
                    an <= 4'b0000;
                end
            endcase
        end else begin
            seg <= 7'b1111111;
            an <= 4'b1111;
        end
    end
    
    reg [31:0] a_count;
                
    always @ (posedge clk_25m) begin
        if (stage == 0) begin
            oled_data = start_page_mem[pixel_index];
        end
        
        if (stage == BACKGROUND) begin
            a_count = a_count + 1;
        end
        else begin
            a_count = 0;
        end
        
        if (a_count >= 60000000) begin
            a_count = 60000000;
        end
        
        if (stage >= 3) begin
            count = count + 1;
        end
        
        
        if ((((x >= 88 && x <= 90 ) && (y >= 16 && y <= 39))
            || ((x >= 74 && x <= 90 ) && (y >= 16 && y <= 18))
            || ((x >= 74 && x <= 90 ) && (y >= 37 && y <= 39))
            || ((x >= 74 && x <= 76 ) && (y >= 16 && y <= 39)))
            && (place == 3) && (stage == 1))
        begin
            oled_data <= 16'b0000011111100000;
        end
        else if ((((x >= 64 && x <= 66 ) && (y >= 16 && y <= 39))
            || ((x >= 51 && x <= 66 ) && (y >= 16 && y <= 18))
            || ((x >= 51 && x <= 66 ) && (y >= 37 && y <= 39))
            || ((x >= 51 && x <= 53 ) && (y >= 16 && y <= 39)))
            && (place == 2) && (stage == 1))
        begin
            oled_data <= 16'b0000011111100000;
        end
        else if ((((x >= 41 && x <= 43 ) && (y >= 16 && y <= 39))
            || ((x >= 28 && x <= 43 ) && (y >= 16 && y <= 18))
            || ((x >= 28 && x <= 43 ) && (y >= 37 && y <= 39))
            || ((x >= 28 && x <= 30 ) && (y >= 16 && y <= 39)))
            && (place == 1) && (stage == 1))
       begin
            oled_data <= 16'b0000011111100000;
       end
       else if ((((x >= 18 && x <= 20 ) && (y >= 16 && y <= 39))
            || ((x >= 5 && x <= 20 ) && (y >= 16 && y <= 18))
            || ((x >= 5 && x <= 20 ) && (y >= 37 && y <= 39))
            || ((x >= 5 && x <= 7 ) && (y >= 16 && y <= 39)))
            && (place == 0) && (stage == 1))
       begin
            oled_data <= 16'b0000011111100000;
       end 
       else if (stage == 1) begin
            oled_data <= select_mem[pixel_index];
       end
       else begin
            oled_data <= oled_data;
       end
       
       if (stage == 2) begin
           if (a_count <= 4000000) begin
                oled_data <= play0_mem[pixel_index];
            end
            else if ((a_count > 4000000) && (a_count <= 8000000)) begin
                oled_data <= play3_mem[pixel_index];
            end 
            else if ((a_count > 12000000) && (a_count <= 40000000)) begin
                oled_data <= play5_mem[pixel_index];
            end
            else begin
                oled_data <= p1_mem[pixel_index];
            end
       end
       
       if (stage == 3) begin
            led <= match_led;
       end
       else begin
            led <= 0;
       end
       
       if (stage == 5) begin
            oled_data <= (left_goal >= right_goal) ? p1_win_mem[pixel_index] : p2_win_mem[pixel_index];
       end

    end  
    
endmodule
