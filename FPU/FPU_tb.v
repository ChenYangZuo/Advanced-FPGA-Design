`timescale  1ns / 100ps

module FPU_tb();

reg         clk;
reg         rst;
reg  [31:0] IN_A;
reg  [31:0] IN_B;
wire [31:0] OUT_Z;
reg  [1:0]  sel;

FPU U_FPU(
    .clk            (clk),
    .rst            (rst),
    .sel            (sel),
    .input_a        (IN_A),
    .input_b        (IN_B),
    .output_z       (OUT_Z)
);

//sel=00 -> add
//sel=01 -> mul
//sel=10 -> div

initial begin
    clk = 1'b0;
    rst = 1'b1;
    #50
    rst = 1'b0;

    sel = 2'b00;//add 23.49-8.27=15.22
    IN_A = 32'b01000001101110111110101110000101; //23.49
    IN_B = 32'b11000001000001000101000111101100; //-8.27
	
    #500
	sel = 2'b01;//mul 7.4*12.9=95.46
    IN_A = 32'b001000000111011001100110011001101; //7.4
    IN_B = 32'b01000001010011100110011001100110; //12.9
	
	#500
	sel = 2'b10;//div 125.13/12.9=9.7
    IN_A = 32'b01000010111110100100001010001111; //125.13
    IN_B = 32'b01000001010011100110011001100110; //12.9
    
end

always #10
begin
    clk = ~clk;
end

endmodule 