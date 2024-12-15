module fir_wrapper(
    input  logic              clk,
    input  logic              reset,
    input  logic              filter_enable,
    input  logic signed [15:0] pcm_in_left,
    input  logic signed [15:0] pcm_in_right,
    output logic signed [15:0] pcm_out_left,
    output logic signed [15:0] pcm_out_right
);

    // Instantiating FIR modules
    logic signed [15:0] fir_left_out;
    logic signed [15:0] fir_right_out;

    fir_filter #(.TAPS(32), .WIDTH(16)) fir_left_inst (
        .clock(clk),
        .reset(reset),
        .pcm_in(pcm_in_left),
        .pcm_out(fir_left_out)
    );

    fir_filter #(.TAPS(32), .WIDTH(16)) fir_right_inst (
        .clock(clk),
        .reset(reset),
        .pcm_in(pcm_in_right),
        .pcm_out(fir_right_out)
    );

    always_comb begin
        if (filter_enable) begin
            pcm_out_left  = fir_left_out;
            pcm_out_right = fir_right_out;
        end else begin
            pcm_out_left  = pcm_in_left;
            pcm_out_right = pcm_in_right;
        end
    end

endmodule
