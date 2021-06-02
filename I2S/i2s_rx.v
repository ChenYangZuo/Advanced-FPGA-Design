module i2s_rx (
	input				sclk,
	input				rst,

	input				lrclk,
	input				sdata,

	// Parallel datastreams
	output reg [31:0]	left_chan,
	output reg [31:0]	right_chan
);

reg [31:0]	left;
reg [31:0]	right;
reg			lrclk_r;
wire			lrclk_nedge;

assign lrclk_nedge = !lrclk & lrclk_r;

always @(posedge sclk)
	lrclk_r <= lrclk;

// sdata msb is valid one clock cycle after lrclk switches
always @(posedge sclk)
	if (lrclk_r)
		right <= {right[32-2:0], sdata};
	else
		left <= {left[32-2:0], sdata};

always @(posedge sclk)
	if (rst) begin
		left_chan <= 0;
		right_chan <= 0;
	end else if (lrclk_nedge) begin
		left_chan <= left;
		right_chan <= {right[32-2:0], sdata};
	end

endmodule 