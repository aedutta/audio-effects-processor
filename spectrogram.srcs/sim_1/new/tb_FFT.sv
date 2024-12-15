module tb_FFT;
    logic aclk;
    logic aresetn;
    
    logic [31:0] in_data;
    logic in_valid;
    logic in_last;
    wire in_ready;

    logic [7:0] config_data;
    logic config_valid;
    wire config_ready;

    wire [31:0] out_data;
    wire out_valid;
    wire out_last;
    logic out_ready;

    logic [31:0] input_data [15:0];
    integer i;
    top_wrapper dut (
        .aclk(aclk),
        .aresetn(aresetn),
        
        .in_data(in_data),
        .in_valid(in_valid),
        .in_ready(in_ready),
        .in_last(in_last),
        
        .config_data(config_data),
        .config_valid(config_valid),
        .config_ready(config_ready),
        
        .out_data(out_data),
        .out_valid(out_valid),
        .out_last(out_last),
        .out_ready(out_ready)
    );
    always
    begin
        #5 aclk = ~aclk;
    end
    
    initial begin
        aclk = 0;
        aresetn = 0;
        in_valid = 1'b0;
        in_data = 32'd0;
        in_last = 1'b0;
        out_ready = 1'b1;
        config_data = 8'd0;
        config_valid = 1'b0;
    end
    
    initial begin
        // Reset needs to be activated for at least 2 cycles, we have given 70 units of delay
        #70 aresetn = 1;
    
        input_data[0]  = 32'b00000001000000110000010100000111;
        input_data[1]  = 32'b00001001000010110001110101011101;
        input_data[2]  = 32'b00100010001000110010110111001101;
        input_data[3]  = 32'b00111011001110110011111001011111;
        input_data[4]  = 32'b01010001010100110100111011001111;
        input_data[5]  = 32'b01100111011110110101111101011111;
        input_data[6]  = 32'b01111110000101110110111111001111;
        input_data[7]  = 32'b10010101001100110111111101011111;
        input_data[8]  = 32'b10101010010110111000111111001111;
        input_data[9]  = 32'b10111111011111111001111101011111;
        input_data[10] = 32'b11010111101010111010111011001111;
        input_data[11] = 32'b11101110110001111011111001011111;
        input_data[12] = 32'b00000110011000111100110111001111;
        input_data[13] = 32'b00011101011111111101110101011111;
        input_data[14] = 32'b00110101100110111110110011001111;
        input_data[15] = 32'b01001101101101111111110001011111; // Input Data generated from python
    end
    
    initial begin
        // Config Data initial block
        #100 
        config_data = 1;
        #5 
        config_valid = 1;
    
        while (config_ready == 0) begin
            config_valid = 1;
        end
        #5 config_valid = 0;
    end
    
    initial begin 
        #100
        for (i = 15; i>=0; i=i-1) begin
            #10
            if (i == 0) begin
                in_last = 1'b1;
            end
            in_data = input_data[i];
            in_valid = 1'b1;
            while (in_ready == 0) begin
                in_valid = 1'b1;
            end
        end
    #10
    in_valid = 1'b0;
    in_last = 1'b0;
    end
    
    initial begin
        #100
        wait(out_valid == 1);
        #300 out_ready = 1'b0;
    end
    
endmodule
