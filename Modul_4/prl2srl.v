module prl2srl(clock,rst,en,prl,srl,valid);

   input         clock;
   input         rst;
   input         en;
   input   [7:0] prl;
   
   output  srl;
   output  valid;
   
   parameter IDLE    = 2'b00;
   parameter SERIAL  = 2'b01;
   parameter PARALEL = 2'b10;
   
   reg  [1:0] state;
   reg  [2:0] count;
   reg  [7:0] buff;
   wire [1:0] nextState;
   
   //state machine
   always@(posedge clock)
   begin
        if(!rst)
            state <= IDLE;
        else
            state <= nextState;
   end
   
   assign nextState = (state == IDLE) & en                      ? SERIAL:
                      (state == SERIAL) & en                    ? PARALEL:
                      (state == PARALEL) & en & (count == 3'd7) ? SERIAL: 
                                                                  state;
   
   //counter                                                                                                                              
   always@(posedge clock)
   begin
        if(!rst)
            count <= 3'd0;
        else if(state == PARALEL)
            count <= count + 3'd1;
        else
            count <= count;
   end  
   always@(posedge clock)
   begin
        if(!rst)
            buff <= 8'd0;
        else if(state == SERIAL)
            buff <= prl;
        else if(state == PARALEL)
            buff <= {buff[6:0],1'b0};
        else
            buff <= buff;
   end
   assign srl   = buff[7];
   assign valid = (state == PARALEL); 
endmodule
