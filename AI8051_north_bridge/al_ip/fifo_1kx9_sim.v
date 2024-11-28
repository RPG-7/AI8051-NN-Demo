// Verilog netlist created by TD v4.6.121343
// Wed Nov 27 10:56:44 2024

`timescale 1ns / 1ps
module fifo_1kx9  // al_ip/fifo_1kx9.v(14)
  (
  clkr,
  clkw,
  di,
  re,
  rst,
  we,
  aempty_flag,
  afull_flag,
  do,
  empty_flag,
  full_flag
  );

  input clkr;  // al_ip/fifo_1kx9.v(25)
  input clkw;  // al_ip/fifo_1kx9.v(24)
  input [8:0] di;  // al_ip/fifo_1kx9.v(23)
  input re;  // al_ip/fifo_1kx9.v(25)
  input rst;  // al_ip/fifo_1kx9.v(22)
  input we;  // al_ip/fifo_1kx9.v(24)
  output aempty_flag;  // al_ip/fifo_1kx9.v(28)
  output afull_flag;  // al_ip/fifo_1kx9.v(29)
  output [17:0] do;  // al_ip/fifo_1kx9.v(27)
  output empty_flag;  // al_ip/fifo_1kx9.v(28)
  output full_flag;  // al_ip/fifo_1kx9.v(29)

  wire empty_flag_neg;
  wire full_flag_neg;

  EF2_PHY_CONFIG #(
    .DONE_PERSISTN("ENABLE"),
    .INIT_PERSISTN("ENABLE"),
    .JTAG_PERSISTN("DISABLE"),
    .PROGRAMN_PERSISTN("DISABLE"))
    config_inst ();
  not empty_flag_inv (empty_flag_neg, empty_flag);
  not full_flag_inv (full_flag_neg, full_flag);
  EF2_PHY_FIFO #(
    .AE(32'b00000000000000000000000001101000),
    .AEP1(32'b00000000000000000000000001111000),
    .AF(32'b00000000000000000001000000100000),
    .AFM1(32'b00000000000000000001000000011000),
    .ASYNC_RESET_RELEASE("SYNC"),
    .DATA_WIDTH_A("9"),
    .DATA_WIDTH_B("18"),
    .E(32'b00000000000000000000000000001000),
    .EP1(32'b00000000000000000000000000011000),
    .F(32'b00000000000000000010000000000000),
    .FM1(32'b00000000000000000001111111111000),
    .GSR("DISABLE"),
    .MODE("FIFO8K"),
    .REGMODE_A("NOREG"),
    .REGMODE_B("NOREG"),
    .RESETMODE("ASYNC"))
    logic_fifo_0 (
    .clkr(clkr),
    .clkw(clkw),
    .csr({2'b11,empty_flag_neg}),
    .csw({2'b11,full_flag_neg}),
    .dia(di),
    .orea(1'b0),
    .oreb(1'b0),
    .re(re),
    .rprst(rst),
    .rst(rst),
    .we(we),
    .aempty_flag(aempty_flag),
    .afull_flag(afull_flag),
    .doa(do[17:9]),
    .dob(do[8:0]),
    .empty_flag(empty_flag),
    .full_flag(full_flag));

endmodule 

