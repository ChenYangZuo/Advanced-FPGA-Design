module subColMix_inverse
(
	input [31 : 0] iBlockIn,
	output reg [31 : 0] oBlockout
);
//分割四个元素
wire [7 : 0] wS00 = iBlockIn[31 : 24];
wire [7 : 0] wS10 = iBlockIn[23 : 16];
wire [7 : 0] wS20 = iBlockIn[15 : 8];
wire [7 : 0] wS30 = iBlockIn[7 : 0];

//乘2后的元素
wire [7 : 0] wS00_1 = iBlockIn[31] ? {iBlockIn[30 : 24],1'b0} ^ 8'h1b : {iBlockIn[30 : 24],1'b0};
wire [7 : 0] wS10_1 = iBlockIn[23] ? {iBlockIn[22 : 16],1'b0} ^ 8'h1b : {iBlockIn[22 : 16],1'b0};
wire [7 : 0] wS20_1 = iBlockIn[15] ? {iBlockIn[14 : 8],1'b0} ^ 8'h1b : {iBlockIn[14 : 8],1'b0};
wire [7 : 0] wS30_1 = iBlockIn[7] ? {iBlockIn[6 : 0],1'b0} ^ 8'h1b : {iBlockIn[6 : 0],1'b0};

//乘4后的元素
wire [7 : 0] wS00_2 = wS00_1[7] ? {wS00_1[6 : 0],1'b0} ^ 8'h1b : {wS00_1[6 : 0],1'b0};
wire [7 : 0] wS10_2 = wS10_1[7] ? {wS10_1[6 : 0],1'b0} ^ 8'h1b : {wS10_1[6 : 0],1'b0};
wire [7 : 0] wS20_2 = wS20_1[7] ? {wS20_1[6 : 0],1'b0} ^ 8'h1b : {wS20_1[6 : 0],1'b0};
wire [7 : 0] wS30_2 = wS30_1[7] ? {wS30_1[6 : 0],1'b0} ^ 8'h1b : {wS30_1[6 : 0],1'b0};

//乘8后的元素
wire [7 : 0] wS00_3 = wS00_2[7] ? {wS00_2[6 : 0],1'b0} ^ 8'h1b : {wS00_2[6 : 0],1'b0};
wire [7 : 0] wS10_3 = wS10_2[7] ? {wS10_2[6 : 0],1'b0} ^ 8'h1b : {wS10_2[6 : 0],1'b0};
wire [7 : 0] wS20_3 = wS20_2[7] ? {wS20_2[6 : 0],1'b0} ^ 8'h1b : {wS20_2[6 : 0],1'b0};
wire [7 : 0] wS30_3 = wS30_2[7] ? {wS30_2[6 : 0],1'b0} ^ 8'h1b : {wS30_2[6 : 0],1'b0};

always @(*)begin
    //E B D 9
	oBlockout[31 : 24] = (wS00_3^wS00_2^wS00_1) ^ (wS10_3^wS10_1^wS10) ^ (wS20_3^wS20_2^wS20) ^ (wS30_3^wS30);
    //9 E B D
	oBlockout[23 : 16] = (wS00_3^wS00) ^ (wS10_3^wS10_2^wS10_1) ^ (wS20_3^wS20_1^wS20) ^ (wS30_3^wS30_2^wS30);
    //D 9 E B
	oBlockout[15 : 8] = (wS00_3^wS00_2^wS00) ^ (wS10_3^wS10) ^ (wS20_3^wS20_2^wS20_1) ^ (wS30_3^wS30_1^wS30);
    //B D 9 E
	oBlockout[7 : 0] = (wS00_3^wS00_1^wS00) ^ (wS10_3^wS10_2^wS10) ^ (wS20_3^wS20) ^ (wS30_3^wS30_2^wS30_1);
end

endmodule 