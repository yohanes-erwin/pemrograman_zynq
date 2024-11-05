module pe
    #( 
        parameter WIDTH = 16,
        parameter FRAC_BIT = 10
    )
    (
        input wire signed [WIDTH-1:0]  a_in,
        input wire signed [WIDTH-1:0]  y_in,
        input wire signed [WIDTH-1:0]  b,
        output wire signed [WIDTH-1:0] a_out,
        output wire signed [WIDTH-1:0] y_out
    );
    
    wire signed [WIDTH*2-1:0] y_out_i;
    
    assign a_out = a_in;
    assign y_out_i = a_in * b;
    assign y_out = y_in + y_out_i[WIDTH+FRAC_BIT-1:FRAC_BIT];

endmodule
