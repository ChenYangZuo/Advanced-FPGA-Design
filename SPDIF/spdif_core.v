module spdif_core(
    input           clk_i,
    input           rst_i,
    input           bit_out_en_i,
    // SPDIF bit output enable
    // Single cycle pulse synchronous to clk_i which drives
    // the output bit rate.
    // For 44.1KHz, 44100x32x2x2 = 5,644,800Hz
    // For 48KHz,   48000x32x2x2 = 6,144,000Hz
    
    // Audio interface (16-bit x 2 = RL)
    input [31:0]    sample_i,
    // Output
    output          spdif_o,
    output reg      sample_req_o
);

//-----------------------------------------------------------------
// Registers 寄存器
//-----------------------------------------------------------------
reg [15:0]  audio_sample_q;
reg [8:0]   subframe_count_q;

reg         load_subframe_q;
reg [7:0]   preamble_q;
wire [31:0] subframe_w;

reg [5:0]   bit_count_q;
reg         bit_toggle_q;

reg         spdif_out_q;

reg [5:0]   parity_count_q;

//-----------------------------------------------------------------
// Subframe Counter 子帧计数器
//-----------------------------------------------------------------
always @ (posedge rst_i or posedge clk_i )
begin
    if (rst_i == 1'b1)
        subframe_count_q    <= 9'd0;
    else if (load_subframe_q)
    begin
        // 192 frames (384 subframes) in an audio block
        if (subframe_count_q == 9'd383)
            subframe_count_q <= 9'd0;
        else
            subframe_count_q <= subframe_count_q + 9'd1;
    end
end

//-----------------------------------------------------------------
// Sample capture 捕获
//-----------------------------------------------------------------
reg [15:0] sample_buf_q;

always @ (posedge rst_i or posedge clk_i ) begin
   if (rst_i == 1'b1)
   begin
        audio_sample_q      <= 16'h0000;
        sample_buf_q        <= 16'h0000;
        sample_req_o        <= 1'b0;
   end
   else if (load_subframe_q) begin
        // Start of frame (first subframe)?
        if (subframe_count_q[0] == 1'b0) begin
            // Use left sample
            audio_sample_q <= sample_i[15:0];
            // Store right sample
            sample_buf_q <= sample_i[31:16];
            // Request next sample
            sample_req_o <= 1'b1;
        end
        else begin
            // Use right sample
            audio_sample_q <= sample_buf_q;
            sample_req_o <= 1'b0;
        end
    end
    else
        sample_req_o <= 1'b0;
end

// Timeslots 3 - 0 = Preamble 预兆码
assign subframe_w[3:0] = 4'b0000;

// Timeslots 7 - 4 = 24-bit audio LSB
assign subframe_w[7:4] = 4'b0000;

// Timeslots 11 - 8 = 20-bit audio LSB
assign subframe_w[11:8] = 4'b0000;

// Timeslots 27 - 12 = 16-bit audio
assign subframe_w[27:12] = audio_sample_q;

// Timeslots 28 = Validity 有效性 0为有效
assign subframe_w[28] = 1'b0; // Valid

// Timeslots 29 = User bit 子码数据
assign subframe_w[29] = 1'b0;

// Timeslots 30 = Channel status bit 通道状态信息
assign subframe_w[30] = 1'b0;

// Timeslots 31 = Even Parity bit (31:4) 极码
assign subframe_w[31] = 1'b0;

//-----------------------------------------------------------------
// Preamble 预兆码
//-----------------------------------------------------------------
localparam PREAMBLE_Z = 8'b00010111;
localparam PREAMBLE_Y = 8'b00100111;
localparam PREAMBLE_X = 8'b01000111;

reg [7:0] preamble_r;
//P82 最下面表格
always @ * begin
    if (subframe_count_q == 9'd0)//左通道在数据模块的开始
        preamble_r = PREAMBLE_Z;
    else if (subframe_count_q[0] == 1'b1)//右通道
        preamble_r = PREAMBLE_Y;
    else//左通道不在数据模块的开始
        preamble_r = PREAMBLE_X;
end

always @ (posedge rst_i or posedge clk_i )
if (rst_i == 1'b1)
    preamble_q  <= 8'h00;
else if (load_subframe_q)
    preamble_q  <= preamble_r;

//-----------------------------------------------------------------
// Parity Counter 奇偶计数器
//-----------------------------------------------------------------
always @ (posedge rst_i or posedge clk_i ) begin
    if (rst_i == 1'b1)
        parity_count_q  <= 6'd0;
    // Time to output a bit?
    else if (bit_out_en_i) begin
        // Preamble bits?
        if (bit_count_q < 6'd8)
            parity_count_q  <= 6'd0;
        // Normal timeslots
        else if (bit_count_q < 6'd62)
            // On first pass through this timeslot, count number of high bits
            // 在第一次通过这个时隙时，计算高位的数量
            if (bit_count_q[0] == 0 && subframe_w[bit_count_q / 2] == 1'b1)
                parity_count_q <= parity_count_q + 6'd1;
    end
end

//-----------------------------------------------------------------
// Bit Counter 位计数器
//-----------------------------------------------------------------
always @ (posedge rst_i or posedge clk_i) begin
    if (rst_i == 1'b1) begin
        bit_count_q     <= 6'b0;
        load_subframe_q <= 1'b1;
    end
    // Time to output a bit?
    else if (bit_out_en_i)
    begin
        // 32 timeslots (x2 for double frequency)
        if (bit_count_q == 6'd63) begin
            bit_count_q     <= 6'd0;
            load_subframe_q <= 1'b1;
        end
        else begin
            bit_count_q     <= bit_count_q + 6'd1;
            load_subframe_q <= 1'b0;
        end
    end
    else
        load_subframe_q <= 1'b0;
end

//-----------------------------------------------------------------
// Bit half toggle
//-----------------------------------------------------------------
always @ (posedge rst_i or posedge clk_i)
if (rst_i == 1'b1)
    bit_toggle_q    <= 1'b0;
// Time to output a bit?
else if (bit_out_en_i)
    bit_toggle_q <= ~bit_toggle_q;

//-----------------------------------------------------------------
// Output bit (BMC encoded) 输出位（BMC编码）
//-----------------------------------------------------------------
reg bit_r;

always @ * begin
    bit_r = spdif_out_q;
    // Time to output a bit?
    if (bit_out_en_i) begin
        // Preamble bits?
        if (bit_count_q < 6'd8)
            bit_r = preamble_q[bit_count_q[2:0]];
        // Normal timeslots
        else if (bit_count_q < 6'd62) begin
            if (subframe_w[bit_count_q / 2] == 1'b0) begin
                if (bit_toggle_q == 1'b0)
                    bit_r = ~spdif_out_q;
                else
                    bit_r = spdif_out_q;
            end
            else
                bit_r = ~spdif_out_q;
        end
        // Parity timeslot
        else begin
            // Even number of high bits, make odd
            if (parity_count_q[0] == 1'b0) begin
                if (bit_toggle_q == 1'b0)
                    bit_r = ~spdif_out_q;
                else
                    bit_r = spdif_out_q;
            end
            else
                bit_r = ~spdif_out_q;
        end
    end
end

always @ (posedge rst_i or posedge clk_i )
if (rst_i == 1'b1)
    spdif_out_q <= 1'b0;
else
    spdif_out_q <= bit_r;

assign spdif_o  = spdif_out_q;

endmodule
