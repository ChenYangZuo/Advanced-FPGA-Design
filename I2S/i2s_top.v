module i2s_top(
    input sclk,
    input rst,
    input [31:0] left_chan,
	input [31:0] right_chan,
    output lrclk,
    output sdata,
    output [31:0] rx_left_chan,
	output [31:0] rx_right_chan
);

i2s_tx i2s_tx_u1(
    .sclk(sclk),
    .rst(rst),
    .prescaler(32'd32),
    .left_chan(left_chan),
    .right_chan(right_chan),
    .lrclk(lrclk),
    .sdata(sdata)
);

i2s_rx i2s_rx_u1(
    .sclk(sclk),
    .rst(rst),
    .lrclk(lrclk),
    .sdata(sdata),
	.left_chan(rx_left_chan),
	.right_chan(rx_right_chan)
);

endmodule 