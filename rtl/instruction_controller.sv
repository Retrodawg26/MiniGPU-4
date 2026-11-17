module instruction_controller (
    input  logic        clk,
    input  logic        rst,
    input  logic        instruction_valid,
    input  logic [10:0] instruction,

    output logic [2:0]  read_addr_a,
    output logic [2:0]  read_addr_b,
    output logic [2:0]  write_addr,
    output logic        write_enable,
    output logic        op,
    output logic        busy
);

typedef enum logic [1:0] {
    IDLE,
    EXECUTE,
    WRITEBACK
} state_t;

timeunit 1ns;
timeprecision 1ps;

state_t state;
state_t next_state;

logic [10:0] instruction_reg;

always_ff @(posedge clk) begin
    if (rst) begin
        state <= IDLE;
        instruction_reg <= 11'b0;
    end else begin
        state <= next_state;
        if (instruction_valid && state == IDLE && (instruction [10:9] == 2'b00 || instruction [10:9] == 2'b01)) begin
            instruction_reg <= instruction;
        end
    end
end

always_comb begin
    // Default values
    next_state = state;
    read_addr_a = 3'b0;
    read_addr_b = 3'b0;
    write_addr = 3'b0;
    write_enable = 1'b0;   
    op = 1'b0;
    busy = 1'b0;

    case (state)
        IDLE: begin
            if (instruction_valid && (instruction [10:9] == 2'b00 || instruction [10:9] == 2'b01)) begin
                next_state = EXECUTE;
            end
        end

        EXECUTE: begin
            read_addr_a = instruction_reg[5:3];
            read_addr_b = instruction_reg[2:0];
            op = instruction_reg[9]; // Assuming bit 9 is the operation type
            next_state = WRITEBACK;
            busy = 1'b1;
        end

        WRITEBACK: begin
            read_addr_a = instruction_reg[5:3];
            read_addr_b = instruction_reg[2:0];
            op = instruction_reg[9]; // Assuming bit 9 is the operation type
            write_enable = 1'b1;
            write_addr = instruction_reg[8:6];
            next_state = IDLE;
            busy = 1'b1;
        end

        default: begin
            next_state = IDLE;
        end
    endcase
end

endmodule
