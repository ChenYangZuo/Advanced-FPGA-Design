module colMix_keyAdd_inverse
(
	input clk,
	input rst_n,
	input [127 : 0] iBlockIn,
	input [127 : 0] iKeyValue,//轮密钥
	output [127 : 0] oBlockout
);

wire [127 : 0] wKeyAddOut;

//轮密钥加
assign wKeyAddOut = iBlockIn ^ iKeyValue;

//列逆混淆
subColMix_inverse subColMix_inst0//列1
(
	.iBlockIn(wKeyAddOut[127 : 96]),
	.oBlockout(oBlockout[127 : 96])
 );
 
subColMix_inverse subColMix_inst1//列2
(
	.iBlockIn(wKeyAddOut[95 : 64]),
	.oBlockout(oBlockout[95 : 64])
 );

subColMix_inverse subColMix_inst2//列3
(
	.iBlockIn(wKeyAddOut[63 : 32]),
	.oBlockout(oBlockout[63 : 32])
 );
 
subColMix_inverse subColMix_inst3//列4
(
	.iBlockIn(wKeyAddOut[31 : 0]),
	.oBlockout(oBlockout[31 : 0])
 );



endmodule