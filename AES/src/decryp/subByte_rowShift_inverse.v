module subByte_rowShift_inverse
(
	input clk,
	input rst_n,
	input [127 : 0] iBlockIn,
	output reg [127 : 0] oBlockout
);

wire [127 : 0] wSubOut, wRotShift;

//行移位，直接将线路对应连接即可
assign wRotShift = {iBlockIn [127 : 120],iBlockIn [23  : 16 ],iBlockIn [47  : 40 ],iBlockIn [71 : 64],
                    iBlockIn [95  : 88 ],iBlockIn [119 : 112],iBlockIn [15  : 8  ],iBlockIn [39 : 32],
                    iBlockIn [63  : 56 ],iBlockIn [87  : 80 ],iBlockIn [111 : 104],iBlockIn [7  : 0 ],
                    iBlockIn [31  : 24 ],iBlockIn [55  : 48 ],iBlockIn [79  : 72 ],iBlockIn [103: 96]};


//字节替换逻辑，用8个双口rom实现
rom_2p_inverse	rom_2p_inverse_inst0 ( 
	.address_a ( wRotShift [127	:	120] ),
	.address_b ( wRotShift [119	:	112] ),
	.clock ( clk ),
	.q_a ( wSubOut [127	:	120] ),
	.q_b ( wSubOut [119	:	112] )
	);
rom_2p_inverse	rom_2p_inverse_inst1 (
	.address_a ( wRotShift [111	:	104] ),
	.address_b ( wRotShift [103	:	96 ] ),
	.clock ( clk ),
	.q_a ( wSubOut [111	:	104] ),
	.q_b ( wSubOut [103	:	96 ] )
	);
rom_2p_inverse	rom_2p_inverse_inst2 (
	.address_a ( wRotShift [95	:	88 ] ),
	.address_b ( wRotShift [87	:	80 ] ),
	.clock ( clk ),
	.q_a ( wSubOut [95	:	88 ] ),
	.q_b ( wSubOut [87	:	80 ] )
	);
rom_2p_inverse	rom_2p_inverse_inst3 (
	.address_a ( wRotShift [79	:	72 ] ),
	.address_b ( wRotShift [71	:	64 ] ),
	.clock ( clk ),
	.q_a ( wSubOut [79	:	72 ] ),
	.q_b ( wSubOut [71	:	64 ] )
	);
rom_2p_inverse	rom_2p_inverse_inst4 (
	.address_a ( wRotShift [63	:	56 ] ),
	.address_b ( wRotShift [55	:	48 ] ),
	.clock ( clk ),
	.q_a ( wSubOut [63	:	56 ] ),
	.q_b ( wSubOut [55	:	48 ] )
	);
rom_2p_inverse	rom_2p_inverse_inst5 (
	.address_a ( wRotShift [47	:	40 ] ),
	.address_b ( wRotShift [39	:	32 ] ),
	.clock ( clk ),
	.q_a ( wSubOut [47	:	40 ] ),
	.q_b ( wSubOut [39	:	32 ] )
	);
rom_2p_inverse	rom_2p_inverse_inst6 (
	.address_a ( wRotShift [31	:	24 ] ),
	.address_b ( wRotShift [23	:	16 ] ),
	.clock ( clk ),
	.q_a ( wSubOut [31	:	24 ] ),
	.q_b ( wSubOut [23	:	16 ] )
	);
rom_2p_inverse	rom_2p_inverse_inst7 (
	.address_a ( wRotShift [15	:	8  ] ),
	.address_b ( wRotShift [7	:	0  ] ),
	.clock ( clk ),
	.q_a ( wSubOut [15	:	8  ] ),
	.q_b ( wSubOut [7	:	0  ] )
	);


//输出寄存器，传递给下一级信号
always @(posedge clk or negedge rst_n)begin
	if(!rst_n)
		oBlockout <= 0;
	else 
		oBlockout <= wSubOut;
end


endmodule