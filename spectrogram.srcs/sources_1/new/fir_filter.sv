module fir_filter #(
    parameter TAPS  = 32,
    parameter WIDTH = 16 
)(
    input  logic                  clock,
    input  logic                  reset,
    input  logic signed [WIDTH-1:0] pcm_in,
    output logic signed [WIDTH-1:0] pcm_out
);

    localparam int COEFF_WIDTH = 18;
    // Tap coefficients
    localparam signed [COEFF_WIDTH-1:0] coeffs [0:TAPS-1] = '{
        18'sd73,   18'sd81,   18'sd93,   18'sd109,  18'sd127,  18'sd148,  18'sd171,  18'sd195,
        18'sd219,  18'sd242,  18'sd263,  18'sd281,  18'sd294,  18'sd302,  18'sd304,  18'sd300,
        18'sd289,  18'sd273,  18'sd251,  18'sd223,  18'sd193,  18'sd160,  18'sd127,  18'sd95,
        18'sd66,   18'sd42,   18'sd23,   18'sd10,   18'sd2,    -18'sd2,   -18'sd4,   -18'sd3
    };
    
    // Internal signals
    logic signed [WIDTH-1:0] shift_reg [0:TAPS-1];
    logic signed [WIDTH+COEFF_WIDTH-1:0] accumulator;
    logic signed [WIDTH-1:0] out_reg;

    always_ff @(posedge clock or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < TAPS; i++)
                shift_reg[i] <= '0;
        end else begin
            shift_reg[0] <= pcm_in;
            for (int i = 1; i < TAPS; i++) begin
                shift_reg[i] <= shift_reg[i-1];
            end
        end
    end

    // FIR MAC
    always_comb begin
        accumulator = '0;
        for (int i = 0; i < TAPS; i++) begin
            accumulator += shift_reg[i] * coeffs[i];
        end
        out_reg = accumulator >>> 14;
    end

    always_ff @(posedge clock or posedge reset) begin
        if (reset) begin
            pcm_out <= '0;
        end else begin
            pcm_out <= out_reg;
        end
    end

endmodule
