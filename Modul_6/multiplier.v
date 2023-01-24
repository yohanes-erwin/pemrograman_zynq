`timescale 1ns / 1ps

module multiplier
    (
        input wire [31:0]  a,
        input wire [31:0]  b,
        output wire [31:0] c
    );
    
    assign c = a * b;
    
endmodule
