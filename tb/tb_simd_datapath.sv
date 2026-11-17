module tb_simd_datapath;

    logic signed [63:0] vector_a;
    logic signed [63:0] vector_b;
    logic op;
    logic  [127:0] vector_result;

    simd_datapath dut (
        .vector_a(vector_a),
        .vector_b(vector_b),
        .op(op),
        .vector_result(vector_result)
    );

    initial begin
        // Test case 1: Addition
        vector_a = {16'd100, -16'd10, 16'd20, 16'd10}; // 100, -10, 20, -30
        vector_b = {-16'd2, 16'd5, 16'd3, 16'd5}; // -2, 5, 3, 5
        op = 0; // Addition
        #1; // Wait for the operation to complete

        if (vector_result !== {32'd98, -32'd5, 32'd23, 32'd15}) begin
            $fatal(1, "Test failed: Expected vector_result=0x0062000B0017000F, got %h", vector_result);
        end else begin
            $display("Addition test passed: vector_result=0x%h", vector_result);
        end

        // Test case 2: Multiplication
        vector_a = {16'd100, -16'd10, 16'd20, 16'd10}; // 100, -10, 20, -30
        vector_b = {-16'd2, 16'd5, 16'd3, 16'd5}; // -2, 5, 3, 5
        op = 1; // Multiplication
        #10; // Wait for the operation to complete

        if (vector_result !== {-32'd200, -32'd50, 32'd60, 32'd50}) begin
            $fatal(1, "Test failed: Expected vector_result=0xFF38FFCE003C0032, got %h", vector_result);
        end else begin
            $display("Multiplication test passed: vector_result=0x%h", vector_result);
        end
        $finish;
    end
endmodule
