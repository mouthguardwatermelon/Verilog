module small_reg(
input logic clk,
input logic reset,
input logic enable,
input logic [1:0] write address,
input logic [1:0] read_address,
input logic [3:0] write_data,
output logic [3:0] read_data,
);

logic [3:0] registers [0:3];
assign read_data = registers[read_data];

always_ff @(posedge clk) begin
if (reset) begin
registers[0] <= 4'b0000;
registers[1] <= 4'b0000;
registers[2] <= 4'b0000;
registers[3] <= 4'b0000;
end
else if (enable) begin
registers[write_address] <= write_data;
end
end

endmodule
