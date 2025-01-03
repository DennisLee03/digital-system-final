module top(rst, inGame, clk, seg1, seg2, seg3, o_Hsync, o_Vsync, o_red, o_green, o_blue);

input rst, inGame, clk;
output [6:0] seg1, seg2, seg3;

output o_Hsync, o_Vsync;
output [3:0] o_red, o_green, o_blue;

wire clk_1hz, clk_25MHz;
wire [3:0] sec1, sec2;
wire [3:0] position, counter;

// setup timer
FD fd_1hz(.clk_50Mhz(clk), .reset(rst), .clock_div(clk_1hz));
timer u_timer(
    .inGame(inGame), 
    .rst(rst), 
    .clk_1hz(clk_1hz), 
    .sec1(sec1), 
    .sec2(sec2), 
    .counter(counter)
);
SevenDisplay u_s1(.count(sec1), .out(seg1));
SevenDisplay u_s2(.count(sec2), .out(seg2));

// generate position
random u_rand(
    .rst(rst), 
    .clk_1hz(clk_1hz), 
    .position(position)
);
SevenDisplay u_s3(.count(position), .out(seg3));

FD#(.TIME_EXPIRE(1)) fd_25hz(.clk_50Mhz(clk), .reset(rst), .clock_div(clk_25MHz));
vga_driver VGA_disp(
    .rst(rst), 
    .clk_25MHz(clk_25MHz), 
    .o_hsync(o_Hsync), 
    .o_vsync(o_Vsync), 
    .o_red(o_red), 
    .o_green(o_green), 
    .o_blue(o_blue)
);

endmodule

