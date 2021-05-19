module FPU(
    clk,
    rst,
    sel,
    input_a,
    input_b,
    output_z
);

    input    clk;
    input    rst;
    input    [1:0]  sel;
    input    [31:0] input_a;
    input    [31:0] input_b;
	output   [31:0] output_z;

    wire     [31:0] result_add;
    wire     [31:0] result_mul;
    wire     [31:0] result_div;
    reg      [5:0]  select;
    
    
    always @(sel)
    begin
        case(sel)
            2'b00: select <= 6'b110000;//add
            2'b01: select <= 6'b001100;//mul
            2'b10: select <= 6'b000011;//div
            default: select <= 6'b000000;
        endcase
    end

    adder u_adder(
        .clk            (clk),
        .rst            (rst),
        .input_a        (input_a),
        .input_b        (input_b),
        .output_z       (result_add),
        .input_a_stb    (select[5]),
        .input_b_stb    (select[4]),
        .output_z_ack   (1'b1)
    );

    multiplier u_multiplier(
        .clk            (clk),
        .rst            (rst),
        .input_a        (input_a),
        .input_b        (input_b),
        .output_z       (result_mul),
        .input_a_stb    (select[3]),
        .input_b_stb    (select[2]),
        .output_z_ack   (1'b1)
    );

    divider u_divider(
        .clk            (clk),
        .rst            (rst),
        .input_a        (input_a),
        .input_b        (input_b),
        .output_z       (result_div),
        .input_a_stb    (select[1]),
        .input_b_stb    (select[0]),
        .output_z_ack   (1'b1)
    );

    assign output_z = select[5]?result_add:select[3]?result_mul:result_div;

endmodule 