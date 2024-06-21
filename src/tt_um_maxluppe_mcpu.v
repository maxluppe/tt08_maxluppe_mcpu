/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

//`default_nettype none

module tt_um_maxluppe_mcpu (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  //assign uio_out = 0;

  // List all unused inputs to prevent warnings
    wire _unused = &{ena, ui_in, 1'b0};

    wire oe, we;
    
    mcpu u0 (
        .datain(uio_in),
        .dataout(uio_out),
        .adress(uo_out[5:0]),
        .oe(oe),
        .we(we),
        .rst(rst_n),
        .clk(clk)
    );

    assign uo_out[6] = oe;
    assign uo_out[7] = we;
    assign uio_oe = {8{we}};

endmodule
