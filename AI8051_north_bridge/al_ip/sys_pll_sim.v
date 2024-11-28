// Verilog netlist created by TD v4.6.121343
// Mon Nov 25 12:49:47 2024

`timescale 1ns / 1ps
module sys_pll  // al_ip/sys_pll.v(24)
  (
  daddr,
  dclk,
  dcs,
  di,
  dwe,
  refclk,
  reset,
  clk0_out,
  clk1_out,
  clk2_out,
  do,
  extlock
  );

  input [5:0] daddr;  // al_ip/sys_pll.v(43)
  input dclk;  // al_ip/sys_pll.v(39)
  input dcs;  // al_ip/sys_pll.v(40)
  input [7:0] di;  // al_ip/sys_pll.v(42)
  input dwe;  // al_ip/sys_pll.v(41)
  input refclk;  // al_ip/sys_pll.v(37)
  input reset;  // al_ip/sys_pll.v(38)
  output clk0_out;  // al_ip/sys_pll.v(46)
  output clk1_out;  // al_ip/sys_pll.v(47)
  output clk2_out;  // al_ip/sys_pll.v(48)
  output [7:0] do;  // al_ip/sys_pll.v(45)
  output extlock;  // al_ip/sys_pll.v(44)

  wire clk0_buf;  // al_ip/sys_pll.v(50)

  EF2_PHY_GCLK bufg_feedback (
    .clki(clk0_buf),
    .clko(clk0_out));  // al_ip/sys_pll.v(52)
  EF2_PHY_CONFIG #(
    .DONE_PERSISTN("ENABLE"),
    .INIT_PERSISTN("ENABLE"),
    .JTAG_PERSISTN("DISABLE"),
    .PROGRAMN_PERSISTN("DISABLE"))
    config_inst ();
  EF2_PHY_PLL #(
    .CLKC0_CPHASE(4),
    .CLKC0_DIV(5),
    .CLKC0_DIV2_ENABLE("DISABLE"),
    .CLKC0_DUTY(0.500000),
    .CLKC0_DUTY50("ENABLE"),
    .CLKC0_DUTY_INT(3),
    .CLKC0_ENABLE("ENABLE"),
    .CLKC0_FPHASE(0),
    .CLKC1_CPHASE(1),
    .CLKC1_DIV(5),
    .CLKC1_DIV2_ENABLE("DISABLE"),
    .CLKC1_DUTY(0.500000),
    .CLKC1_DUTY50("ENABLE"),
    .CLKC1_DUTY_INT(3),
    .CLKC1_ENABLE("ENABLE"),
    .CLKC1_FPHASE(4),
    .CLKC2_CPHASE(39),
    .CLKC2_DIV(40),
    .CLKC2_DIV2_ENABLE("DISABLE"),
    .CLKC2_ENABLE("ENABLE"),
    .CLKC2_FPHASE(0),
    .CLKC3_CPHASE(1),
    .CLKC3_DIV(1),
    .CLKC3_DIV2_ENABLE("DISABLE"),
    .CLKC3_ENABLE("DISABLE"),
    .CLKC3_FPHASE(0),
    .CLKC4_CPHASE(1),
    .CLKC4_DIV(1),
    .CLKC4_DIV2_ENABLE("DISABLE"),
    .CLKC4_ENABLE("DISABLE"),
    .CLKC4_FPHASE(0),
    .CLKC5_CPHASE(1),
    .CLKC5_DIV(1),
    .CLKC5_DIV2_ENABLE("DISABLE"),
    .CLKC5_ENABLE("DISABLE"),
    .CLKC6_CPHASE(1),
    .CLKC6_DIV(1),
    .CLKC6_DIV2_ENABLE("DISABLE"),
    .CLKC6_ENABLE("DISABLE"),
    .DERIVE_PLL_CLOCKS("ENABLE"),
    .DPHASE_SOURCE("DISABLE"),
    .DYNCFG("ENABLE"),
    .FBCLK_DIV(8),
    .FEEDBK_MODE("NORMAL"),
    .FEEDBK_PATH("CLKC0_EXT"),
    .FIN("25.000000"),
    .FREQ_LOCK_ACCURACY(2),
    .FREQ_OFFSET(0.000000),
    .FREQ_OFFSET_INT(0),
    .GEN_BASIC_CLOCK("ENABLE"),
    .GMC_GAIN(2),
    .GMC_TEST(14),
    .HIGH_SPEED_EN("DISABLE"),
    .ICP_CURRENT(9),
    .IF_ESCLKSTSW("DISABLE"),
    .INTFB_WAKE("DISABLE"),
    .INTPI(0),
    .KVCO(2),
    .LPF_CAPACITOR(1),
    .LPF_RESISTOR(8),
    .NORESET("DISABLE"),
    .ODIV_MUXC0("DIV"),
    .ODIV_MUXC1("DIV"),
    .ODIV_MUXC2("DIV"),
    .ODIV_MUXC3("DIV"),
    .ODIV_MUXC4("DIV"),
    .OFFSET_MODE("EXT"),
    .PLLC2RST_ENA("DISABLE"),
    .PLLC34RST_ENA("DISABLE"),
    .PLLMRST_ENA("DISABLE"),
    .PLLRST_ENA("ENABLE"),
    .PLL_LOCK_MODE(0),
    .PREDIV_MUXC0("VCO"),
    .PREDIV_MUXC1("VCO"),
    .PREDIV_MUXC2("VCO"),
    .PREDIV_MUXC3("VCO"),
    .PREDIV_MUXC4("VCO"),
    .PREDIV_MUXC5("VCO"),
    .PREDIV_MUXC6("VCO"),
    .PU_INTP("DISABLE"),
    .REFCLK_DIV(1),
    .REFCLK_SEL("INTERNAL"),
    .SSC_AMP(0.000000),
    .SSC_ENABLE("DISABLE"),
    .SSC_FREQ_DIV(0),
    .SSC_MODE("Down"),
    .SSC_RNGE(0),
    .STDBY_ENABLE("DISABLE"),
    .STDBY_VCO_ENA("DISABLE"),
    .SYNC_ENABLE("DISABLE"),
    .VCO_NORESET("DISABLE"))
    pll_inst (
    .daddr(daddr),
    .dclk(dclk),
    .dcs(dcs),
    .di(di),
    .dsm_refclk(1'b0),
    .dsm_rst(reset),
    .dwe(dwe),
    .fbclk(clk0_out),
    .frac_offset_valid(1'b0),
    .load_reg(1'b0),
    .psclk(1'b0),
    .psclksel(3'b000),
    .psdown(1'b0),
    .psstep(1'b0),
    .refclk(refclk),
    .reset(reset),
    .ssc_en(1'b0),
    .stdby(1'b0),
    .clkc({open_n47,open_n48,open_n49,open_n50,clk2_out,clk1_out,clk0_buf}),
    .do(do),
    .extlock(extlock));  // al_ip/sys_pll.v(100)

endmodule 

