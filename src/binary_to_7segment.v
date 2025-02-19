module binary_to_7segment
(
    input wire i_clk,
    input wire [3:0] i_binary_num,
    output wire [6:0] o_seg
);

  reg [6:0] r_hex_encoding = 7'h00;

  always @(posedge i_clk)
    begin
      case (i_binary_num)
        4'b0000 : r_hex_encoding <= 7'h7E;
        4'b0001 : r_hex_encoding <= 7'h30;
        4'b0010 : r_hex_encoding <= 7'h6D;
        4'b0011 : r_hex_encoding <= 7'h79;
        4'b0100 : r_hex_encoding <= 7'h33;
        4'b0101 : r_hex_encoding <= 7'h5B;
        4'b0110 : r_hex_encoding <= 7'h5F;
        4'b0111 : r_hex_encoding <= 7'h70;
        4'b1000 : r_hex_encoding <= 7'h7F;
        4'b1001 : r_hex_encoding <= 7'h7B;
        4'b1010 : r_hex_encoding <= 7'h77;
        4'b1011 : r_hex_encoding <= 7'h1F;
        4'b1100 : r_hex_encoding <= 7'h4E;
        4'b1101 : r_hex_encoding <= 7'h3D;
        4'b1110 : r_hex_encoding <= 7'h4F;
        4'b1111 : r_hex_encoding <= 7'h47;
      endcase
    end

  assign o_seg = r_hex_encoding;

endmodule
