`timescale 1 ns/ 1 ns
module AES_top_tb();
reg clk;
reg [127:0] iKey;
reg [127:0] iPlaintext;
reg rst_n;                                            
wire [127:0]  oCiphertext;
wire [127:0]  oPlaintext;
                        
AES_top i1 (
	.clk(clk),
	.iKey(iKey),
	.iPlaintext(iPlaintext),
	.oCiphertext(oCiphertext),
	.oPlaintext(oPlaintext),
	.rst_n(rst_n)
);

initial                                                
begin                                                  
	#0 	clk = 0;
		rst_n = 0;
	#5	rst_n = 1;
		iKey = 128'h31_32_33_34_35_36_37_38_39_30_31_32_33_34_35_36;
		iPlaintext = 128'h30_39_38_37_36_35_34_33_32_31_36_35_34_33_32_31;
$display("Running testbench");                       
end    
                                                
always #10
begin
    clk = ~clk;
end                                                
endmodule

