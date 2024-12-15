`timescale 1ns / 1ps

module pwm_generator #(
    parameter PWM_RESOLUTION = 12,
    parameter PCM_WIDTH       = 16
)(
    input  logic                     clk,
    input  logic                     reset,
    input  logic [PCM_WIDTH-1:0]     pcm_left,
    input  logic [PCM_WIDTH-1:0]     pcm_right,
    output logic                     pwm_out_left,
    output logic                     pwm_out_right
);

    logic [PWM_RESOLUTION-1:0] duty_cycle_left, duty_cycle_right;
    assign duty_cycle_left  = (pcm_left  + 16'sd32768) >> 4;
    assign duty_cycle_right = (pcm_right + 16'sd32768) >> 4;

    localparam PWM_MAX_COUNT = (1 << PWM_RESOLUTION) - 1; // 4095
    logic [PWM_RESOLUTION-1:0] pwm_counter;
    

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            pwm_counter <= 0;
        else if (pwm_counter >= PWM_MAX_COUNT)
            pwm_counter <= 0;
        else
            pwm_counter <= pwm_counter + 1;
    end

    // Generate PWM signals
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            pwm_out_left  <= 0;
            pwm_out_right <= 0;
        end else begin
            pwm_out_left  <= (pwm_counter < duty_cycle_left)  ? 1'b1 : 1'b0;
            pwm_out_right <= (pwm_counter < duty_cycle_right) ? 1'b1 : 1'b0;
        end
    end

endmodule
