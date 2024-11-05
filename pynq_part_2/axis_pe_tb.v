`timescale 1ns / 1ps

module axis_pe_tb();
    localparam T = 10;
    
    reg aclk;
    reg aresetn;
    reg en;
    
    wire s_axis_tready;
    reg [31:0] s_axis_tdata;
    reg s_axis_tvalid;
    reg s_axis_tlast;
    
    reg m_axis_tready;
    wire [31:0] m_axis_tdata;
    wire m_axis_tvalid;
    wire m_axis_tlast;
    
    axis_pe dut
    (
        .aclk(aclk),
        .aresetn(aresetn),
        .en(en),
        .s_axis_tready(s_axis_tready),
        .s_axis_tdata(s_axis_tdata),
        .s_axis_tvalid(s_axis_tvalid),
        .s_axis_tlast(s_axis_tlast),
        .m_axis_tready(m_axis_tready),
        .m_axis_tdata(m_axis_tdata),
        .m_axis_tvalid(m_axis_tvalid),
        .m_axis_tlast(m_axis_tlast)
    );
    
    always
    begin
        aclk = 0;
        #(T/2);
        aclk = 1;
        #(T/2);
    end
    
    initial
    begin
        en = 1;
        s_axis_tdata = 0;
        s_axis_tvalid = 0;
        s_axis_tlast = 0;
        m_axis_tready = 1;
        
        aresetn = 0;
        #(T*10);
        aresetn = 1;
        #(T*10);
        
        s_axis_tvalid = 1;
        s_axis_tdata = 32'h00010801;
        #T;
        s_axis_tdata = 32'h00020702;
        #T;
        s_axis_tlast = 1;
        s_axis_tdata = 32'h00030603;
        #T;
        s_axis_tdata = 0;
        s_axis_tvalid = 0;
        s_axis_tlast = 0;
    end

endmodule
