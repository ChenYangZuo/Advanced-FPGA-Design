`timescale 1 ns/ 1 ns
module i2s_tb();

reg sclk;
reg rst;
reg [31:0] left_chan;
reg [31:0] right_chan;
wire lrclk;
wire sdata;
wire [31:0] rx_left_chan;
wire [31:0] rx_right_chan;

i2s_top i2s_top_u1(
    .sclk(sclk),
    .rst(rst),
    .left_chan(left_chan),
    .right_chan(right_chan),
    .lrclk(lrclk),
    .sdata(sdata),
    .rx_left_chan(rx_left_chan),
    .rx_right_chan(rx_right_chan)
);

initial                                                
begin                                                  
	#0 	sclk = 0;
        rst = 1;
    #5  rst = 0;
	    left_chan = 32'h01234567;
	    right_chan = 32'h89abcdef;
$display("Running testbench");                       
end    
                                                
always #10
begin
    sclk = ~sclk;
end                                                
endmodule