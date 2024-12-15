module wave_file_read();

    timeunit 1ns;
    timeprecision 1ps;

    // Clock signal
    logic clock;

    // Control signals and PCM data
    logic data_valid;
    logic signed [23:0] data_left, data_right;
    logic signed [23:0] data_left_aux, data_right_aux;

    // PWM outputs
    logic pwm_left, pwm_right;

    // File handling and metadata variables
    int audio_in;
    int status;
    logic [7:0] aux;
    int number_of_samples;

    // WAV file header information
    logic [31:0] chunk_id;
    logic [31:0] chunk_size;
    logic [31:0] format;
    logic [31:0] subchunk_1_id;
    logic [31:0] subchunk_1_size;
    logic [15:0] audio_format;
    logic [15:0] num_channels;
    logic [31:0] sample_rate;
    logic [31:0] byte_rate;
    logic [15:0] block_align;
    logic [15:0] bits_per_sample;
    logic [31:0] subchunk_2_id;
    logic [31:0] subchunk_2_size;

    // PWM counter and duty cycles
    logic [11:0] pwm_counter;        // Adjusted counter range for PWM
    logic [11:0] duty_cycle_left;    // Duty cycle for left channel
    logic [11:0] duty_cycle_right;   // Duty cycle for right channel

    // Adjusted max counter value for PWM
    parameter int PWM_MAX_COUNT = 2267;  // Matches sampling period for 44.1 kHz

    // Clock generation
    initial begin
        clock = 0;
        forever #5ns clock = ~clock;  // 10ns clock period (100 MHz)
    end

    // Main simulation
    initial begin
        $display("******************************");
        $display("*      Simulation Start      *");
        $display("******************************");

        // Initialize signals
        data_valid <= 1'b0;
        data_left_aux <= 'b0;
        data_right_aux <= 'b0;
        pwm_counter <= 12'b0;

        // Open the WAV file
        audio_in = $fopen("C:/Users/Owner/ece385/example.wav", "rb");
        if (audio_in == 0) begin
            $display("Error: Failed to open WAV file.");
            $stop();
        end

        // Read and parse the WAV header
        status = $fread(chunk_id, audio_in);
        $display("Chunk ID: 0x%h (expected: 0x52494646 'RIFF')", chunk_id);
        status = $fread(chunk_size, audio_in);
        chunk_size = {<<byte{chunk_size}};
        $display("Chunk Size: %d bytes", chunk_size);
        status = $fread(format, audio_in);
        $display("Format: 0x%h (expected: 0x57415645 'WAVE')", format);

        // Read fmt subchunk
        status = $fread(subchunk_1_id, audio_in);
        $display("Subchunk 1 ID: 0x%h (expected: 0x666d7420 'fmt ')", subchunk_1_id);
        status = $fread(subchunk_1_size, audio_in);
        subchunk_1_size = {<<byte{subchunk_1_size}};
        $display("Subchunk 1 Size: %d bytes", subchunk_1_size);
        status = $fread(audio_format, audio_in);
        audio_format = {<<byte{audio_format}};
        $display("Audio Format: %d (expected: 1 for PCM)", audio_format);
        status = $fread(num_channels, audio_in);
        num_channels = {<<byte{num_channels}};
        $display("Number of Channels: %d", num_channels);
        status = $fread(sample_rate, audio_in);
        sample_rate = {<<byte{sample_rate}};
        $display("Sample Rate: %d Hz", sample_rate);
        status = $fread(byte_rate, audio_in);
        byte_rate = {<<byte{byte_rate}};
        $display("Byte Rate: %d Bps", byte_rate);
        status = $fread(block_align, audio_in);
        block_align = {<<byte{block_align}};
        $display("Block Align: %d bytes", block_align);
        status = $fread(bits_per_sample, audio_in);
        bits_per_sample = {<<byte{bits_per_sample}};
        $display("Bits per Sample: %d", bits_per_sample);

        // Read data subchunk
        status = $fread(subchunk_2_id, audio_in);
        $display("Subchunk 2 ID: 0x%h (expected: 0x64617461 'data')", subchunk_2_id);
        status = $fread(subchunk_2_size, audio_in);
        subchunk_2_size = {<<byte{subchunk_2_size}};
        $display("Subchunk 2 Size: %d bytes", subchunk_2_size);

        // Calculate the number of samples
        number_of_samples = (subchunk_2_size * 8) / (num_channels * bits_per_sample);
        $display("Number of Samples: %d", number_of_samples);

        // Process audio data
        $display("Reading audio data...");
        for (int i = 0; i < number_of_samples; i++) begin
            // Read left channel sample
            for (int j = 0; j < (bits_per_sample / 8); j++) begin
                status = $fread(aux, audio_in);
                data_left_aux = {aux, data_left_aux[23:8]};
            end

            // Read right channel sample (if stereo)
            if (num_channels == 2) begin
                for (int j = 0; j < (bits_per_sample / 8); j++) begin
                    status = $fread(aux, audio_in);
                    data_right_aux = {aux, data_right_aux[23:8]};
                end
            end

            // Normalize PCM data to duty cycle (12-bit resolution)
            duty_cycle_left = (data_left_aux + 24'h800000) >> 11; // Shift for proper mapping
            duty_cycle_right = (data_right_aux + 24'h800000) >> 11;

            // Generate PWM
            pwm_counter = (pwm_counter == PWM_MAX_COUNT) ? 0 : pwm_counter + 1;
            pwm_left = (pwm_counter < duty_cycle_left) ? 1'b1 : 1'b0;
            pwm_right = (pwm_counter < duty_cycle_right) ? 1'b1 : 1'b0;

            // Output data on clock edge
            @(posedge clock);
            data_valid <= 1'b1;
            data_left <= data_left_aux;
            data_right <= data_right_aux;
            @(posedge clock);
            data_valid <= 1'b0;
            #10ns;
        end

        // Close the WAV file
        $fclose(audio_in);
        $display("Audio data read complete.");
        $display("******************************");
        $display("*       Simulation End       *");
        $display("******************************");
        $stop();
    end

endmodule