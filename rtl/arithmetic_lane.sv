module arithmetic_lane(input logic signed [15:0] a, b,
    output logic signed [31:0] result,
    input logic op);


    logic signed [31:0] extend_a, extend_b;


    assign extend_a = 32'(a); // Sign-extend a to 32 bits
    assign extend_b = 32'(b); // Sign-extend b to 32 bits

    always_comb begin
        if (op) begin
            result = a * b; // Multiplication operation
        end else begin
            result = extend_a + extend_b; // Addition operation
        end
        
    end
endmodule


