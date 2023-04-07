// *** Author : Erwin Ouyang
// *** Date   : 10 May 2018
`timescale 1ns / 1ps

module dnn_dp_tb();
    localparam T = 10;

    reg clk;
    reg rst_n;
    reg en;
    reg clr;
    reg signed [15:0] x0, x1, x2, x3, x4, x5, x6, x7;
    reg signed [15:0] w00, w01, w02, w03, w04, w05, w06, w07;
    reg signed [15:0] w10, w11, w12, w13, w14, w15, w16, w17;
    reg signed [15:0] w20, w21, w22, w23, w24, w25, w26, w27;
    reg signed [15:0] w30, w31, w32, w33, w34, w35, w36, w37;
    reg signed [15:0] w40, w41, w42, w43, w44, w45, w46, w47;
    reg signed [15:0] w50, w51, w52, w53, w54, w55, w56, w57;
    reg signed [15:0] w60, w61, w62, w63, w64, w65, w66, w67;
    reg signed [15:0] w70, w71, w72, w73, w74, w75, w76, w77;
    wire signed [15:0] a0, a1, a2, a3, a4, a5, a6, a7;
    
    dnn_dp uut
    (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .clr(clr),
        .x0(x0), .x1(x1), .x2(x2), .x3(x3), .x4(x4), .x5(x5), .x6(x6), .x7(x7),
        .w00(w00), .w01(w01), .w02(w02), .w03(w03), .w04(w04), .w05(w05), .w06(w06), .w07(w07),
        .w10(w10), .w11(w11), .w12(w12), .w13(w13), .w14(w14), .w15(w15), .w16(w16), .w17(w17),
        .w20(w20), .w21(w21), .w22(w22), .w23(w23), .w24(w24), .w25(w25), .w26(w26), .w27(w27),
        .w30(w30), .w31(w31), .w32(w32), .w33(w33), .w34(w34), .w35(w35), .w36(w36), .w37(w37),
        .w40(w40), .w41(w41), .w42(w42), .w43(w43), .w44(w44), .w45(w45), .w46(w46), .w47(w47),
        .w50(w50), .w51(w51), .w52(w52), .w53(w53), .w54(w54), .w55(w55), .w56(w56), .w57(w57),
        .w60(w60), .w61(w61), .w62(w62), .w63(w63), .w64(w64), .w65(w65), .w66(w66), .w67(w67),
        .w70(w70), .w71(w71), .w72(w72), .w73(w73), .w74(w74), .w75(w75), .w76(w76), .w77(w77),
        .a0(a0), .a1(a1), .a2(a2), .a3(a3), .a4(a4), .a5(a5), .a6(a6), .a7(a7)
    );
    
    always
    begin
        clk = 0;
        #(T/2);
        clk = 1;
        #(T/2);
    end
    
    initial
    begin
        rst_n = 0;
        en = 0;
        clr = 0;
        x0 = 0; x1 = 0; x2 = 0; x3 = 0; x4 = 0; x5 = 0; x6 = 0; x7 = 0;
        w00 = 0; w01 = 0; w02 = 0; w03 = 0; w04 = 0; w05 = 0; w06 = 0; w07 = 0;
        w10 = 0; w11 = 0; w12 = 0; w13 = 0; w14 = 0; w15 = 0; w16 = 0; w17 = 0;
        w20 = 0; w21 = 0; w22 = 0; w23 = 0; w24 = 0; w25 = 0; w26 = 0; w27 = 0;
        w30 = 0; w31 = 0; w32 = 0; w33 = 0; w34 = 0; w35 = 0; w36 = 0; w37 = 0;
        w40 = 0; w41 = 0; w42 = 0; w43 = 0; w44 = 0; w45 = 0; w46 = 0; w47 = 0;
        w50 = 0; w51 = 0; w52 = 0; w53 = 0; w54 = 0; w55 = 0; w56 = 0; w57 = 0;
        w60 = 0; w61 = 0; w62 = 0; w63 = 0; w64 = 0; w65 = 0; w66 = 0; w67 = 0;
        w70 = 0; w71 = 0; w72 = 0; w73 = 0; w74 = 0; w75 = 0; w76 = 0; w77 = 0;
        #(T*5);
        rst_n = 1;
        en = 1;
        #(T*5);
        
        // *** Input to hidden 1 ***
//        w00 = 512; w01 = 410; w02 = 205; w03 = 410; w04 = 0; w05 = 717; w06 = 819; w07 = 410;
        w00 = 16'b0000000001100110; w01 = 16'b00_0000_1011_0011_00;
        w02 = 16'b0000001100110011; w03 = 16'b0000001001100110;
        w04 = 16'b00_0000_0001_1001_10; w05 = 16'b0000000011001100;
        w06 = 16'b0000000001100110; w07 = 16'b00_0000_1011_0011_00;
        w10 = 717; w11 = 410; w12 = 102; w13 = 717; w14 = 819; w15 = 717; w16 = 410; w17 = 205;
        w20 = 512; w21 = 410; w22 = 717; w23 = 717; w24 = 205; w25 = 410; w26 = 922; w27 = 819;
        w30 = 1024; w31 = 819; w32 = 102; w33 = 512; w34 = 410; w35 = 0; w36 = 410; w37 = 922;
        w40 = 205; w41 = 614; w42 = 512; w43 = 307; w44 = 717; w45 = 307; w46 = 819; w47 = 307;
        w50 = 102; w51 = 819; w52 = 512; w53 = 102; w54 = 417; w55 = 417; w56 = 417; w57 = 717;
        
        x0 = 512; x1 = 0; x2 = 0; x3 = 0; x4 = 0; x5 = 0; x6 = 0; x7 = 0;
        #T;
        x0 = 717; x1 = 410; x2 = 0; x3 = 0; x4 = 0; x5 = 0; x6 = 0; x7 = 0;
        #T;
        x0 = 512; x1 = 410; x2 = 205; x3 = 0; x4 = 0; x5 = 0; x6 = 0; x7 = 0;
        #T;
        x0 = 1024; x1 = 410; x2 = 102; x3 = 410; x4 = 0; x5 = 0; x6 = 0; x7 = 0;
        #T;
        x0 = 205; x1 = 819; x2 = 717; x3 = 717; x4 = 0; x5 = 0; x6 = 0; x7 = 0;
        #T;
        x0 = 102; x1 = 614; x2 = 102; x3 = 717; x4 = 819; x5 = 717; x6 = 0; x7 = 0;
        #T;
        x0 = 102; x1 = 819; x2 = 512; x3 = 512; x4 = 205; x5 = 717; x6 = 0; x7 = 0;
        #T;
        x0 = 102; x1 = 922; x2 = 512; x3 = 307; x4 = 410; x5 = 410; x6 = 0; x7 = 0;
        #T;
        x0 = 0; x1 = 102; x2 = 922; x3 = 102; x4 = 717; x5 = 0; x6 = 0; x7 = 0;
        #T;
        x0 = 0; x1 = 0; x2 = 512; x3 = 614; x4 = 410; x5 = 307; x6 = 0; x7 = 0;
        #T;
        x0 = 0; x1 = 0; x2 = 0; x3 = 307; x4 = 717; x5 = 410; x6 = 0; x7 = 0;
        #T;
        x0 = 0; x1 = 0; x2 = 0; x3 = 0; x4 = 410; x5 = 307; x6 = 0; x7 = 0;
        #T;
        x0 = 0; x1 = 0; x2 = 0; x3 = 0; x4 = 0; x5 = 205; x6 = 0; x7 = 0;                                                                     
        #T;
        x0 = 0; x1 = 0; x2 = 0; x3 = 0; x4 = 0; x5 = 0; x6 = 0; x7 = 0;
        #T;
        
    end

endmodule