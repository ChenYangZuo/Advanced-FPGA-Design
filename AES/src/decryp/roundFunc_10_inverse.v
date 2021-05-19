module roundFunc_10_inverse
(
	input clk,
	input rst_n,
	input [127 : 0] iBlockIn,
	input [127 : 0] iKeyValue,//轮密钥
	output reg [127 : 0] oBlockout
);

wire [127 : 0] wRowShift;

subByte_rowShift_inverse subByte_rowShift_inverse_inst1
(
	.clk(clk),
	.rst_n(rst_n),
	.iBlockIn(iBlockIn),
	.oBlockout(wRowShift)
);


always @(posedge clk or negedge rst_n)begin
	if(!rst_n)
		oBlockout <= 0;
	else
		oBlockout <= wRowShift ^ iKeyValue;
end

endmodule 