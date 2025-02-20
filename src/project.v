/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_enjens (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  reg [3:0] number = 0;
  wire [6:0] o_number;
  wire reset;
  wire  direction;

  // All output pins must be assigned. If not used, assign to 0
  assign uio_oe  = 0;
  assign uio_out = 0;
  assign reset = !rst_n;
  assign direction = ui_in[0];
  wire tick_clk;

  binary_to_7segment btoseven(
     .i_clk(clk),
     .i_binary_num(number),
     .o_seg(o_number)
   );

   tick ticker(
      .clk(clk),
      .o_clk(tick_clk)
   );

   always @(posedge tick_clk, posedge reset)
   begin
    if (reset || (direction && number >= 9)) begin
      number <= 0;
    end else if (!direction && number <= 0)
    begin
      number <= 9;
    end else if (direction)
    begin
      number <= number + 1;
    end else
    begin
      number <= number - 1;
    end

   end

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, rst_n, ui_in[7:1], uio_in, 1'b0};

  assign uo_out = {1'b0, o_number};

endmodule
