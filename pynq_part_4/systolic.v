module systolic
    #( 
        parameter WIDTH = 16,
        parameter FRAC_BIT = 10
    )
    (
        input wire                     clk,
        input wire                     rst_n,
        input wire                     en,
        input wire                     clr,
        input wire signed [WIDTH-1:0]  a0, a1, a2, a3, a4, a5,
        input wire                     in_valid,
        input wire signed [WIDTH-1:0]  b00, b01, b02, b03, b04, b05,
        input wire signed [WIDTH-1:0]  b10, b11, b12, b13, b14, b15,
        input wire signed [WIDTH-1:0]  b20, b21, b22, b23, b24, b25,
        input wire signed [WIDTH-1:0]  b30, b31, b32, b33, b34, b35,
        input wire signed [WIDTH-1:0]  b40, b41, b42, b43, b44, b45,
        input wire signed [WIDTH-1:0]  b50, b51, b52, b53, b54, b55,
        output wire signed [WIDTH-1:0] y0, y1, y2, y3, y4, y5,  
        output wire                    out_valid  
    );
    
    // *** Input registers ***
    wire signed [WIDTH-1:0] a0_reg0;
    wire signed [WIDTH-1:0] a1_reg0, a1_reg1;
    wire signed [WIDTH-1:0] a2_reg0, a2_reg1, a2_reg2; 
    wire signed [WIDTH-1:0] a3_reg0, a3_reg1, a3_reg2, a3_reg3;
    wire signed [WIDTH-1:0] a4_reg0, a4_reg1, a4_reg2, a4_reg3, a4_reg4;
    wire signed [WIDTH-1:0] a5_reg0, a5_reg1, a5_reg2, a5_reg3, a5_reg4, a5_reg5;
    
    // *** a in ***
    wire signed [WIDTH-1:0] a00_in, a01_in, a02_in, a03_in, a04_in, a05_in,
                            a10_in, a11_in, a12_in, a13_in, a14_in, a15_in,
                            a20_in, a21_in, a22_in, a23_in, a24_in, a25_in,
                            a30_in, a31_in, a32_in, a33_in, a34_in, a35_in,
                            a40_in, a41_in, a42_in, a43_in, a44_in, a45_in,
                            a50_in, a51_in, a52_in, a53_in, a54_in, a55_in;
    // *** y in ***
    wire signed [WIDTH-1:0] y00_in, y01_in, y02_in, y03_in, y04_in, y05_in,
                            y10_in, y11_in, y12_in, y13_in, y14_in, y15_in,
                            y20_in, y21_in, y22_in, y23_in, y24_in, y25_in,
                            y30_in, y31_in, y32_in, y33_in, y34_in, y35_in,
                            y40_in, y41_in, y42_in, y43_in, y44_in, y45_in,
                            y50_in, y51_in, y52_in, y53_in, y54_in, y55_in;
    // *** a out ***
    wire signed [WIDTH-1:0] a00_out, a01_out, a02_out, a03_out, a04_out, a05_out,
                            a10_out, a11_out, a12_out, a13_out, a14_out, a15_out,
                            a20_out, a21_out, a22_out, a23_out, a24_out, a25_out,
                            a30_out, a31_out, a32_out, a33_out, a34_out, a35_out,
                            a40_out, a41_out, a42_out, a43_out, a44_out, a45_out,
                            a50_out, a51_out, a52_out, a53_out, a54_out, a55_out;
    // *** y out ***
    wire signed [WIDTH-1:0] y00_out, y01_out, y02_out, y03_out, y04_out, y05_out,
                            y10_out, y11_out, y12_out, y13_out, y14_out, y15_out,
                            y20_out, y21_out, y22_out, y23_out, y24_out, y25_out,
                            y30_out, y31_out, y32_out, y33_out, y34_out, y35_out,
                            y40_out, y41_out, y42_out, y43_out, y44_out, y45_out,
                            y50_out, y51_out, y52_out, y53_out, y54_out, y55_out;
    
    // *** Output registers ***
    wire signed [WIDTH-1:0] y0_tmp, y1_tmp, y2_tmp, y3_tmp, y4_tmp, y5_tmp; 
    wire signed [WIDTH-1:0] y0_reg0, y0_reg1, y0_reg2, y0_reg3, y0_reg4, y0_reg5;
    wire signed [WIDTH-1:0] y1_reg0, y1_reg1, y1_reg2, y1_reg3, y1_reg4;
    wire signed [WIDTH-1:0] y2_reg0, y2_reg1, y2_reg2, y2_reg3; 
    wire signed [WIDTH-1:0] y3_reg0, y3_reg1, y3_reg2;
    wire signed [WIDTH-1:0] y4_reg0, y4_reg1;
    wire signed [WIDTH-1:0] y5_reg0;
    
    // *** Valid registers ***
    wire in_valid_reg0, in_valid_reg1, in_valid_reg2, in_valid_reg3, in_valid_reg4, in_valid_reg5, in_valid_reg6, in_valid_reg7, in_valid_reg8, in_valid_reg9, in_valid_reg10, in_valid_reg11, in_valid_reg12;
    
    // *** Input registers for systolic data setup ***
    register #(WIDTH) reg_a0_0(clk, rst_n, en, clr, a0,      a0_reg0); 
    
    register #(WIDTH) reg_a1_0(clk, rst_n, en, clr, a1,      a1_reg0); 
    register #(WIDTH) reg_a1_1(clk, rst_n, en, clr, a1_reg0, a1_reg1); 
    
    register #(WIDTH) reg_a2_0(clk, rst_n, en, clr, a2,      a2_reg0);
    register #(WIDTH) reg_a2_1(clk, rst_n, en, clr, a2_reg0, a2_reg1);
    register #(WIDTH) reg_a2_2(clk, rst_n, en, clr, a2_reg1, a2_reg2);
    
    register #(WIDTH) reg_a3_0(clk, rst_n, en, clr, a3,      a3_reg0);
    register #(WIDTH) reg_a3_1(clk, rst_n, en, clr, a3_reg0, a3_reg1);
    register #(WIDTH) reg_a3_2(clk, rst_n, en, clr, a3_reg1, a3_reg2);
    register #(WIDTH) reg_a3_3(clk, rst_n, en, clr, a3_reg2, a3_reg3);
    
    register #(WIDTH) reg_a4_0(clk, rst_n, en, clr, a4,      a4_reg0);
    register #(WIDTH) reg_a4_1(clk, rst_n, en, clr, a4_reg0, a4_reg1);
    register #(WIDTH) reg_a4_2(clk, rst_n, en, clr, a4_reg1, a4_reg2);
    register #(WIDTH) reg_a4_3(clk, rst_n, en, clr, a4_reg2, a4_reg3);
    register #(WIDTH) reg_a4_4(clk, rst_n, en, clr, a4_reg3, a4_reg4);
    
    register #(WIDTH) reg_a5_0(clk, rst_n, en, clr, a5,      a5_reg0);
    register #(WIDTH) reg_a5_1(clk, rst_n, en, clr, a5_reg0, a5_reg1);
    register #(WIDTH) reg_a5_2(clk, rst_n, en, clr, a5_reg1, a5_reg2);
    register #(WIDTH) reg_a5_3(clk, rst_n, en, clr, a5_reg2, a5_reg3);
    register #(WIDTH) reg_a5_4(clk, rst_n, en, clr, a5_reg3, a5_reg4);
    register #(WIDTH) reg_a5_5(clk, rst_n, en, clr, a5_reg4, a5_reg5);
                
    // *** First x inputs ***
    assign a00_in = a0_reg0;
    assign a10_in = a1_reg1;
    assign a20_in = a2_reg2;
    assign a30_in = a3_reg3;
    assign a40_in = a4_reg4;
    assign a50_in = a5_reg5;
    
    // *** First z inputs ***
    assign y00_in = 0;
    assign y01_in = 0;
    assign y02_in = 0;
    assign y03_in = 0;
    assign y04_in = 0;
    assign y05_in = 0;
    
    // *** 6x6 systolic array ***
    // *** Row 0 from bottom ***
    pe #(WIDTH, FRAC_BIT) pe00(a00_in, y00_in, b00, a00_out, y00_out);
    pe #(WIDTH, FRAC_BIT) pe01(a01_in, y01_in, b01, a01_out, y01_out);
    pe #(WIDTH, FRAC_BIT) pe02(a02_in, y02_in, b02, a02_out, y02_out);
    pe #(WIDTH, FRAC_BIT) pe03(a03_in, y03_in, b03, a03_out, y03_out);
    pe #(WIDTH, FRAC_BIT) pe04(a04_in, y04_in, b04, a04_out, y04_out);
    pe #(WIDTH, FRAC_BIT) pe05(a05_in, y05_in, b05, a05_out, y05_out);
    // *** Row 1 from bottom ***
    pe #(WIDTH, FRAC_BIT) pe10(a10_in, y10_in, b10, a10_out, y10_out);
    pe #(WIDTH, FRAC_BIT) pe11(a11_in, y11_in, b11, a11_out, y11_out);
    pe #(WIDTH, FRAC_BIT) pe12(a12_in, y12_in, b12, a12_out, y12_out);
    pe #(WIDTH, FRAC_BIT) pe13(a13_in, y13_in, b13, a13_out, y13_out);
    pe #(WIDTH, FRAC_BIT) pe14(a14_in, y14_in, b14, a14_out, y14_out);
    pe #(WIDTH, FRAC_BIT) pe15(a15_in, y15_in, b15, a15_out, y15_out);
    // *** Row 2 from bottom ***
    pe #(WIDTH, FRAC_BIT) pe20(a20_in, y20_in, b20, a20_out, y20_out);
    pe #(WIDTH, FRAC_BIT) pe21(a21_in, y21_in, b21, a21_out, y21_out);
    pe #(WIDTH, FRAC_BIT) pe22(a22_in, y22_in, b22, a22_out, y22_out);
    pe #(WIDTH, FRAC_BIT) pe23(a23_in, y23_in, b23, a23_out, y23_out);
    pe #(WIDTH, FRAC_BIT) pe24(a24_in, y24_in, b24, a24_out, y24_out);
    pe #(WIDTH, FRAC_BIT) pe25(a25_in, y25_in, b25, a25_out, y25_out);
    // *** Row 3 from bottom ***
    pe #(WIDTH, FRAC_BIT) pe30(a30_in, y30_in, b30, a30_out, y30_out);
    pe #(WIDTH, FRAC_BIT) pe31(a31_in, y31_in, b31, a31_out, y31_out);
    pe #(WIDTH, FRAC_BIT) pe32(a32_in, y32_in, b32, a32_out, y32_out);
    pe #(WIDTH, FRAC_BIT) pe33(a33_in, y33_in, b33, a33_out, y33_out);
    pe #(WIDTH, FRAC_BIT) pe34(a34_in, y34_in, b34, a34_out, y34_out);
    pe #(WIDTH, FRAC_BIT) pe35(a35_in, y35_in, b35, a35_out, y35_out);
    // *** Row 4 from bottom ***
    pe #(WIDTH, FRAC_BIT) pe40(a40_in, y40_in, b40, a40_out, y40_out);
    pe #(WIDTH, FRAC_BIT) pe41(a41_in, y41_in, b41, a41_out, y41_out);
    pe #(WIDTH, FRAC_BIT) pe42(a42_in, y42_in, b42, a42_out, y42_out);
    pe #(WIDTH, FRAC_BIT) pe43(a43_in, y43_in, b43, a43_out, y43_out);
    pe #(WIDTH, FRAC_BIT) pe44(a44_in, y44_in, b44, a44_out, y44_out);
    pe #(WIDTH, FRAC_BIT) pe45(a45_in, y45_in, b45, a45_out, y45_out);
    // *** Row 5 from bottom ***
    pe #(WIDTH, FRAC_BIT) pe50(a50_in, y50_in, b50, a50_out, y50_out);
    pe #(WIDTH, FRAC_BIT) pe51(a51_in, y51_in, b51, a51_out, y51_out);
    pe #(WIDTH, FRAC_BIT) pe52(a52_in, y52_in, b52, a52_out, y52_out);
    pe #(WIDTH, FRAC_BIT) pe53(a53_in, y53_in, b53, a53_out, y53_out);
    pe #(WIDTH, FRAC_BIT) pe54(a54_in, y54_in, b54, a54_out, y54_out);
    pe #(WIDTH, FRAC_BIT) pe55(a55_in, y55_in, b55, a55_out, y55_out);
    
    // *** Internal registers ***
    // *** Row 0 from bottom ***
    register #(WIDTH) reg_a00(clk, rst_n, en, clr, a00_out, a01_in); 
    register #(WIDTH) reg_a01(clk, rst_n, en, clr, a01_out, a02_in);
    register #(WIDTH) reg_a02(clk, rst_n, en, clr, a02_out, a03_in);
    register #(WIDTH) reg_a03(clk, rst_n, en, clr, a03_out, a04_in);
    register #(WIDTH) reg_a04(clk, rst_n, en, clr, a04_out, a05_in);
    // *** Row 1 from bottom ***
    register #(WIDTH) reg_a10(clk, rst_n, en, clr, a10_out, a11_in); 
    register #(WIDTH) reg_a11(clk, rst_n, en, clr, a11_out, a12_in);
    register #(WIDTH) reg_a12(clk, rst_n, en, clr, a12_out, a13_in);
    register #(WIDTH) reg_a13(clk, rst_n, en, clr, a13_out, a14_in);
    register #(WIDTH) reg_a14(clk, rst_n, en, clr, a14_out, a15_in);
    // *** Row 2 from bottom ***
    register #(WIDTH) reg_a20(clk, rst_n, en, clr, a20_out, a21_in); 
    register #(WIDTH) reg_a21(clk, rst_n, en, clr, a21_out, a22_in);
    register #(WIDTH) reg_a22(clk, rst_n, en, clr, a22_out, a23_in);
    register #(WIDTH) reg_a23(clk, rst_n, en, clr, a23_out, a24_in);
    register #(WIDTH) reg_a24(clk, rst_n, en, clr, a24_out, a25_in);
    // *** Row 3 from bottom ***
    register #(WIDTH) reg_a30(clk, rst_n, en, clr, a30_out, a31_in); 
    register #(WIDTH) reg_a31(clk, rst_n, en, clr, a31_out, a32_in);
    register #(WIDTH) reg_a32(clk, rst_n, en, clr, a32_out, a33_in);
    register #(WIDTH) reg_a33(clk, rst_n, en, clr, a33_out, a34_in);
    register #(WIDTH) reg_a34(clk, rst_n, en, clr, a34_out, a35_in);
    // *** Row 4 from bottom ***
    register #(WIDTH) reg_a40(clk, rst_n, en, clr, a40_out, a41_in); 
    register #(WIDTH) reg_a41(clk, rst_n, en, clr, a41_out, a42_in);
    register #(WIDTH) reg_a42(clk, rst_n, en, clr, a42_out, a43_in);
    register #(WIDTH) reg_a43(clk, rst_n, en, clr, a43_out, a44_in);
    register #(WIDTH) reg_a44(clk, rst_n, en, clr, a44_out, a45_in);
    // *** Row 5 from bottom ***
    register #(WIDTH) reg_a50(clk, rst_n, en, clr, a50_out, a51_in); 
    register #(WIDTH) reg_a51(clk, rst_n, en, clr, a51_out, a52_in);
    register #(WIDTH) reg_a52(clk, rst_n, en, clr, a52_out, a53_in);
    register #(WIDTH) reg_a53(clk, rst_n, en, clr, a53_out, a54_in);
    register #(WIDTH) reg_a54(clk, rst_n, en, clr, a54_out, a55_in);
    
    // *** Column 0 from left ***
    register #(WIDTH) reg_y00(clk, rst_n, en, clr, y00_out, y10_in);
    register #(WIDTH) reg_y10(clk, rst_n, en, clr, y10_out, y20_in);
    register #(WIDTH) reg_y20(clk, rst_n, en, clr, y20_out, y30_in);
    register #(WIDTH) reg_y30(clk, rst_n, en, clr, y30_out, y40_in);
    register #(WIDTH) reg_y40(clk, rst_n, en, clr, y40_out, y50_in);
    register #(WIDTH) reg_y50(clk, rst_n, en, clr, y50_out, y0_tmp);
    // *** Column 1 from left ***
    register #(WIDTH) reg_y01(clk, rst_n, en, clr, y01_out, y11_in);
    register #(WIDTH) reg_y11(clk, rst_n, en, clr, y11_out, y21_in);
    register #(WIDTH) reg_y21(clk, rst_n, en, clr, y21_out, y31_in);
    register #(WIDTH) reg_y31(clk, rst_n, en, clr, y31_out, y41_in);
    register #(WIDTH) reg_y41(clk, rst_n, en, clr, y41_out, y51_in);
    register #(WIDTH) reg_y51(clk, rst_n, en, clr, y51_out, y1_tmp);
    // *** Column 2 from left ***
    register #(WIDTH) reg_y02(clk, rst_n, en, clr, y02_out, y12_in);
    register #(WIDTH) reg_y12(clk, rst_n, en, clr, y12_out, y22_in);
    register #(WIDTH) reg_y22(clk, rst_n, en, clr, y22_out, y32_in);
    register #(WIDTH) reg_y32(clk, rst_n, en, clr, y32_out, y42_in);
    register #(WIDTH) reg_y42(clk, rst_n, en, clr, y42_out, y52_in);
    register #(WIDTH) reg_y52(clk, rst_n, en, clr, y52_out, y2_tmp);
    // *** Column 3 from left ***
    register #(WIDTH) reg_y03(clk, rst_n, en, clr, y03_out, y13_in);
    register #(WIDTH) reg_y13(clk, rst_n, en, clr, y13_out, y23_in);
    register #(WIDTH) reg_y23(clk, rst_n, en, clr, y23_out, y33_in);
    register #(WIDTH) reg_y33(clk, rst_n, en, clr, y33_out, y43_in);
    register #(WIDTH) reg_y43(clk, rst_n, en, clr, y43_out, y53_in);
    register #(WIDTH) reg_y53(clk, rst_n, en, clr, y53_out, y3_tmp);
    // *** Column 4 from left ***
    register #(WIDTH) reg_y04(clk, rst_n, en, clr, y04_out, y14_in);
    register #(WIDTH) reg_y14(clk, rst_n, en, clr, y14_out, y24_in);
    register #(WIDTH) reg_y24(clk, rst_n, en, clr, y24_out, y34_in);
    register #(WIDTH) reg_y34(clk, rst_n, en, clr, y34_out, y44_in);
    register #(WIDTH) reg_y44(clk, rst_n, en, clr, y44_out, y54_in);
    register #(WIDTH) reg_y54(clk, rst_n, en, clr, y54_out, y4_tmp);
    // *** Column 5 from left ***
    register #(WIDTH) reg_y05(clk, rst_n, en, clr, y05_out, y15_in);
    register #(WIDTH) reg_y15(clk, rst_n, en, clr, y15_out, y25_in);
    register #(WIDTH) reg_y25(clk, rst_n, en, clr, y25_out, y35_in);
    register #(WIDTH) reg_y35(clk, rst_n, en, clr, y35_out, y45_in);
    register #(WIDTH) reg_y45(clk, rst_n, en, clr, y45_out, y55_in);
    register #(WIDTH) reg_y55(clk, rst_n, en, clr, y55_out, y5_tmp);

    // *** Output registers ***
    register #(WIDTH) reg_y0_0(clk, rst_n, en, clr, y0_tmp,  y0_reg0); 
    register #(WIDTH) reg_y0_1(clk, rst_n, en, clr, y0_reg0, y0_reg1); 
    register #(WIDTH) reg_y0_2(clk, rst_n, en, clr, y0_reg1, y0_reg2); 
    register #(WIDTH) reg_y0_3(clk, rst_n, en, clr, y0_reg2, y0_reg3);
    register #(WIDTH) reg_y0_4(clk, rst_n, en, clr, y0_reg3, y0_reg4);
    register #(WIDTH) reg_y0_5(clk, rst_n, en, clr, y0_reg4, y0_reg5);
    
    register #(WIDTH) reg_y1_0(clk, rst_n, en, clr, y1_tmp,  y1_reg0);
    register #(WIDTH) reg_y1_1(clk, rst_n, en, clr, y1_reg0, y1_reg1);
    register #(WIDTH) reg_y1_2(clk, rst_n, en, clr, y1_reg1, y1_reg2);
    register #(WIDTH) reg_y1_3(clk, rst_n, en, clr, y1_reg2, y1_reg3);
    register #(WIDTH) reg_y1_4(clk, rst_n, en, clr, y1_reg3, y1_reg4);
    
    register #(WIDTH) reg_y2_0(clk, rst_n, en, clr, y2_tmp,  y2_reg0);
    register #(WIDTH) reg_y2_1(clk, rst_n, en, clr, y2_reg0, y2_reg1);
    register #(WIDTH) reg_y2_2(clk, rst_n, en, clr, y2_reg1, y2_reg2);
    register #(WIDTH) reg_y2_3(clk, rst_n, en, clr, y2_reg2, y2_reg3);
    
    register #(WIDTH) reg_y3_0(clk, rst_n, en, clr, y3_tmp,  y3_reg0);
    register #(WIDTH) reg_y3_1(clk, rst_n, en, clr, y3_reg0, y3_reg1);
    register #(WIDTH) reg_y3_2(clk, rst_n, en, clr, y3_reg1, y3_reg2);

    register #(WIDTH) reg_y4_0(clk, rst_n, en, clr, y4_tmp,  y4_reg0);
    register #(WIDTH) reg_y4_1(clk, rst_n, en, clr, y4_reg0, y4_reg1);

    register #(WIDTH) reg_y5_0(clk, rst_n, en, clr, y5_tmp,  y5_reg0);

    // *** Valid registers ***
    register #(1) reg_valid_0(clk, rst_n, en, clr, in_valid,      in_valid_reg0); 
    register #(1) reg_valid_1(clk, rst_n, en, clr, in_valid_reg0, in_valid_reg1);
    register #(1) reg_valid_2(clk, rst_n, en, clr, in_valid_reg1, in_valid_reg2);
    register #(1) reg_valid_3(clk, rst_n, en, clr, in_valid_reg2, in_valid_reg3);
    register #(1) reg_valid_4(clk, rst_n, en, clr, in_valid_reg3, in_valid_reg4);
    register #(1) reg_valid_5(clk, rst_n, en, clr, in_valid_reg4, in_valid_reg5);
    register #(1) reg_valid_6(clk, rst_n, en, clr, in_valid_reg5, in_valid_reg6);
    register #(1) reg_valid_7(clk, rst_n, en, clr, in_valid_reg6, in_valid_reg7);
    register #(1) reg_valid_8(clk, rst_n, en, clr, in_valid_reg7, in_valid_reg8);
    register #(1) reg_valid_9(clk, rst_n, en, clr, in_valid_reg8, in_valid_reg9);
    register #(1) reg_valid_10(clk, rst_n, en, clr, in_valid_reg9, in_valid_reg10);
    register #(1) reg_valid_11(clk, rst_n, en, clr, in_valid_reg10, in_valid_reg11);
    register #(1) reg_valid_12(clk, rst_n, en, clr, in_valid_reg11, in_valid_reg12);

    // *** Outputs ***
    assign y0 = y0_reg5;
    assign y1 = y1_reg4;
    assign y2 = y2_reg3;
    assign y3 = y3_reg2;
    assign y4 = y4_reg1;
    assign y5 = y5_reg0;
    assign out_valid = in_valid_reg12;

endmodule
