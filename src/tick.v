module tick(
    input wire clk,
    output reg o_clk
);

reg[23:0] counter=24'd0;
parameter DIVISOR = 24'd10000000;

`ifndef __ICARUS__
always @(posedge clk)
begin
counter <= counter + 24'd1;
if(counter>=(DIVISOR-1))
    counter <= 24'd0;
o_clk <= (counter<DIVISOR/2)?1'b1:1'b0;
end
`else
assign o_clk = clk;
`endif

endmodule