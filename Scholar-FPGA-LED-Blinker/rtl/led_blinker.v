module led_blinker (
    input  wire clk_in,   // 12 MHz, onboard oscillator Y1, FPGA pin 43
    output wire led_out   // to IO_CLK header pin, FPGA pin 44
);

    reg [23:0] counter = 24'd0;

    always @(posedge clk_in) begin
        counter <= counter + 1'b1;
    end

    assign led_out = counter[23];

endmodule
