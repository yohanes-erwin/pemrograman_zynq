module ann
    (
        input wire          clk,
        input wire          rst_n,
        input wire          en,
        input wire          clr,
        // *** Control and status port ***
        output wire         ready,
        input wire          start,
        output wire         done,
        // *** Weight port ***
        input wire          wb_ena,
        input wire [2:0]    wb_addra,
        input wire [127:0]  wb_dina,
        input wire [15:0]   wb_wea,
        // *** Data input port ***
        input wire          k_ena,
        input wire [1:0]    k_addra,
        input wire [127:0]  k_dina,
        input wire [15:0]   k_wea,
        // *** Data output port ***
        input wire          a_enb,
        input wire [1:0]    a_addrb,
        output wire [127:0] a_doutb
    );

    // Weight BRAM
    wire wb_enb;
    wire [2:0] wb_addrb;
    wire [127:0] wb_doutb;

    wire [15:0] wb_doutb_0;
    wire [15:0] wb_doutb_1;
    wire [15:0] wb_doutb_2;
    wire [15:0] wb_doutb_3;
    wire [15:0] wb_doutb_4;
    wire [15:0] wb_doutb_5;
        
    // Input BRAM
    wire k_enb;
    wire [1:0] k_addrb;
    wire [127:0] k_doutb;
    
    wire [15:0] k_doutb_0;
    wire [15:0] k_doutb_1;
    wire [15:0] k_doutb_2;
    wire [15:0] k_doutb_3;
    wire [15:0] k_doutb_4;
    wire [15:0] k_doutb_5;

    // Counter for main controller 
    reg [5:0] cnt_main_reg;

    // Multiplexer and register for systolic moving input
    wire [0:0] a0_sel, a1_sel, a2_sel, a3_sel, a4_sel, a5_sel;
    wire [15:0] a0, a1, a2, a3, a4, a5;

    // Multiplexer and register for systolic stationary input
    wire [1:0] b00_sel, b01_sel, b02_sel, b03_sel, b04_sel, b05_sel;
    wire [1:0] b10_sel, b11_sel, b12_sel, b13_sel, b14_sel, b15_sel;
    wire [1:0] b20_sel, b21_sel, b22_sel, b23_sel, b24_sel, b25_sel;
    wire [1:0] b30_sel, b31_sel, b32_sel, b33_sel, b34_sel, b35_sel;
    wire [1:0] b40_sel, b41_sel, b42_sel, b43_sel, b44_sel, b45_sel;
    wire [1:0] b50_sel, b51_sel, b52_sel, b53_sel, b54_sel, b55_sel;
    
    wire [15:0] b00_next, b01_next, b02_next, b03_next, b04_next, b05_next;
    wire [15:0] b10_next, b11_next, b12_next, b13_next, b14_next, b15_next;
    wire [15:0] b20_next, b21_next, b22_next, b23_next, b24_next, b25_next;
    wire [15:0] b30_next, b31_next, b32_next, b33_next, b34_next, b35_next;
    wire [15:0] b40_next, b41_next, b42_next, b43_next, b44_next, b45_next;
    wire [15:0] b50_next, b51_next, b52_next, b53_next, b54_next, b55_next;
    
    wire [15:0] b00_reg, b01_reg, b02_reg, b03_reg, b04_reg, b05_reg;
    wire [15:0] b10_reg, b11_reg, b12_reg, b13_reg, b14_reg, b15_reg;
    wire [15:0] b20_reg, b21_reg, b22_reg, b23_reg, b24_reg, b25_reg;
    wire [15:0] b30_reg, b31_reg, b32_reg, b33_reg, b34_reg, b35_reg;
    wire [15:0] b40_reg, b41_reg, b42_reg, b43_reg, b44_reg, b45_reg;
    wire [15:0] b50_reg, b51_reg, b52_reg, b53_reg, b54_reg, b55_reg;
    
    // Systolic
    wire sys_in_valid;
    wire [15:0] y0, y1, y2, y3, y4, y5;
    wire sys_out_valid;

    // Sigmoid
    wire [15:0] s0, s1, s2, s3, s4, s5;
    wire sig_out_valid;
    
    wire [15:0] s0_reg0, s0_reg1, s0_reg2, s0_reg3;
    wire [15:0] s1_reg0, s1_reg1, s1_reg2, s1_reg3;
    wire [15:0] s2_reg0, s2_reg1, s2_reg2, s2_reg3;
    wire [15:0] s3_reg0, s3_reg1, s3_reg2, s3_reg3;
    wire [15:0] s4_reg0, s4_reg1, s4_reg2, s4_reg3;
    wire [15:0] s5_reg0, s5_reg1, s5_reg2, s5_reg3;

    wire sig_out_valid_reg0, sig_out_valid_reg1, sig_out_valid_reg2, sig_out_valid_reg3;

    // Output BRAM
    wire a_ena;
    wire [15:0] a_wea;
    wire [1:0] a_addra;
    wire [127:0] a_dina;
            
    // *** Weight BRAM **********************************************************
    // xpm_memory_tdpram: True Dual Port RAM
    // Xilinx Parameterized Macro, version 2018.3
    xpm_memory_tdpram
    #(
        // Common module parameters
        .MEMORY_SIZE(1024),                  // DECIMAL, size: 8x128bit= 1024 bits
        .MEMORY_PRIMITIVE("auto"),           // String
        .CLOCKING_MODE("common_clock"),      // String, "common_clock"
        .MEMORY_INIT_FILE("none"),           // String
        .MEMORY_INIT_PARAM("0"),             // String      
        .USE_MEM_INIT(1),                    // DECIMAL
        .WAKEUP_TIME("disable_sleep"),       // String
        .MESSAGE_CONTROL(0),                 // DECIMAL
        .AUTO_SLEEP_TIME(0),                 // DECIMAL          
        .ECC_MODE("no_ecc"),                 // String
        .MEMORY_OPTIMIZATION("true"),        // String              
        .USE_EMBEDDED_CONSTRAINT(0),         // DECIMAL
        
        // Port A module parameters
        .WRITE_DATA_WIDTH_A(128),            // DECIMAL, data width: 128-bit
        .READ_DATA_WIDTH_A(128),             // DECIMAL, data width: 128-bit
        .BYTE_WRITE_WIDTH_A(8),              // DECIMAL
        .ADDR_WIDTH_A(3),                    // DECIMAL, clog2(1024/128)=clog2(8)= 3
        .READ_RESET_VALUE_A("0"),            // String
        .READ_LATENCY_A(1),                  // DECIMAL
        .WRITE_MODE_A("write_first"),        // String
        .RST_MODE_A("SYNC"),                 // String
        
        // Port B module parameters  
        .WRITE_DATA_WIDTH_B(128),            // DECIMAL, data width: 128-bit
        .READ_DATA_WIDTH_B(128),             // DECIMAL, data width: 128-bit
        .BYTE_WRITE_WIDTH_B(8),              // DECIMAL
        .ADDR_WIDTH_B(3),                    // DECIMAL, clog2(1024/128)=clog2(8)= 3
        .READ_RESET_VALUE_B("0"),            // String
        .READ_LATENCY_B(1),                  // DECIMAL
        .WRITE_MODE_B("write_first"),        // String
        .RST_MODE_B("SYNC")                  // String
    )
    xpm_memory_tdpram_wb
    (
        .sleep(1'b0),
        .regcea(1'b1), //do not change
        .injectsbiterra(1'b0), //do not change
        .injectdbiterra(1'b0), //do not change   
        .sbiterra(), //do not change
        .dbiterra(), //do not change
        .regceb(1'b1), //do not change
        .injectsbiterrb(1'b0), //do not change
        .injectdbiterrb(1'b0), //do not change              
        .sbiterrb(), //do not change
        .dbiterrb(), //do not change
        
        // Port A module ports
        .clka(clk),
        .rsta(~rst_n),
        .ena(wb_ena),
        .wea(wb_wea),
        .addra(wb_addra),
        .dina(wb_dina),
        .douta(),
        
        // Port B module ports
        .clkb(clk),
        .rstb(~rst_n),
        .enb(wb_enb),
        .web(0),
        .addrb(wb_addrb),
        .dinb(0),
        .doutb(wb_doutb)
    );
    assign wb_doutb_0 = wb_doutb[15:0];
    assign wb_doutb_1 = wb_doutb[31:16];
    assign wb_doutb_2 = wb_doutb[47:32];
    assign wb_doutb_3 = wb_doutb[63:48];
    assign wb_doutb_4 = wb_doutb[79:64];
    assign wb_doutb_5 = wb_doutb[95:80];

    // *** Input BRAM ***********************************************************  
    // xpm_memory_tdpram: True Dual Port RAM
    // Xilinx Parameterized Macro, version 2018.3
    xpm_memory_tdpram
    #(
        // Common module parameters
        .MEMORY_SIZE(512),                   // DECIMAL, size: 4x128bit= 512 bits
        .MEMORY_PRIMITIVE("auto"),           // String
        .CLOCKING_MODE("common_clock"),      // String, "common_clock"
        .MEMORY_INIT_FILE("none"),           // String
        .MEMORY_INIT_PARAM("0"),             // String      
        .USE_MEM_INIT(1),                    // DECIMAL
        .WAKEUP_TIME("disable_sleep"),       // String
        .MESSAGE_CONTROL(0),                 // DECIMAL
        .AUTO_SLEEP_TIME(0),                 // DECIMAL          
        .ECC_MODE("no_ecc"),                 // String
        .MEMORY_OPTIMIZATION("true"),        // String              
        .USE_EMBEDDED_CONSTRAINT(0),         // DECIMAL
        
        // Port A module parameters
        .WRITE_DATA_WIDTH_A(128),            // DECIMAL, data width: 128-bit
        .READ_DATA_WIDTH_A(128),             // DECIMAL, data width: 128-bit
        .BYTE_WRITE_WIDTH_A(8),              // DECIMAL
        .ADDR_WIDTH_A(2),                    // DECIMAL, clog2(512/128)=clog2(4)= 2
        .READ_RESET_VALUE_A("0"),            // String
        .READ_LATENCY_A(1),                  // DECIMAL
        .WRITE_MODE_A("write_first"),        // String
        .RST_MODE_A("SYNC"),                 // String
        
        // Port B module parameters  
        .WRITE_DATA_WIDTH_B(128),            // DECIMAL, data width: 128-bit
        .READ_DATA_WIDTH_B(128),             // DECIMAL, data width: 128-bit
        .BYTE_WRITE_WIDTH_B(8),              // DECIMAL
        .ADDR_WIDTH_B(2),                    // DECIMAL, clog2(512/128)=clog2(4)= 2
        .READ_RESET_VALUE_B("0"),            // String
        .READ_LATENCY_B(1),                  // DECIMAL
        .WRITE_MODE_B("write_first"),        // String
        .RST_MODE_B("SYNC")                  // String
    )
    xpm_memory_tdpram_k
    (
        .sleep(1'b0),
        .regcea(1'b1), //do not change
        .injectsbiterra(1'b0), //do not change
        .injectdbiterra(1'b0), //do not change   
        .sbiterra(), //do not change
        .dbiterra(), //do not change
        .regceb(1'b1), //do not change
        .injectsbiterrb(1'b0), //do not change
        .injectdbiterrb(1'b0), //do not change              
        .sbiterrb(), //do not change
        .dbiterrb(), //do not change
        
        // Port A module ports
        .clka(clk),
        .rsta(~rst_n),
        .ena(k_ena),
        .wea(k_wea),
        .addra(k_addra),
        .dina(k_dina),
        .douta(),
        
        // Port B module ports
        .clkb(clk),
        .rstb(~rst_n),
        .enb(k_enb),
        .web(0),
        .addrb(k_addrb),
        .dinb(0),
        .doutb(k_doutb)
    );
    assign k_doutb_0 = k_doutb[15:0];
    assign k_doutb_1 = k_doutb[31:16];
    assign k_doutb_2 = k_doutb[47:32];
    assign k_doutb_3 = k_doutb[63:48];
    assign k_doutb_4 = k_doutb[79:64];
    assign k_doutb_5 = k_doutb[95:80];

    // *** Counter for main controller ******************************************
    always @(posedge clk)
    begin
        if (!rst_n || clr)
        begin
            cnt_main_reg <= 0;
        end
        else if (start)
        begin
            cnt_main_reg <= cnt_main_reg + 1;
        end
        else if (cnt_main_reg >= 1 && cnt_main_reg <= 49)
        begin
            cnt_main_reg <= cnt_main_reg + 1;
        end
        else if (cnt_main_reg >= 50)
        begin
            cnt_main_reg <= 0;
        end
    end

    // Weight BRAM control
    assign wb_enb = ((cnt_main_reg >= 3) && (cnt_main_reg <= 7)) ? 1 :
                    ((cnt_main_reg >= 25) && (cnt_main_reg <= 26)) ? 1 : 0;
    assign wb_addrb = (cnt_main_reg == 3) ? 0 :
                      (cnt_main_reg == 4) ? 1 :
                      (cnt_main_reg == 5) ? 2 :
                      (cnt_main_reg == 6) ? 3 :
                      (cnt_main_reg == 7) ? 4 :
                      (cnt_main_reg == 25) ? 5 :
                      (cnt_main_reg == 26) ? 6 : 0;

    // Systolic moving input multiplexer control 
    assign a0_sel = ((cnt_main_reg >= 4) && (cnt_main_reg <= 8)) ? 0 :
                    ((cnt_main_reg >= 26) && (cnt_main_reg <= 27)) ? 0 : 1;
    assign a1_sel = ((cnt_main_reg >= 4) && (cnt_main_reg <= 8)) ? 0 :
                    ((cnt_main_reg >= 26) && (cnt_main_reg <= 27)) ? 0 : 1;
    assign a2_sel = ((cnt_main_reg >= 4) && (cnt_main_reg <= 8)) ? 0 :
                    ((cnt_main_reg >= 26) && (cnt_main_reg <= 27)) ? 0 : 1;
    assign a3_sel = ((cnt_main_reg >= 4) && (cnt_main_reg <= 8)) ? 0 :
                    ((cnt_main_reg >= 26) && (cnt_main_reg <= 27)) ? 0 : 1;
    assign a4_sel = ((cnt_main_reg >= 4) && (cnt_main_reg <= 8)) ? 0 :
                    ((cnt_main_reg >= 26) && (cnt_main_reg <= 27)) ? 0 : 1;
    assign a5_sel = ((cnt_main_reg >= 4) && (cnt_main_reg <= 8)) ? 0 :
                    ((cnt_main_reg >= 26) && (cnt_main_reg <= 27)) ? 0 : 1;
                    
    // Input BRAM control
    assign k_enb = ((cnt_main_reg >= 1) && (cnt_main_reg <= 4)) ? 1 : 0;
    assign k_addrb = (cnt_main_reg == 1) ? 0 :
                     (cnt_main_reg == 2) ? 1 :
                     (cnt_main_reg == 3) ? 2 :
                     (cnt_main_reg == 4) ? 3 : 0;
                                                  
    // Systolic stationary input multiplexer control                 
    assign b00_sel = (cnt_main_reg == 2) ? 0 :
                     (cnt_main_reg == 22) ? 1 : 3;
    assign b01_sel = (cnt_main_reg == 2) ? 0 :
                     (cnt_main_reg == 22) ? 1 : 3;
    assign b02_sel = (cnt_main_reg == 2) ? 0 :
                     (cnt_main_reg == 22) ? 1 : 3;
    assign b03_sel = (cnt_main_reg == 2) ? 0 :
                     (cnt_main_reg == 22) ? 1 : 3;
    assign b04_sel = (cnt_main_reg == 2) ? 0 :
                     (cnt_main_reg == 22) ? 1 : 3;
    assign b05_sel = (cnt_main_reg == 2) ? 0 :
                     (cnt_main_reg == 22) ? 1 : 3;
    
    assign b10_sel = (cnt_main_reg == 3) ? 0 :
                     (cnt_main_reg == 23) ? 1 : 3;
    assign b11_sel = (cnt_main_reg == 3) ? 0 :
                     (cnt_main_reg == 23) ? 1 : 3;
    assign b12_sel = (cnt_main_reg == 3) ? 0 :
                     (cnt_main_reg == 23) ? 1 : 3;
    assign b13_sel = (cnt_main_reg == 3) ? 0 :
                     (cnt_main_reg == 23) ? 1 : 3;
    assign b14_sel = (cnt_main_reg == 3) ? 0 :
                     (cnt_main_reg == 23) ? 1 : 3;
    assign b15_sel = (cnt_main_reg == 3) ? 0 :
                     (cnt_main_reg == 23) ? 1 : 3;

    assign b20_sel = (cnt_main_reg == 4) ? 0 :
                     (cnt_main_reg == 24) ? 1 : 3;
    assign b21_sel = (cnt_main_reg == 4) ? 0 :
                     (cnt_main_reg == 24) ? 1 : 3;
    assign b22_sel = (cnt_main_reg == 4) ? 0 :
                     (cnt_main_reg == 24) ? 1 : 3;
    assign b23_sel = (cnt_main_reg == 4) ? 0 :
                     (cnt_main_reg == 24) ? 1 : 3;
    assign b24_sel = (cnt_main_reg == 4) ? 0 :
                     (cnt_main_reg == 24) ? 1 : 3;
    assign b25_sel = (cnt_main_reg == 4) ? 0 :
                     (cnt_main_reg == 24) ? 1 : 3;
    
    assign b30_sel = (cnt_main_reg == 5) ? 0 :
                     (cnt_main_reg == 25) ? 1 : 3;
    assign b31_sel = (cnt_main_reg == 5) ? 0 :
                     (cnt_main_reg == 25) ? 1 : 3;
    assign b32_sel = (cnt_main_reg == 5) ? 0 :
                     (cnt_main_reg == 25) ? 1 : 3;
    assign b33_sel = (cnt_main_reg == 5) ? 0 :
                     (cnt_main_reg == 25) ? 1 : 3;
    assign b34_sel = (cnt_main_reg == 5) ? 0 :
                     (cnt_main_reg == 25) ? 1 : 3;
    assign b35_sel = (cnt_main_reg == 5) ? 0 :
                     (cnt_main_reg == 25) ? 1 : 3;
    
    assign b40_sel = (cnt_main_reg == 2) ? 2 :
                     (cnt_main_reg == 26) ? 1 : 3;
    assign b41_sel = (cnt_main_reg == 2) ? 2 :
                     (cnt_main_reg == 26) ? 1 : 3;
    assign b42_sel = (cnt_main_reg == 2) ? 2 :
                     (cnt_main_reg == 26) ? 1 : 3;
    assign b43_sel = (cnt_main_reg == 2) ? 2 :
                     (cnt_main_reg == 26) ? 1 : 3;
    assign b44_sel = (cnt_main_reg == 2) ? 2 :
                     (cnt_main_reg == 26) ? 1 : 3;
    assign b45_sel = (cnt_main_reg == 2) ? 2 :
                     (cnt_main_reg == 26) ? 1 : 3;

    assign b50_sel = (cnt_main_reg == 22) ? 2 : 3;
    assign b51_sel = (cnt_main_reg == 22) ? 2 : 3;
    assign b52_sel = (cnt_main_reg == 22) ? 2 : 3;
    assign b53_sel = (cnt_main_reg == 22) ? 2 : 3;
    assign b54_sel = (cnt_main_reg == 22) ? 2 : 3;
    assign b55_sel = (cnt_main_reg == 22) ? 2 : 3;

    // Systolic control
    assign sys_in_valid = ((cnt_main_reg >= 4) && (cnt_main_reg <= 9)) ? 1 :
                          ((cnt_main_reg >= 26) && (cnt_main_reg <= 31)) ? 1 : 0;
    // Output BRAM control
    assign a_ena = ((cnt_main_reg >= 40) && (cnt_main_reg <= 41)) ? 1 : 0;
    assign a_wea = ((cnt_main_reg >= 40) && (cnt_main_reg <= 41)) ? 16'hffff : 0;
    assign a_addra = (cnt_main_reg == 40) ? 0 :
                     (cnt_main_reg == 41) ? 1 : 0; 

    // Status control
    assign ready = (cnt_main_reg == 0) ? 1 : 0;
    assign done = (cnt_main_reg == 50) ? 1 : 0;

    // *** Multiplexer for systolic moving input *******************
    assign a0 = (a0_sel == 0) ? wb_doutb_0 : 0;
    assign a1 = (a1_sel == 0) ? wb_doutb_1 : 0;
    assign a2 = (a2_sel == 0) ? wb_doutb_2 : 0;
    assign a3 = (a3_sel == 0) ? wb_doutb_3 : 0;
    assign a4 = (a4_sel == 0) ? wb_doutb_4 : 0;
    assign a5 = (a5_sel == 0) ? wb_doutb_5 : 0;

    // *** Multiplexer and register for systolic stationary input ***************
    assign b00_next = (b00_sel == 0) ? k_doutb_0 :
                      (b00_sel == 1) ? s0_reg3 :
                      (b00_sel == 2) ? 16'b0000010000000000 : b00_reg;
    assign b01_next = (b01_sel == 0) ? k_doutb_1 :
                      (b01_sel == 1) ? s1_reg3 :
                      (b01_sel == 2) ? 16'b0000010000000000 : b01_reg;
    assign b02_next = (b02_sel == 0) ? k_doutb_2 :
                      (b02_sel == 1) ? s2_reg3 :
                      (b02_sel == 2) ? 16'b0000010000000000 : b02_reg;
    assign b03_next = (b03_sel == 0) ? k_doutb_3 :
                      (b03_sel == 1) ? s3_reg3 :
                      (b03_sel == 2) ? 16'b0000010000000000 : b03_reg;
    assign b04_next = (b04_sel == 0) ? k_doutb_4 :
                      (b04_sel == 1) ? s4_reg3 :
                      (b04_sel == 2) ? 16'b0000010000000000 : b04_reg;
    assign b05_next = (b05_sel == 0) ? k_doutb_5 :
                      (b05_sel == 1) ? s5_reg3 :
                      (b05_sel == 2) ? 16'b0000010000000000 : b05_reg;

    register #(16) reg_b00(clk, rst_n, en, clr, b00_next, b00_reg); 
    register #(16) reg_b01(clk, rst_n, en, clr, b01_next, b01_reg); 
    register #(16) reg_b02(clk, rst_n, en, clr, b02_next, b02_reg); 
    register #(16) reg_b03(clk, rst_n, en, clr, b03_next, b03_reg);
    register #(16) reg_b04(clk, rst_n, en, clr, b04_next, b04_reg);
    register #(16) reg_b05(clk, rst_n, en, clr, b05_next, b05_reg);

    assign b10_next = (b10_sel == 0) ? k_doutb_0 :
                      (b10_sel == 1) ? s0_reg3 :
                      (b10_sel == 2) ? 16'b0000010000000000 : b10_reg;
    assign b11_next = (b11_sel == 0) ? k_doutb_1 :
                      (b11_sel == 1) ? s1_reg3 :
                      (b11_sel == 2) ? 16'b0000010000000000 : b11_reg;
    assign b12_next = (b12_sel == 0) ? k_doutb_2 :
                      (b12_sel == 1) ? s2_reg3 :
                      (b12_sel == 2) ? 16'b0000010000000000 : b12_reg;
    assign b13_next = (b13_sel == 0) ? k_doutb_3 :
                      (b13_sel == 1) ? s3_reg3 :
                      (b13_sel == 2) ? 16'b0000010000000000 : b13_reg;
    assign b14_next = (b14_sel == 0) ? k_doutb_4 :
                      (b14_sel == 1) ? s4_reg3 :
                      (b14_sel == 2) ? 16'b0000010000000000 : b14_reg;
    assign b15_next = (b15_sel == 0) ? k_doutb_5 :
                      (b15_sel == 1) ? s5_reg3 :
                      (b15_sel == 2) ? 16'b0000010000000000 : b15_reg;
                      
    register #(16) reg_b10(clk, rst_n, en, clr, b10_next, b10_reg); 
    register #(16) reg_b11(clk, rst_n, en, clr, b11_next, b11_reg); 
    register #(16) reg_b12(clk, rst_n, en, clr, b12_next, b12_reg); 
    register #(16) reg_b13(clk, rst_n, en, clr, b13_next, b13_reg); 
    register #(16) reg_b14(clk, rst_n, en, clr, b14_next, b14_reg); 
    register #(16) reg_b15(clk, rst_n, en, clr, b15_next, b15_reg); 

    assign b20_next = (b20_sel == 0) ? k_doutb_0 :
                      (b20_sel == 1) ? s0_reg3 :
                      (b20_sel == 2) ? 16'b0000010000000000 : b20_reg;
    assign b21_next = (b21_sel == 0) ? k_doutb_1 :
                      (b21_sel == 1) ? s1_reg3 :
                      (b21_sel == 2) ? 16'b0000010000000000 : b21_reg;
    assign b22_next = (b22_sel == 0) ? k_doutb_2 :
                      (b22_sel == 1) ? s2_reg3 :
                      (b22_sel == 2) ? 16'b0000010000000000 : b22_reg;
    assign b23_next = (b23_sel == 0) ? k_doutb_3 :
                      (b23_sel == 1) ? s3_reg3 :
                      (b23_sel == 2) ? 16'b0000010000000000 : b23_reg;
    assign b24_next = (b24_sel == 0) ? k_doutb_4 :
                      (b24_sel == 1) ? s4_reg3 :
                      (b24_sel == 2) ? 16'b0000010000000000 : b24_reg;
    assign b25_next = (b25_sel == 0) ? k_doutb_5 :
                      (b25_sel == 1) ? s5_reg3 :
                      (b25_sel == 2) ? 16'b0000010000000000 : b25_reg;
                      
    register #(16) reg_b20(clk, rst_n, en, clr, b20_next, b20_reg); 
    register #(16) reg_b21(clk, rst_n, en, clr, b21_next, b21_reg); 
    register #(16) reg_b22(clk, rst_n, en, clr, b22_next, b22_reg); 
    register #(16) reg_b23(clk, rst_n, en, clr, b23_next, b23_reg); 
    register #(16) reg_b24(clk, rst_n, en, clr, b24_next, b24_reg); 
    register #(16) reg_b25(clk, rst_n, en, clr, b25_next, b25_reg); 

    assign b30_next = (b30_sel == 0) ? k_doutb_0 :
                      (b30_sel == 1) ? s0_reg3 :
                      (b30_sel == 2) ? 16'b0000010000000000 : b30_reg;
    assign b31_next = (b31_sel == 0) ? k_doutb_1 :
                      (b31_sel == 1) ? s1_reg3 :
                      (b31_sel == 2) ? 16'b0000010000000000 : b31_reg;
    assign b32_next = (b32_sel == 0) ? k_doutb_2 :
                      (b32_sel == 1) ? s2_reg3 :
                      (b32_sel == 2) ? 16'b0000010000000000 : b32_reg;
    assign b33_next = (b33_sel == 0) ? k_doutb_3 :
                      (b33_sel == 1) ? s3_reg3 :
                      (b33_sel == 2) ? 16'b0000010000000000 : b33_reg;
    assign b34_next = (b34_sel == 0) ? k_doutb_4 :
                      (b34_sel == 1) ? s4_reg3 :
                      (b34_sel == 2) ? 16'b0000010000000000 : b34_reg;
    assign b35_next = (b35_sel == 0) ? k_doutb_5 :
                      (b35_sel == 1) ? s5_reg3 :
                      (b35_sel == 2) ? 16'b0000010000000000 : b35_reg;
                      
    register #(16) reg_b30(clk, rst_n, en, clr, b30_next, b30_reg); 
    register #(16) reg_b31(clk, rst_n, en, clr, b31_next, b31_reg); 
    register #(16) reg_b32(clk, rst_n, en, clr, b32_next, b32_reg); 
    register #(16) reg_b33(clk, rst_n, en, clr, b33_next, b33_reg); 
    register #(16) reg_b34(clk, rst_n, en, clr, b34_next, b34_reg); 
    register #(16) reg_b35(clk, rst_n, en, clr, b35_next, b35_reg); 

    assign b40_next = (b40_sel == 0) ? k_doutb_0 :
                      (b40_sel == 1) ? s0_reg3 :
                      (b40_sel == 2) ? 16'b0000010000000000 : b40_reg;
    assign b41_next = (b41_sel == 0) ? k_doutb_1 :
                      (b41_sel == 1) ? s1_reg3 :
                      (b41_sel == 2) ? 16'b0000010000000000 : b41_reg;
    assign b42_next = (b42_sel == 0) ? k_doutb_2 :
                      (b42_sel == 1) ? s2_reg3 :
                      (b42_sel == 2) ? 16'b0000010000000000 : b42_reg;
    assign b43_next = (b43_sel == 0) ? k_doutb_3 :
                      (b43_sel == 1) ? s3_reg3 :
                      (b43_sel == 2) ? 16'b0000010000000000 : b43_reg;
    assign b44_next = (b44_sel == 0) ? k_doutb_4 :
                      (b44_sel == 1) ? s4_reg3 :
                      (b44_sel == 2) ? 16'b0000010000000000 : b44_reg;
    assign b45_next = (b45_sel == 0) ? k_doutb_5 :
                      (b45_sel == 1) ? s5_reg3 :
                      (b45_sel == 2) ? 16'b0000010000000000 : b45_reg;
                      
    register #(16) reg_b40(clk, rst_n, en, clr, b40_next, b40_reg); 
    register #(16) reg_b41(clk, rst_n, en, clr, b41_next, b41_reg); 
    register #(16) reg_b42(clk, rst_n, en, clr, b42_next, b42_reg); 
    register #(16) reg_b43(clk, rst_n, en, clr, b43_next, b43_reg); 
    register #(16) reg_b44(clk, rst_n, en, clr, b44_next, b44_reg); 
    register #(16) reg_b45(clk, rst_n, en, clr, b45_next, b45_reg); 

    assign b50_next = (b50_sel == 0) ? k_doutb_0 :
                      (b50_sel == 1) ? s0_reg3 :
                      (b50_sel == 2) ? 16'b0000010000000000 : b50_reg;
    assign b51_next = (b51_sel == 0) ? k_doutb_1 :
                      (b51_sel == 1) ? s1_reg3 :
                      (b51_sel == 2) ? 16'b0000010000000000 : b51_reg;
    assign b52_next = (b52_sel == 0) ? k_doutb_2 :
                      (b52_sel == 1) ? s2_reg3 :
                      (b52_sel == 2) ? 16'b0000010000000000 : b52_reg;
    assign b53_next = (b53_sel == 0) ? k_doutb_3 :
                      (b53_sel == 1) ? s3_reg3 :
                      (b53_sel == 2) ? 16'b0000010000000000 : b53_reg;
    assign b54_next = (b54_sel == 0) ? k_doutb_4 :
                      (b54_sel == 1) ? s4_reg3 :
                      (b54_sel == 2) ? 16'b0000010000000000 : b54_reg;
    assign b55_next = (b55_sel == 0) ? k_doutb_5 :
                      (b55_sel == 1) ? s5_reg3 :
                      (b55_sel == 2) ? 16'b0000010000000000 : b55_reg;
                      
    register #(16) reg_b50(clk, rst_n, en, clr, b50_next, b50_reg); 
    register #(16) reg_b51(clk, rst_n, en, clr, b51_next, b51_reg); 
    register #(16) reg_b52(clk, rst_n, en, clr, b52_next, b52_reg); 
    register #(16) reg_b53(clk, rst_n, en, clr, b53_next, b53_reg); 
    register #(16) reg_b54(clk, rst_n, en, clr, b54_next, b54_reg); 
    register #(16) reg_b55(clk, rst_n, en, clr, b55_next, b55_reg); 

    // *** Systolic *************************************************************
    systolic
    #(
        .WIDTH(16),
        .FRAC_BIT(10)
    )
    systolic_0
    (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .clr(clr),
        .a0(a0), .a1(a1), .a2(a2), .a3(a3), .a4(a4), .a5(a5),
        .in_valid(sys_in_valid),
        .b00(b00_reg), .b01(b01_reg), .b02(b02_reg), .b03(b03_reg), .b04(b04_reg), .b05(b05_reg),
        .b10(b10_reg), .b11(b11_reg), .b12(b12_reg), .b13(b13_reg), .b14(b14_reg), .b15(b15_reg),
        .b20(b20_reg), .b21(b21_reg), .b22(b22_reg), .b23(b23_reg), .b24(b24_reg), .b25(b25_reg),
        .b30(b30_reg), .b31(b31_reg), .b32(b32_reg), .b33(b33_reg), .b34(b34_reg), .b35(b35_reg),
        .b40(b40_reg), .b41(b41_reg), .b42(b42_reg), .b43(b43_reg), .b44(b44_reg), .b45(b45_reg),
        .b50(b50_reg), .b51(b51_reg), .b52(b52_reg), .b53(b53_reg), .b54(b54_reg), .b55(b55_reg),
        .y0(y0), .y1(y1), .y2(y2), .y3(y3), .y4(y4), .y5(y5),
        .out_valid(sys_out_valid)
    );

    // *** Sigmoid **************************************************************
    sigmoid sigmoid_0(clk, rst_n, en, clr, y0, s0);
    sigmoid sigmoid_1(clk, rst_n, en, clr, y1, s1);
    sigmoid sigmoid_2(clk, rst_n, en, clr, y2, s2);
    sigmoid sigmoid_3(clk, rst_n, en, clr, y3, s3);
    sigmoid sigmoid_4(clk, rst_n, en, clr, y4, s4);
    sigmoid sigmoid_5(clk, rst_n, en, clr, y5, s5);
    
    register #(16) reg_sig_00(clk, rst_n, en, clr, s0,      s0_reg0);
    register #(16) reg_sig_01(clk, rst_n, en, clr, s0_reg0, s0_reg1);
    register #(16) reg_sig_02(clk, rst_n, en, clr, s0_reg1, s0_reg2);
    register #(16) reg_sig_03(clk, rst_n, en, clr, s0_reg2, s0_reg3);
    register #(16) reg_sig_10(clk, rst_n, en, clr, s1,      s1_reg0);
    register #(16) reg_sig_11(clk, rst_n, en, clr, s1_reg0, s1_reg1);
    register #(16) reg_sig_12(clk, rst_n, en, clr, s1_reg1, s1_reg2);
    register #(16) reg_sig_13(clk, rst_n, en, clr, s1_reg2, s1_reg3);
    register #(16) reg_sig_20(clk, rst_n, en, clr, s2,      s2_reg0);
    register #(16) reg_sig_21(clk, rst_n, en, clr, s2_reg0, s2_reg1);
    register #(16) reg_sig_22(clk, rst_n, en, clr, s2_reg1, s2_reg2);
    register #(16) reg_sig_23(clk, rst_n, en, clr, s2_reg2, s2_reg3);
    register #(16) reg_sig_30(clk, rst_n, en, clr, s3,      s3_reg0);
    register #(16) reg_sig_31(clk, rst_n, en, clr, s3_reg0, s3_reg1);
    register #(16) reg_sig_32(clk, rst_n, en, clr, s3_reg1, s3_reg2);
    register #(16) reg_sig_33(clk, rst_n, en, clr, s3_reg2, s3_reg3);
    register #(16) reg_sig_40(clk, rst_n, en, clr, s4,      s4_reg0);
    register #(16) reg_sig_41(clk, rst_n, en, clr, s4_reg0, s4_reg1);
    register #(16) reg_sig_42(clk, rst_n, en, clr, s4_reg1, s4_reg2);
    register #(16) reg_sig_43(clk, rst_n, en, clr, s4_reg2, s4_reg3);
    register #(16) reg_sig_50(clk, rst_n, en, clr, s5,      s5_reg0);
    register #(16) reg_sig_51(clk, rst_n, en, clr, s5_reg0, s5_reg1);
    register #(16) reg_sig_52(clk, rst_n, en, clr, s5_reg1, s5_reg2);
    register #(16) reg_sig_53(clk, rst_n, en, clr, s5_reg2, s5_reg3);
     
    register #(1) reg_sig_valid_0(clk, rst_n, en, clr, sys_out_valid,      sig_out_valid); 
    register #(1) reg_sig_valid_1(clk, rst_n, en, clr, sig_out_valid,      sig_out_valid_reg0); 
    register #(1) reg_sig_valid_2(clk, rst_n, en, clr, sig_out_valid_reg0, sig_out_valid_reg1); 
    register #(1) reg_sig_valid_3(clk, rst_n, en, clr, sig_out_valid_reg1, sig_out_valid_reg2); 
    register #(1) reg_sig_valid_4(clk, rst_n, en, clr, sig_out_valid_reg2, sig_out_valid_reg3); 

    // *** Output BRAM **********************************************************
    assign a_dina = {32'd0, s5, s4, s3, s2, s1, s0};
    // xpm_memory_tdpram: True Dual Port RAM
    // Xilinx Parameterized Macro, version 2018.3
    xpm_memory_tdpram
    #(
        // Common module parameters
        .MEMORY_SIZE(512),                   // DECIMAL, size: 4x128bit= 512 bits
        .MEMORY_PRIMITIVE("auto"),           // String
        .CLOCKING_MODE("common_clock"),      // String, "common_clock"
        .MEMORY_INIT_FILE("none"),           // String
        .MEMORY_INIT_PARAM("0"),             // String      
        .USE_MEM_INIT(1),                    // DECIMAL
        .WAKEUP_TIME("disable_sleep"),       // String
        .MESSAGE_CONTROL(0),                 // DECIMAL
        .AUTO_SLEEP_TIME(0),                 // DECIMAL          
        .ECC_MODE("no_ecc"),                 // String
        .MEMORY_OPTIMIZATION("true"),        // String              
        .USE_EMBEDDED_CONSTRAINT(0),         // DECIMAL
        
        // Port A module parameters
        .WRITE_DATA_WIDTH_A(128),            // DECIMAL, data width: 128-bit
        .READ_DATA_WIDTH_A(128),             // DECIMAL, data width: 128-bit
        .BYTE_WRITE_WIDTH_A(8),              // DECIMAL
        .ADDR_WIDTH_A(2),                    // DECIMAL, clog2(512/128)=clog2(4)= 2
        .READ_RESET_VALUE_A("0"),            // String
        .READ_LATENCY_A(1),                  // DECIMAL
        .WRITE_MODE_A("write_first"),        // String
        .RST_MODE_A("SYNC"),                 // String
        
        // Port B module parameters  
        .WRITE_DATA_WIDTH_B(128),            // DECIMAL, data width: 128-bit
        .READ_DATA_WIDTH_B(128),             // DECIMAL, data width: 128-bit
        .BYTE_WRITE_WIDTH_B(8),              // DECIMAL
        .ADDR_WIDTH_B(2),                    // DECIMAL, clog2(512/128)=clog2(4)= 2
        .READ_RESET_VALUE_B("0"),            // String
        .READ_LATENCY_B(1),                  // DECIMAL
        .WRITE_MODE_B("write_first"),        // String
        .RST_MODE_B("SYNC")                  // String
    )
    xpm_memory_tdpram_a
    (
        .sleep(1'b0),
        .regcea(1'b1), //do not change
        .injectsbiterra(1'b0), //do not change
        .injectdbiterra(1'b0), //do not change   
        .sbiterra(), //do not change
        .dbiterra(), //do not change
        .regceb(1'b1), //do not change
        .injectsbiterrb(1'b0), //do not change
        .injectdbiterrb(1'b0), //do not change              
        .sbiterrb(), //do not change
        .dbiterrb(), //do not change
        
        // Port A module ports
        .clka(clk),
        .rsta(~rst_n),
        .ena(a_ena),
        .wea(a_wea),
        .addra(a_addra),
        .dina(a_dina),
        .douta(),
        
        // Port B module ports
        .clkb(clk),
        .rstb(~rst_n),
        .enb(a_enb),
        .web(0),
        .addrb(a_addrb),
        .dinb(0),
        .doutb(a_doutb)
    );

endmodule
// ©2024 ????
   