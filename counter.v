module counter (
    input  logic       reset,
    input  logic       clk,
    input  logic       enable,
    output logic [3:0] count
);

    always_ff @(posedge clk) begin
        if (reset)
            count <= 4'b0000;
        else if (enable && count < 4'b1010)
            count <= count + 1'b1;
    end

endmodule
