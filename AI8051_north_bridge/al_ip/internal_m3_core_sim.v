// Verilog netlist created by TD v4.6.121343
// Mon Nov 25 12:47:47 2024

`timescale 1ns / 1ps
module internal_m3_core  // al_ip/internal_m3_core.v(14)
  (
  ahbslave_dma_req,
  ahbslave_dma_single,
  gpio_h0_in,
  gpio_h10_in,
  gpio_h11_in,
  gpio_h12_in,
  gpio_h13_in,
  gpio_h14_in,
  gpio_h15_in,
  gpio_h1_in,
  gpio_h2_in,
  gpio_h3_in,
  gpio_h4_in,
  gpio_h5_in,
  gpio_h6_in,
  gpio_h7_in,
  gpio_h8_in,
  gpio_h9_in,
  h2h_hrdata,
  h2h_hreadyout,
  h2h_hresp,
  h2h_mclk,
  h2h_rstn,
  i2s_mst_clk,
  ppm_clk,
  ppm_rstn,
  qspi_rxd,
  ahbslave_dma_ack,
  gpio_h0_oe_n,
  gpio_h0_out,
  gpio_h10_oe_n,
  gpio_h10_out,
  gpio_h11_oe_n,
  gpio_h11_out,
  gpio_h12_oe_n,
  gpio_h12_out,
  gpio_h13_oe_n,
  gpio_h13_out,
  gpio_h14_oe_n,
  gpio_h14_out,
  gpio_h15_oe_n,
  gpio_h15_out,
  gpio_h1_oe_n,
  gpio_h1_out,
  gpio_h2_oe_n,
  gpio_h2_out,
  gpio_h3_oe_n,
  gpio_h3_out,
  gpio_h4_oe_n,
  gpio_h4_out,
  gpio_h5_oe_n,
  gpio_h5_out,
  gpio_h6_oe_n,
  gpio_h6_out,
  gpio_h7_oe_n,
  gpio_h7_out,
  gpio_h8_oe_n,
  gpio_h8_out,
  gpio_h9_oe_n,
  gpio_h9_out,
  h2h_haddr,
  h2h_hburst,
  h2h_hprot,
  h2h_hsize,
  h2h_htrans,
  h2h_hwdata,
  h2h_hwrite,
  qspi_oen,
  qspi_sclk,
  qspi_ss,
  qspi_txd,
  sleep_out,
  usr_reg
  );

  input ahbslave_dma_req;  // al_ip/internal_m3_core.v(100)
  input ahbslave_dma_single;  // al_ip/internal_m3_core.v(101)
  input gpio_h0_in;  // al_ip/internal_m3_core.v(113)
  input gpio_h10_in;  // al_ip/internal_m3_core.v(143)
  input gpio_h11_in;  // al_ip/internal_m3_core.v(146)
  input gpio_h12_in;  // al_ip/internal_m3_core.v(149)
  input gpio_h13_in;  // al_ip/internal_m3_core.v(152)
  input gpio_h14_in;  // al_ip/internal_m3_core.v(155)
  input gpio_h15_in;  // al_ip/internal_m3_core.v(158)
  input gpio_h1_in;  // al_ip/internal_m3_core.v(116)
  input gpio_h2_in;  // al_ip/internal_m3_core.v(119)
  input gpio_h3_in;  // al_ip/internal_m3_core.v(122)
  input gpio_h4_in;  // al_ip/internal_m3_core.v(125)
  input gpio_h5_in;  // al_ip/internal_m3_core.v(128)
  input gpio_h6_in;  // al_ip/internal_m3_core.v(131)
  input gpio_h7_in;  // al_ip/internal_m3_core.v(134)
  input gpio_h8_in;  // al_ip/internal_m3_core.v(137)
  input gpio_h9_in;  // al_ip/internal_m3_core.v(140)
  input [31:0] h2h_hrdata;  // al_ip/internal_m3_core.v(95)
  input h2h_hreadyout;  // al_ip/internal_m3_core.v(96)
  input [1:0] h2h_hresp;  // al_ip/internal_m3_core.v(97)
  input h2h_mclk;  // al_ip/internal_m3_core.v(98)
  input h2h_rstn;  // al_ip/internal_m3_core.v(99)
  input i2s_mst_clk;  // al_ip/internal_m3_core.v(109)
  input ppm_clk;  // al_ip/internal_m3_core.v(108)
  input ppm_rstn;  // al_ip/internal_m3_core.v(110)
  input [3:0] qspi_rxd;  // al_ip/internal_m3_core.v(103)
  output ahbslave_dma_ack;  // al_ip/internal_m3_core.v(102)
  output gpio_h0_oe_n;  // al_ip/internal_m3_core.v(112)
  output gpio_h0_out;  // al_ip/internal_m3_core.v(111)
  output gpio_h10_oe_n;  // al_ip/internal_m3_core.v(142)
  output gpio_h10_out;  // al_ip/internal_m3_core.v(141)
  output gpio_h11_oe_n;  // al_ip/internal_m3_core.v(145)
  output gpio_h11_out;  // al_ip/internal_m3_core.v(144)
  output gpio_h12_oe_n;  // al_ip/internal_m3_core.v(148)
  output gpio_h12_out;  // al_ip/internal_m3_core.v(147)
  output gpio_h13_oe_n;  // al_ip/internal_m3_core.v(151)
  output gpio_h13_out;  // al_ip/internal_m3_core.v(150)
  output gpio_h14_oe_n;  // al_ip/internal_m3_core.v(154)
  output gpio_h14_out;  // al_ip/internal_m3_core.v(153)
  output gpio_h15_oe_n;  // al_ip/internal_m3_core.v(157)
  output gpio_h15_out;  // al_ip/internal_m3_core.v(156)
  output gpio_h1_oe_n;  // al_ip/internal_m3_core.v(115)
  output gpio_h1_out;  // al_ip/internal_m3_core.v(114)
  output gpio_h2_oe_n;  // al_ip/internal_m3_core.v(118)
  output gpio_h2_out;  // al_ip/internal_m3_core.v(117)
  output gpio_h3_oe_n;  // al_ip/internal_m3_core.v(121)
  output gpio_h3_out;  // al_ip/internal_m3_core.v(120)
  output gpio_h4_oe_n;  // al_ip/internal_m3_core.v(124)
  output gpio_h4_out;  // al_ip/internal_m3_core.v(123)
  output gpio_h5_oe_n;  // al_ip/internal_m3_core.v(127)
  output gpio_h5_out;  // al_ip/internal_m3_core.v(126)
  output gpio_h6_oe_n;  // al_ip/internal_m3_core.v(130)
  output gpio_h6_out;  // al_ip/internal_m3_core.v(129)
  output gpio_h7_oe_n;  // al_ip/internal_m3_core.v(133)
  output gpio_h7_out;  // al_ip/internal_m3_core.v(132)
  output gpio_h8_oe_n;  // al_ip/internal_m3_core.v(136)
  output gpio_h8_out;  // al_ip/internal_m3_core.v(135)
  output gpio_h9_oe_n;  // al_ip/internal_m3_core.v(139)
  output gpio_h9_out;  // al_ip/internal_m3_core.v(138)
  output [31:0] h2h_haddr;  // al_ip/internal_m3_core.v(88)
  output [2:0] h2h_hburst;  // al_ip/internal_m3_core.v(92)
  output [3:0] h2h_hprot;  // al_ip/internal_m3_core.v(93)
  output [2:0] h2h_hsize;  // al_ip/internal_m3_core.v(91)
  output [1:0] h2h_htrans;  // al_ip/internal_m3_core.v(89)
  output [31:0] h2h_hwdata;  // al_ip/internal_m3_core.v(94)
  output h2h_hwrite;  // al_ip/internal_m3_core.v(90)
  output [3:0] qspi_oen;  // al_ip/internal_m3_core.v(107)
  output qspi_sclk;  // al_ip/internal_m3_core.v(105)
  output qspi_ss;  // al_ip/internal_m3_core.v(106)
  output [3:0] qspi_txd;  // al_ip/internal_m3_core.v(104)
  output sleep_out;  // al_ip/internal_m3_core.v(159)
  output [15:0] usr_reg;  // al_ip/internal_m3_core.v(160)


  EF2_PHY_CONFIG #(
    .DONE_PERSISTN("ENABLE"),
    .INIT_PERSISTN("ENABLE"),
    .JTAG_PERSISTN("DISABLE"),
    .PROGRAMN_PERSISTN("DISABLE"))
    config_inst ();
  EF2_PHY_MCU #(
    .GPIO_L0("ENABLE"),
    .GPIO_L1("ENABLE"),
    .GPIO_L10("DISABLE"),
    .GPIO_L11("DISABLE"),
    .GPIO_L12("DISABLE"),
    .GPIO_L13("DISABLE"),
    .GPIO_L14("DISABLE"),
    .GPIO_L15("DISABLE"),
    .GPIO_L2("DISABLE"),
    .GPIO_L3("DISABLE"),
    .GPIO_L4("DISABLE"),
    .GPIO_L5("ENABLE"),
    .GPIO_L6("DISABLE"),
    .GPIO_L7("DISABLE"),
    .GPIO_L8("DISABLE"),
    .GPIO_L9("DISABLE"))
    mcu_inst (
    .ahbslave_dma_req(ahbslave_dma_req),
    .ahbslave_dma_single(ahbslave_dma_single),
    .gpio_h_in({gpio_h15_in,gpio_h14_in,gpio_h13_in,gpio_h12_in,gpio_h11_in,gpio_h10_in,gpio_h9_in,gpio_h8_in,gpio_h7_in,gpio_h6_in,gpio_h5_in,gpio_h4_in,gpio_h3_in,gpio_h2_in,gpio_h1_in,gpio_h0_in}),
    .h2h_hrdata(h2h_hrdata),
    .h2h_hreadyout(h2h_hreadyout),
    .h2h_hresp(h2h_hresp),
    .h2h_mclk(h2h_mclk),
    .h2h_rstn(h2h_rstn),
    .i2s_mst_clk(i2s_mst_clk),
    .ppm_clk(ppm_clk),
    .ppm_rstn(ppm_rstn),
    .qspi_rxd(qspi_rxd),
    .ahbslave_dma_ack(ahbslave_dma_ack),
    .gpio_h_oe_n({gpio_h15_oe_n,gpio_h14_oe_n,gpio_h13_oe_n,gpio_h12_oe_n,gpio_h11_oe_n,gpio_h10_oe_n,gpio_h9_oe_n,gpio_h8_oe_n,gpio_h7_oe_n,gpio_h6_oe_n,gpio_h5_oe_n,gpio_h4_oe_n,gpio_h3_oe_n,gpio_h2_oe_n,gpio_h1_oe_n,gpio_h0_oe_n}),
    .gpio_h_out({gpio_h15_out,gpio_h14_out,gpio_h13_out,gpio_h12_out,gpio_h11_out,gpio_h10_out,gpio_h9_out,gpio_h8_out,gpio_h7_out,gpio_h6_out,gpio_h5_out,gpio_h4_out,gpio_h3_out,gpio_h2_out,gpio_h1_out,gpio_h0_out}),
    .h2h_haddr(h2h_haddr),
    .h2h_hburst(h2h_hburst),
    .h2h_hprot(h2h_hprot),
    .h2h_hsize(h2h_hsize),
    .h2h_htrans(h2h_htrans),
    .h2h_hwdata(h2h_hwdata),
    .h2h_hwrite(h2h_hwrite),
    .qspi_oen(qspi_oen),
    .qspi_sclk(qspi_sclk),
    .qspi_ss(qspi_ss),
    .qspi_txd(qspi_txd),
    .sleep_out(sleep_out),
    .usr_reg(usr_reg));  // al_ip/internal_m3_core.v(165)

endmodule 

