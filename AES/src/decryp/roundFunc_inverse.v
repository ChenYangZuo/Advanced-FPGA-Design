module roundFunc_inverse
(
	input clk,
	input rst_n,
	input [127 : 0] iBlockIn,
	input [127 : 0] iKeyValue,//轮密钥
	output [127 : 0] oBlockout
);

wire [127 : 0] wRowShift;

subByte_rowShift_inverse subByte_rowShift_inverse_inst1
(
	.clk(clk),
	.rst_n(rst_n),
	.iBlockIn(iBlockIn),
	.oBlockout(wRowShift)
);

colMix_keyAdd_inverse colMix_keyAdd_inverse_inst1
(
	.clk(clk),
	.rst_n(rst_n),
	.iBlockIn(wRowShift),
	.iKeyValue(iKeyValue),//轮密钥
	.oBlockout(oBlockout)
);

endmodule