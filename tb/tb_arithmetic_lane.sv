module tb_arithmetic_lane;

    logic signed [15:0] a, b;
    logic signed [31:0] result;
    logic op;
    
    
    arithmetic_lane dut (
        .a(a),
        .b(b),
        .result(result),
        .op(op)
    );

    task automatic check_arithmetic(input logic signed [15:0] test_a, test_b , input logic test_op, input logic signed [31:0] expected_result);

         a = test_a;
         b = test_b; 
         op = test_op;
        #10;
        if (result !== expected_result) begin
            $fatal(1, "FAIL: a=%0d, b=%0d, op=%0b, expected_result=%0d => result=%0d", a, b, op, expected_result, result);
        end
        $display("PASS: Arithmetic test for a=%0d, b=%0d, op=%0b => result=%0d", a, b, op, result);
    endtask

    initial begin
        check_arithmetic(16'sd12, 16'sd8, 1'b0, 32'sd20); // Test addition
        check_arithmetic(16'sd12, 16'sd8, 1'b1, 32'sd96); // Test multiplication
        check_arithmetic(-16'sd12, 16'sd8, 1'b0, -32'sd4); // Test addition with negative number
        check_arithmetic(-16'sd12, -16'sd8, 1'b0, -32'sd20); // Test multiplication with negative number
        check_arithmetic(16'sd32767, 16'sd32767, 1'b0, 32'sd65534); // Test addition with overflow
        check_arithmetic(-16'sd32767, -16'sd32767, 1'b0, -32'sd65534);
        check_arithmetic(16'sd32767, -16'sd32767, 1'b0, 32'sd0); // Test addition with overflow
        check_arithmetic(-16'sd12, 16'sd8, 1'b1, -32'sd96);
        check_arithmetic(-16'sd12, -16'sd8, 1'b1, 32'sd96);
        check_arithmetic(16'sd32767, 16'sd32767, 1'b1, 32'sd1073676289); // Test multiplication with overflow
        check_arithmetic(-16'sd32767, 16'sd32767, 1'b1, -32'sd1073676289);
        $finish;
    end
endmodule







