module alu (
    input  logic [1:0] operation,
    input  logic [7:0] a,
    input  logic [7:0] b,

    output logic signed [9:0] fin_result,
    output logic       zero,
    output logic       carry

);
    logic [8:0] result;
    logic       borrow;
    always_comb begin
        result = '0;
        carry  = 1'b0;
        borrow = 1'b0;

        case (operation)
            2'b00: begin
                result = {1'b0, a} + {1'b0, b};
                carry  = result[8];
            end

            2'b01: begin
                result = {1'b0, a} - {1'b0, b};
                borrow = (a < b);
            end

            2'b10: begin
                result = {1'b0, a & b};
            end

            2'b11: begin
                result = {1'b0, a | b};
            end

            default: begin
                result = '0;
            end
        endcase

        zero = (result == '0);
        fin_result = {borrow,result};
    end

endmodule

`timescale 1ns/1ps

module alu_tb;

    logic [1:0] operation;
    logic [7:0] a;
    logic [7:0] b;
    logic signed [9:0] fin_result;
    logic       zero;
    logic       carry;
     

    int errors = 0;

    alu dut (
        .operation(operation),
        .a(a),
        .b(b),
        .fin_result(fin_result),
        .zero(zero),
        .carry(carry)
    );

    task automatic check_alu(
    input logic [1:0] op,
    input logic [7:0] test_a,
    input logic [7:0] test_b,
    input logic signed [9:0] expected_result,
    input logic       expected_zero,
    input logic       expected_carry
);

    operation = op;
    a = test_a;
    b = test_b;

    #1;

    if (
        (fin_result !== expected_result) ||
        (zero !== expected_zero) ||
        (carry !== expected_carry)
    ) begin
        $error(
            "FAILED: op=%b a=%b b=%b expected=%b/%b/%b got=%b/%b/%b",
            op,
            test_a,
            test_b,
            expected_result,
            expected_zero,
            expected_carry,
            fin_result,
            zero,
            carry
        );

        errors++;
    end

endtask

    initial begin

        for (int i = 0; i < 256; i++) begin
    for (int j = 0; j < 256; j++) begin
        check_alu(
            2'b00,
            i[7:0],
            j[7:0],
            i + j,
            ((i + j) == 0),
            (i+j >= 256)
        );
    end
end

        // More calls go here
		for (int i = 0; i < 256; i++) begin
    for (int j = 0; j < 256; j++) begin
        check_alu(
            2'b01,
            i[7:0],
            j[7:0],
            i - j,
            ((i - j) == 0),
            1'b0
        );
    end
end
		
		for (int i = 0; i < 256; i++) begin
    for (int j = 0; j < 256; j++) begin
        check_alu(
            2'b10,
            i[7:0],
            j[7:0],
            i & j,
            ((i & j) == 0),
            1'b0
        );
    end
end

		for (int i = 0; i < 256; i++) begin
    for (int j = 0; j < 256; j++) begin
        check_alu(
            2'b11,
            i[7:0],
            j[7:0],
            i | j,
            ((i | j) == 0),
            1'b0
        );
    end
end
        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("%0d TESTS FAILED", errors);

        $finish;
    end

endmodule
