module tb_vector_regfile;

    logic clk;
    logic write_enable;
    logic [2:0] write_addr;
    logic [63:0] write_data;
    logic [2:0] read_addr_a;
    logic [2:0] read_addr_b;
    logic [63:0] read_data_a;
    logic [63:0] read_data_b;

    vector_regfile dut (
        .clk(clk),
        .write_enable(write_enable),
        .write_addr(write_addr),
        .write_data(write_data),
        .read_addr_a(read_addr_a),
        .read_addr_b(read_addr_b),
        .read_data_a(read_data_a),
        .read_data_b(read_data_b)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time units clock period
    end
    timeunit 1ns;
    timeprecision 1ps;

    initial begin
        // Test writing and reading from the register file
        write_enable = 0;
        write_addr = 3'b000;
        write_data = 64'd0;
        read_addr_a = 3'b000;
        read_addr_b = 3'b000;

        @(negedge clk);
        write_enable = 1;
        write_addr = 3'd2;
        write_data = 64'd150;
        read_addr_a = 3'd2;

        @(negedge clk);
        write_enable = 0;
        write_data = 64'd999;
        @(posedge clk);
        #1;

        if (read_data_a !== 64'd150) begin
            $fatal(1, "Test failed: Expected read_data_a=150, got %d", read_data_a);
        end else begin
            $display("Data retention test passed: read_data_a=150");
        end
        
        @(posedge clk);
        #1;

        if (read_data_a !== 64'd150) begin
            $fatal(1, "Test failed: Expected read_data_a=150, got %d", read_data_a);
        end else begin
            $display("Test passed: read_data_a=150");
        end

        @(negedge clk);
        write_enable = 1;
        write_addr = 3'd5;
        write_data = 64'd300;
        read_addr_a = 3'd2;
        read_addr_b = 3'd5;

        @(posedge clk);
        #1;
        write_enable = 0;

        if (read_data_a !== 64'd150 && read_data_b !== 64'd300) begin
            $fatal(1, "Test failed: Expected read_data_a=150 and read_data_b=300, got %d and %d", read_data_a, read_data_b);
        end else begin
            $display("Data retention and storage test passed: read_data_a=150, read_data_b=300");
        end

    @(negedge clk);
    read_addr_a = 3'd5;
    read_addr_b = 3'd5;

    @(posedge clk);
    #1;
    write_enable = 0;

    if (read_data_a !== 64'd300 && read_data_b !== 64'd300) begin
        $fatal(1, "Test failed: Expected read_data_a=300 and read_data_b=300, got %d and %d", read_data_a, read_data_b);
    end else begin
        $display("Both ports can read the same register: read_data_a=300, read_data_b=300");
    end
    $finish;
end

endmodule
