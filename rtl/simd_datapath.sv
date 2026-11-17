module simd_datapath (
    input logic signed [63:0] vector_a,
    input logic signed [63:0] vector_b,
    input logic op,
    output logic  [127:0] vector_result
);

    logic signed [15:0] a0, a1, a2, a3;
    logic signed [15:0] b0, b1, b2, b3;
    logic signed [31:0] result0, result1, result2, result3;

    // Split the 64-bit vectors into 4 16-bit segments
    assign a0 = vector_a[15:0];
    assign a1 = vector_a[31:16];
    assign a2 = vector_a[47:32];
    assign a3 = vector_a[63:48];

    assign b0 = vector_b[15:0];
    assign b1 = vector_b[31:16];
    assign b2 = vector_b[47:32];
    assign b3 = vector_b[63:48];

    // Instantiate four arithmetic lanes
    arithmetic_lane lane0 (.a(a0), .b(b0), .result(result0), .op(op));
    arithmetic_lane lane1 (.a(a1), .b(b1), .result(result1), .op(op));
    arithmetic_lane lane2 (.a(a2), .b(b2), .result(result2), .op(op));
    arithmetic_lane lane3 (.a(a3), .b(b3), .result(result3), .op(op));

    // Concatenate the results into the final 128-bit output
    assign vector_result = {result3, result2, result1, result0};

endmodule
