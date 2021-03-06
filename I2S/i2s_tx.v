module i2s_tx(
	input			sclk,
	input			rst,

	// Prescaler for lrclk generation from sclk should hold the number of
	// sclk cycles per channel (left and right).
	input [31:0]	prescaler,

	output reg		lrclk,
	output reg		sdata,

	// Parallel datastreams
	input [31:0]	left_chan,
	input [31:0]	right_chan
);

reg [31:0]		bit_cnt;
reg [31:0]		left;
reg [31:0]		right;

always @(negedge sclk)
	if (rst)
		bit_cnt <= 1;
	else if (bit_cnt >= prescaler)
		bit_cnt <= 1;
	else
		bit_cnt <= bit_cnt + 1;

// Sample channels on the transfer of the last bit of the right channel
always @(negedge sclk)
	if (bit_cnt == prescaler && lrclk) begin
		left <= left_chan;
		right <= right_chan;
	end

// left/right "clock" generation - 0 = left, 1 = right
always @(negedge sclk)
	if (rst)
		lrclk <= 1;
	else if (bit_cnt == prescaler)
		lrclk <= ~lrclk;

always @(negedge sclk)
	sdata <= lrclk ? right[32 - bit_cnt] : left[32 - bit_cnt];

endmodule
