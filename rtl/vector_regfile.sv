module vector_regfile (
    input logic clk,
    input logic write_enable,
    input logic [2:0] write_addr,
    input logic [63:0] write_data,
    input logic [2:0] read_addr_a,
    input logic [2:0] read_addr_b,
    output logic [63:0] read_data_a,
    output logic [63:0] read_data_b
);

logic [63:0] storage [0:7];
timeunit 1ns;
timeprecision 1ps;


always_ff @(posedge clk) begin
    if (write_enable) begin
        storage[write_addr] <= write_data;
    end
end

assign read_data_a = storage[read_addr_a];
assign read_data_b = storage[read_addr_b];

endmodule
