// Reading file 'challenge.asc'..
`timescale 1ns/1ns

module test(
    input clk
);

    reg reset = 1;
    reg tx = 1;
    wire led_g_n;
    wire led_r_n;

    // tpm2137
    chip chip_0 (.clk(clk), .rx(tx), .led_g_n(led_g_n), .led_r_n(led_r_n));

    // baud = 115200, clk = 12Mhz
    localparam BAUD_P = 12000000 / 115200; // = 104
    localparam RESET_TIME = 500;
    
    // allow solver to choose password
    (* anyconst *) reg [8*8-1:0] password;

    // cover the chip unlocking - green led active low
    always @(posedge clk) begin
        cover(!led_g_n);
    end

    localparam BAUD_W = 7;
    reg [10:0] reset_counter = 0;
    reg [BAUD_W:0] baud_counter = 0;
    reg [3:0] bit_counter = 0;
    reg [3:0] char_counter = 0;

    // counters for serial
    always @(posedge clk) begin
        if(!reset) begin
            baud_counter <= baud_counter + 1;
            if(baud_counter == BAUD_P -1) begin
                baud_counter <= 0;
                bit_counter <= bit_counter + 1;
                if(bit_counter == 9) begin
                    bit_counter <= 0;
                    char_counter <= char_counter + 1;
                end
            end
        end

        reset_counter <= reset_counter + 1;
        if(reset_counter > RESET_TIME)
            reset <= 0;
    end

    // serial assumptions : 1 start bit high, 8 data bits, 1 stop bit high, repeat
    always @(posedge clk) begin
        if(reset)
            tx <= 1; // idle in reset
        else if( char_counter >= 8)
            tx <= 1; // do something to cover end condition
        else if(bit_counter == 0)
            tx <= 0; // start bit low
        else if(bit_counter == 9)
            tx <= 1; // stop bit high
        else if( char_counter < 8)
            tx <= password[(bit_counter-1)+char_counter*8];
    end

endmodule
