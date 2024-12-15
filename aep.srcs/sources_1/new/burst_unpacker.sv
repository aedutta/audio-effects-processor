`timescale 1ns / 1ps

module address_incrementer #(
    parameter ADDR_WIDTH = 27,
    parameter COUNTER_WIDTH = 10,
    parameter MAX_ADDRESS = 27'h201FFF
)(
    input  logic                     clk,
    input  logic                     reset,
    input  logic                     enable,
    input  logic [1:0]               speed_select,

    // Switches to define loop region
    input  logic                     sw_set_loop_start, 
    input  logic                     sw_set_loop_end,
    input  logic                     sw_break_loop, 
    
    output logic [ADDR_WIDTH-1:0]    read_addr,
    output logic                     read_addr_valid
);

    // Internal Signals for Counter
    logic [COUNTER_WIDTH-1:0] address_counter;
    logic counter_tick;
    logic [COUNTER_WIDTH-1:0] COUNTER_MAX;

    // Loop start/end registers
    logic [ADDR_WIDTH-1:0] loop_start_address;
    logic [ADDR_WIDTH-1:0] loop_end_address;
    logic loop_active;

    // Previous states of switches for edge detection
    logic prev_sw_start, prev_sw_end, prev_sw_break;

    // Select speed
    always_comb begin
        case (speed_select)
            2'b00: COUNTER_MAX = 10'd512;  // Normal speed
            2'b01: COUNTER_MAX = 10'd256;  // Faster (~2x)
            2'b10: COUNTER_MAX = 10'd1023; // Slower (~half speed)
            default: COUNTER_MAX = 10'd1023;
        endcase
    end

    // Clock Divider to Generate Tick for Counter
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            address_counter <= 0;
            counter_tick   <= 0;
        end else begin
            if (address_counter >= COUNTER_MAX) begin
                address_counter <= 0;
                counter_tick   <= 1;
            end else begin
                address_counter <= address_counter + 1;
                counter_tick   <= 0;
            end
        end
    end

    // Edge detection for switches
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            prev_sw_start <= 0;
            prev_sw_end   <= 0;
            prev_sw_break <= 0;
        end else begin
            prev_sw_start <= sw_set_loop_start;
            prev_sw_end   <= sw_set_loop_end;
            prev_sw_break <= sw_break_loop;
        end
    end

    // Rising edge detection signals
    wire start_edge = ~prev_sw_start & sw_set_loop_start;
    wire end_edge   = ~prev_sw_end & sw_set_loop_end;
    wire break_edge = ~prev_sw_break & sw_break_loop;

    // Capture loop start and end addresses on rising edges
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            loop_start_address <= 0;
            loop_end_address   <= MAX_ADDRESS;
            loop_active        <= 0;
        end else begin
            if (start_edge) begin
                loop_start_address <= read_addr;
                loop_active <= 0;
            end
            if (end_edge) begin
                loop_end_address <= read_addr;
                loop_active <= 1;
            end
            if (break_edge) begin
                loop_active <= 0;
            end
        end
    end

    // Read Address Register with Looping Logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            read_addr <= 0;
        end else if (counter_tick && enable) begin
            if (loop_active) begin
                if (read_addr == loop_end_address) begin
                    read_addr <= loop_start_address;
                end else begin
                    read_addr <= read_addr + 1;
                end
            end else begin
                if (read_addr == MAX_ADDRESS)
                    read_addr <= 0; 
                else 
                    read_addr <= read_addr + 1;
            end
        end
    end

    assign read_addr_valid = counter_tick && enable;

endmodule
