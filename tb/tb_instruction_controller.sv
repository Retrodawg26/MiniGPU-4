module tb_instruction_controller;

    logic clk;
    logic rst;
    logic instruction_valid;
    logic [10:0] instruction;

    logic [2:0] read_addr_a;
    logic [2:0] read_addr_b;
    logic [2:0] write_addr;
    logic write_enable;
    logic op;
    logic busy;

    instruction_controller dut (
        .clk(clk),
        .rst(rst),
        .instruction_valid(instruction_valid),
        .instruction(instruction),
        .read_addr_a(read_addr_a),
        .read_addr_b(read_addr_b),
        .write_addr(write_addr),
        .write_enable(write_enable),
        .op(op),
        .busy(busy)
    );
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time units clock period
    end

timeunit 1ns;
timeprecision 1ps;


    initial begin
        //ADD test
        $dumpfile("sim/instruction_controller.vcd");
        $dumpvars(0, tb_instruction_controller);
        rst = 1;
        instruction_valid = 0;
        instruction = 11'b0;

        @(negedge clk);
        rst = 0;

        // Test case 1: Valid instruction
        @(negedge clk);
        instruction_valid = 1;
        instruction = 11'b00011001010; // Example valid instruction

       @(posedge clk);
       #1;  // Now in EXECUTE

if (dut.instruction_reg !== instruction)
    $fatal(1, "ADD failed: instruction was not captured");

// Check outputs during EXECUTE
if (read_addr_a !== 3'd1)
    $fatal(1, "ADD failed: read_addr_a");

if (read_addr_b !== 3'd2)
    $fatal(1, "ADD failed: read_addr_b");

if (op !== 1'b0)
    $fatal(1, "ADD failed: wrong operation");

if (busy !== 1'b1 || write_enable !== 1'b0)
    $fatal(1, "ADD failed: EXECUTE controls");

$display("PASS: ADD EXECUTE");

// Deassert valid away from rising edge
@(negedge clk);
instruction_valid = 0;

// Next rising edge: WRITEBACK
@(posedge clk);
#1;

if (write_addr !== 3'd3)
    $fatal(1, "ADD failed: write_addr");

if (write_enable !== 1'b1 || busy !== 1'b1)
    $fatal(1, "ADD failed: WRITEBACK controls");

$display("PASS: ADD WRITEBACK");

// Next rising edge: IDLE
@(posedge clk);
#1;

if (busy !== 1'b0 || write_enable !== 1'b0)
    $fatal(1, "ADD failed: return to IDLE");

$display("PASS: ADD completed");

//MUL Test
@(negedge clk);
        instruction_valid = 0;
        instruction = 11'b0;

        @(negedge clk);
        rst = 0;

        // Test case 1: Valid instruction
        @(negedge clk);
        instruction_valid = 1;
        instruction = 11'b01011001010; // Example valid instruction

       @(posedge clk);
       #1;  // Now in EXECUTE

if (dut.instruction_reg !== instruction)
    $fatal(1, "MUL failed: instruction was not captured");

if (read_addr_a !== 3'd1)
    $fatal(1, "MUL failed: read_addr_a");

if (read_addr_b !== 3'd2)
    $fatal(1, "MUL failed: read_addr_b");

if (op !== 1'b1)
    $fatal(1, "MUL failed: wrong operation");

if (busy !== 1'b1 || write_enable !== 1'b0)
    $fatal(1, "MUL failed: EXECUTE controls");

$display("PASS: MUL EXECUTE");

// Deassert valid away from rising edge
@(negedge clk);
instruction_valid = 0;

// Next rising edge: WRITEBACK
@(posedge clk);
#1;

if (write_addr !== 3'd3)
    $fatal(1, "MUL failed: write_addr");

if (write_enable !== 1'b1 || busy !== 1'b1)
    $fatal(1, "MUL failed: WRITEBACK controls");

$display("PASS: MUL WRITEBACK");

// Next rising edge: IDLE
@(posedge clk);
#1;

if (busy !== 1'b0 || write_enable !== 1'b0)
    $fatal(1, "MUL failed: return to IDLE");

$display("PASS: MUL completed");
$finish;
   end
endmodule
