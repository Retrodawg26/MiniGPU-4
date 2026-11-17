module tb_mux2;

    logic a, b, sel, y;
    logic [2:0] test_vector;

    assign a = test_vector[0];
    assign b = test_vector[1];
    assign sel = test_vector[2];


mux2 dut (
    .a(a),
    .b(b),
    .sel(sel),
    .y(y)
);

initial begin
    for (int i = 0; i < 8; i++) begin
        test_vector = 3'(i);
        #10;
        if (y !== (sel ? b : a)) begin
            $fatal(1, "Test failed for a=%b, b=%b, sel=%b => y=%b", a, b, sel, y);
        end
        $display("a=%b, b=%b, sel=%b => y=%b", a, b, sel, y);
    end
    $display("All tests passed!");
    $finish;
end

endmodule

