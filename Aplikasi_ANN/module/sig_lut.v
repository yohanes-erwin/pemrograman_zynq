// *** Author : Erwin Ouyang
// *** Date   : 10 May 2018
`timescale 1ns / 1ps

module sig_lut
    (
        input wire [7:0]   addr,
        output wire [15:0] sig
    );
    
    reg [31:0] mem [0:255];
    
    initial
    begin
        // Start at 0.0000
        mem[8'b0000_0000]=32'b00000000100000000000000000000000;
        mem[8'b0000_0001]=32'b00000000100000111111111110101011;
        mem[8'b0000_0010]=32'b00000000100001111111110101010110;
        mem[8'b0000_0011]=32'b00000000100010111111011100001000;
        mem[8'b0000_0100]=32'b00000000100011111110101011001101;
        mem[8'b0000_0101]=32'b00000000100100111101011010111100;
        mem[8'b0000_0110]=32'b00000000100101111011100100000000;
        mem[8'b0000_0111]=32'b00000000100110111000111111010000;
        mem[8'b0000_1000]=32'b00000000100111110101100101111111;
        mem[8'b0000_1001]=32'b00000000101000110001010001110011;
        mem[8'b0000_1010]=32'b00000000101001101011111100110001;
        mem[8'b0000_1011]=32'b00000000101010100101100001011001;
        mem[8'b0000_1100]=32'b00000000101011011101111010101000;
        mem[8'b0000_1101]=32'b00000000101100010101000011111100;
        mem[8'b0000_1110]=32'b00000000101101001010111001010100;
        mem[8'b0000_1111]=32'b00000000101101111111010111001101;
        // End at 0.93750
        // Start at 1.0000
        mem[8'b0001_0000]=32'b00000000101110110010011010101000;
        mem[8'b0001_0001]=32'b00000000101111100100000001000010;
        mem[8'b0001_0010]=32'b00000000110000010100001000011100;
        mem[8'b0001_0011]=32'b00000000110001000010101111010010;
        mem[8'b0001_0100]=32'b00000000110001101111110100100000;
        mem[8'b0001_0101]=32'b00000000110010011011010111011100;
        mem[8'b0001_0110]=32'b00000000110011000101010111111000;
        mem[8'b0001_0111]=32'b00000000110011101101110101111110;
        mem[8'b0001_1000]=32'b00000000110100010100110010010000;
        mem[8'b0001_1001]=32'b00000000110100111010001101100010;
        mem[8'b0001_1010]=32'b00000000110101011110001001000000;
        mem[8'b0001_1011]=32'b00000000110110000000100110000010;
        mem[8'b0001_1100]=32'b00000000110110100001100110010100;
        mem[8'b0001_1101]=32'b00000000110111000001001011101100;
        mem[8'b0001_1110]=32'b00000000110111011111011000001110;
        mem[8'b0001_1111]=32'b00000000110111111100001110000111;
        // End at 1.93750
        // Start at 2.0000
        mem[8'b0010_0000]=32'b00000000111000010111101111101011;
        mem[8'b0010_0001]=32'b00000000111000110001111111010111;
        mem[8'b0010_0010]=32'b00000000111001001010111111101101;
        mem[8'b0010_0011]=32'b00000000111001100010110011010010;
        mem[8'b0010_0100]=32'b00000000111001111001011100101101;
        mem[8'b0010_0101]=32'b00000000111010001110111110101010;
        mem[8'b0010_0110]=32'b00000000111010100011011011110011;
        mem[8'b0010_0111]=32'b00000000111010110110110110110001;
        mem[8'b0010_1000]=32'b00000000111011001001010010001111;
        mem[8'b0010_1001]=32'b00000000111011011010110000110011;
        mem[8'b0010_1010]=32'b00000000111011101011010101000011;
        mem[8'b0010_1011]=32'b00000000111011111011000001100000;
        mem[8'b0010_1100]=32'b00000000111100001001111000101001;
        mem[8'b0010_1101]=32'b00000000111100010111111100111010;
        mem[8'b0010_1110]=32'b00000000111100100101010000101001;
        mem[8'b0010_1111]=32'b00000000111100110001110110001000;
        // End at 2.93750
        // Start at 3.0000
        mem[8'b0011_0000]=32'b00000000111100111101101111100110;
        mem[8'b0011_0001]=32'b00000000111101001000111111001011;
        mem[8'b0011_0010]=32'b00000000111101010011100110111101;
        mem[8'b0011_0011]=32'b00000000111101011101101000111011;
        mem[8'b0011_0100]=32'b00000000111101100111000110111111;
        mem[8'b0011_0101]=32'b00000000111101110000000010111111;
        mem[8'b0011_0110]=32'b00000000111101111000011110101101;
        mem[8'b0011_0111]=32'b00000000111110000000011011110101;
        mem[8'b0011_1000]=32'b00000000111110000111111011111110;
        mem[8'b0011_1001]=32'b00000000111110001111000000101100;
        mem[8'b0011_1010]=32'b00000000111110010101101011011100;
        mem[8'b0011_1011]=32'b00000000111110011011111101101001;
        mem[8'b0011_1100]=32'b00000000111110100001111000101000;
        mem[8'b0011_1101]=32'b00000000111110100111011101101011;
        mem[8'b0011_1110]=32'b00000000111110101100101110000000;
        mem[8'b0011_1111]=32'b00000000111110110001101010110000;
        // End at 3.93750
        // Start at 4.0000
        mem[8'b0100_0000]=32'b00000000111110110110010101000001;
        mem[8'b0100_0001]=32'b00000000111110111010101101110111;
        mem[8'b0100_0010]=32'b00000000111110111110110110001111;
        mem[8'b0100_0011]=32'b00000000111111000010101111000110;
        mem[8'b0100_0100]=32'b00000000111111000110011001010011;
        mem[8'b0100_0101]=32'b00000000111111001001110101101110;
        mem[8'b0100_0110]=32'b00000000111111001101000101001000;
        mem[8'b0100_0111]=32'b00000000111111010000001000010000;
        mem[8'b0100_1000]=32'b00000000111111010010111111110110;
        mem[8'b0100_1001]=32'b00000000111111010101101100100010;
        mem[8'b0100_1010]=32'b00000000111111011000001110111111;
        mem[8'b0100_1011]=32'b00000000111111011010100111110001;
        mem[8'b0100_1100]=32'b00000000111111011100110111011110;
        mem[8'b0100_1101]=32'b00000000111111011100110111011110;
        mem[8'b0100_1110]=32'b00000000111111100000111101101011;
        mem[8'b0100_1111]=32'b00000000111111100010110101001010;
        // End at 4.93750
        // Start at 5.0000
        mem[8'b0101_0000]=32'b00000000111111100100100101100001;
        mem[8'b0101_0001]=32'b00000000111111100110001111001001;
        mem[8'b0101_0010]=32'b00000000111111100111110010011101;
        mem[8'b0101_0011]=32'b00000000111111101001001111110100;
        mem[8'b0101_0100]=32'b00000000111111101010100111100101;
        mem[8'b0101_0101]=32'b00000000111111101011111010000101;
        mem[8'b0101_0110]=32'b00000000111111101101000111101000;
        mem[8'b0101_0111]=32'b00000000111111101110010000100001;
        mem[8'b0101_1000]=32'b00000000111111101111010101000010;
        mem[8'b0101_1001]=32'b00000000111111110000010101011100;
        mem[8'b0101_1010]=32'b00000000111111110001010001111101;
        mem[8'b0101_1011]=32'b00000000111111110010001010110110;
        mem[8'b0101_1100]=32'b00000000111111110011000000010011;
        mem[8'b0101_1101]=32'b00000000111111110011110010100011;
        mem[8'b0101_1110]=32'b00000000111111110100100001110000;
        mem[8'b0101_1111]=32'b00000000111111110101001110001000;
        // End at 5.93750
        // Start at 6.0000
        mem[8'b0110_0000]=32'b00000000111111110101110111110100;
        mem[8'b0110_0001]=32'b00000000111111110110011111000000;
        mem[8'b0110_0010]=32'b00000000111111110111000011110100;
        mem[8'b0110_0011]=32'b00000000111111110111100110011010;
        mem[8'b0110_0100]=32'b00000000111111111000000110111011;
        mem[8'b0110_0101]=32'b00000000111111111000100101011110;
        mem[8'b0110_0110]=32'b00000000111111111001000010001011;
        mem[8'b0110_0111]=32'b00000000111111111001011101001001;
        mem[8'b0110_1000]=32'b00000000111111111001110110011110;
        mem[8'b0110_1001]=32'b00000000111111111010001110010010;
        mem[8'b0110_1010]=32'b00000000111111111010100100101010;
        mem[8'b0110_1011]=32'b00000000111111111010111001101011;
        mem[8'b0110_1100]=32'b00000000111111111011001101011011;
        mem[8'b0110_1101]=32'b00000000111111111011011111111110;
        mem[8'b0110_1110]=32'b00000000111111111011110001011010;
        mem[8'b0110_1111]=32'b00000000111111111100000001110010;
        // End at 6.93750
        // Start at 7.0000
        mem[8'b0111_0000]=32'b00000000111111111100010001001011;
        mem[8'b0111_0001]=32'b00000000111111111100011111101000;
        mem[8'b0111_0010]=32'b00000000111111111100101101001110;
        mem[8'b0111_0011]=32'b00000000111111111100111001111110;
        mem[8'b0111_0100]=32'b00000000111111111101000101111110;
        mem[8'b0111_0101]=32'b00000000111111111101010001001111;
        mem[8'b0111_0110]=32'b00000000111111111101011011110100;
        mem[8'b0111_0111]=32'b00000000111111111101100101110000;
        mem[8'b0111_1000]=32'b00000000111111111101101111000110;
        mem[8'b0111_1001]=32'b00000000111111111101110111111000;
        mem[8'b0111_1010]=32'b00000000111111111110000000000111;
        mem[8'b0111_1011]=32'b00000000111111111110000111110111;
        mem[8'b0111_1100]=32'b00000000111111111110001111001000;
        mem[8'b0111_1101]=32'b00000000111111111110010101111110;
        mem[8'b0111_1110]=32'b00000000111111111110011100011001;
        mem[8'b0111_1111]=32'b00000000111111111110100010011011;
        // End at 7.93750
    end
    
    assign sig = mem[addr][29:14];
    
endmodule
