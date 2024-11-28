/* The system will have maximum 128MByte of SDRAM @ 200Mbps */
/* can bring ~360MB/S bandwidth*/
/* it will take 3600 + 150 + 75 KByte per frame */
/*( raw data + thumbnail + AI process data (YUV422? 233?) )*/
/* consider taking 1/2 as weigth memory, we can store 16 frames (slightly more than 1s) */
/*  */
module ai8051_nb_top(
  input clk_25m,
  input fpga_clk0,
  input fpga_clk1,
  output mcu_clko,
  
  input main_uart_rx,
  output main_uart_tx,

  output fpga_intr,
  
  inout [1:0]fpga_uio,
  
  output aux_uart_tx,
  input aux_uart_rx,  
  
  input hspi_sclk,
  input hspi_mcsn,
  input hspi_mosi,
  output hspi_miso,
  
  input qspi_mclk,
  input qspi_mcsn,
  inout [3:0]qspi_qio,
  
  output sdio_clk,
  output sdio_cmd,
  inout [3:0]sdio_dat,
  /* cameras */
  input cam_pwdn,
  
  input cam0_vsync,
  input cam0_href,
  input cam0_pclk,
  input [7:0]cam0_data,
  
  input cam1_vsync,
  input cam1_href,
  input cam1_pclk,
  input [7:0]cam1_data,
  /*ethernet phy*/
  output [3:0]  rgmii_txd,
  output        rgmii_tx_ctl,
  output        rgmii_txc,
  input  [3:0]  rgmii_rxd,
  input         rgmii_rx_ctl,
  input         rgmii_rxc,
  output mdio_clk,          
  inout mdio_io,
  /*SDRAM*/
  output sdram_clk,
  output sdram_cke,
  output sdram_wen,
  output sdram_casn,
  output sdram_rasn,
  output sdram_csn,
  output [12:0]sdram_addr,
  output [1:0]sdram_ba,
  output sdram_dqml,
  output sdram_dqmh,
  inout [15:0]sdram_data,
  
  output fpga_led,
  output self_intr_loopback
  
);
wire clk_200m;
wire clk_usr;
wire pll_locked;
wire pll_dclk;
wire pll_dcs;
wire pll_dwe;
wire [7:0] pll_di;
wire [5:0] pll_daddr;
wire [7:0] pll_do;

wire root_rstn;

wire system_rstn;
wire mcu_subsys_rstn;

wire 	[31:0]	h2h_haddr;
wire 	[1:0]	h2h_htrans;
wire 			h2h_hwrite;
wire 	[2:0]	h2h_hsize;
wire 	[2:0]	h2h_hburst;
wire 	[3:0]	h2h_hprot;
wire 	[31:0]	h2h_hwdata;
wire 	[31:0]	h2h_hrdata;
wire 	h2h_hreadyout;
wire 	[1:0]	h2h_hresp;
wire 	h2h_mclk;
wire 	h2h_rstn;
wire 	ahbslave_dma_req;
wire 	ahbslave_dma_single;
wire 	ahbslave_dma_ack;
wire 	[3:0]	qspi_rxd;
wire 	[3:0]	qspi_txd;
wire 	qspi_sclk;
wire 	qspi_ss;
wire 	[3:0]	qspi_oen;
wire 	ppm_clk;
wire 	i2s_mst_clk;
wire 	ppm_rstn;
wire 	gpio_h0_out;
wire 	gpio_h0_oe_n;
wire 	gpio_h0_in;
wire 	gpio_h1_out;
wire 	gpio_h1_oe_n;
wire 	gpio_h1_in;
wire 	gpio_h2_out;
wire 	gpio_h2_oe_n;
wire 	gpio_h2_in;
wire 	gpio_h3_out;
wire 	gpio_h3_oe_n;
wire 	gpio_h3_in;
wire 	gpio_h4_out;
wire 	gpio_h4_oe_n;
wire 	gpio_h4_in;
wire 	gpio_h5_out;
wire 	gpio_h5_oe_n;
wire 	gpio_h5_in;
wire 	gpio_h6_out;
wire 	gpio_h6_oe_n;
wire 	gpio_h6_in;
wire 	gpio_h7_out;
wire 	gpio_h7_oe_n;
wire 	gpio_h7_in;
wire 	gpio_h8_out;
wire 	gpio_h8_oe_n;
wire 	gpio_h8_in;
wire 	gpio_h9_out;
wire 	gpio_h9_oe_n;
wire 	gpio_h9_in;
wire 	gpio_h10_out;
wire 	gpio_h10_oe_n;
wire 	gpio_h10_in;
wire 	gpio_h11_out;
wire 	gpio_h11_oe_n;
wire 	gpio_h11_in;
wire 	gpio_h12_out;
wire 	gpio_h12_oe_n;
wire 	gpio_h12_in;
wire 	gpio_h13_out;
wire 	gpio_h13_oe_n;
wire 	gpio_h13_in;
wire 	gpio_h14_out;
wire 	gpio_h14_oe_n;
wire 	gpio_h14_in;
wire 	gpio_h15_out;
wire 	gpio_h15_oe_n;
wire 	gpio_h15_in;
wire 	sleep_out;
wire 	[15:0]	usr_reg;

reg [4:0]root_rst_cnt=0;
assign root_rstn = (&root_rstn);
always@(posedge clk_25m)
begin
	if(!root_rstn)
		root_rst_cnt<=root_rst_cnt+1;
	else
		root_rst_cnt<=root_rst_cnt;
end
assign mcu_subsys_rstn=root_rstn;
sys_pll system_pll(
  .refclk(clk_25m),
  .reset(!root_rstn),
  .extlock(pll_locked),
  //PLL Control intf
  .dclk(pll_dclk),
  .dcs(pll_dcs),
  .dwe(pll_dwe),
  .di(pll_di),
  .daddr(pll_daddr),
  .do(pll_do),
  .clk0_out(clk_200m), //300M DDR
  .clk1_out(sdram_clk),
  .clk2_out(clk_usr)//,
//  .clk3_out(sample_clk_div4x),
//  .clk4_out(hspi_tx_clk_120M),
//  .clk5_out(/*pad_o_HSPI_HTCLK*/),
//  .clk6_out()
);

internal_m3_core u_m3_core( 
	.ppm_clk(clk_200m),
	.i2s_mst_clk(i2s_mst_clk),
	.ppm_rstn(mcu_subsys_rstn),
	.h2h_haddr(h2h_haddr),
	.h2h_htrans(h2h_htrans),
	.h2h_hwrite(h2h_hwrite),
	.h2h_hsize(h2h_hsize),
	.h2h_hburst(h2h_hburst),
	.h2h_hprot(h2h_hprot),
	.h2h_hwdata(h2h_hwdata),
	.h2h_hrdata(h2h_hrdata),
	.h2h_hreadyout(h2h_hreadyout),
	.h2h_hresp(h2h_hresp),
	.h2h_mclk(h2h_mclk),
	.h2h_rstn(h2h_rstn),
	.ahbslave_dma_req(ahbslave_dma_req),
	.ahbslave_dma_single(ahbslave_dma_single),
	.ahbslave_dma_ack(ahbslave_dma_ack),
	.sleep_out(sleep_out),
	.usr_reg(usr_reg),
	.qspi_rxd(qspi_rxd),
	.qspi_txd(qspi_txd),
	.qspi_sclk(qspi_sclk),
	.qspi_ss(qspi_ss),
	.qspi_oen(qspi_oen),
	.gpio_h0_out(gpio_h0_out),
	.gpio_h0_oe_n(gpio_h0_oe_n),
	.gpio_h0_in(gpio_h0_in),
	.gpio_h1_out(gpio_h1_out),
	.gpio_h1_oe_n(gpio_h1_oe_n),
	.gpio_h1_in(gpio_h1_in),
	.gpio_h2_out(gpio_h2_out),
	.gpio_h2_oe_n(gpio_h2_oe_n),
	.gpio_h2_in(gpio_h2_in),
	.gpio_h3_out(gpio_h3_out),
	.gpio_h3_oe_n(gpio_h3_oe_n),
	.gpio_h3_in(gpio_h3_in),
	.gpio_h4_out(gpio_h4_out),
	.gpio_h4_oe_n(gpio_h4_oe_n),
	.gpio_h4_in(gpio_h4_in),
	.gpio_h5_out(gpio_h5_out),
	.gpio_h5_oe_n(gpio_h5_oe_n),
	.gpio_h5_in(gpio_h5_in),
	.gpio_h6_out(gpio_h6_out),
	.gpio_h6_oe_n(gpio_h6_oe_n),
	.gpio_h6_in(gpio_h6_in),
	.gpio_h7_out(gpio_h7_out),
	.gpio_h7_oe_n(gpio_h7_oe_n),
	.gpio_h7_in(gpio_h7_in),
	.gpio_h8_out(gpio_h8_out),
	.gpio_h8_oe_n(gpio_h8_oe_n),
	.gpio_h8_in(gpio_h8_in),
	.gpio_h9_out(gpio_h9_out),
	.gpio_h9_oe_n(gpio_h9_oe_n),
	.gpio_h9_in(gpio_h9_in),
	.gpio_h10_out(gpio_h10_out),
	.gpio_h10_oe_n(gpio_h10_oe_n),
	.gpio_h10_in(gpio_h10_in),
	.gpio_h11_out(gpio_h11_out),
	.gpio_h11_oe_n(gpio_h11_oe_n),
	.gpio_h11_in(gpio_h11_in),
	.gpio_h12_out(gpio_h12_out),
	.gpio_h12_oe_n(gpio_h12_oe_n),
	.gpio_h12_in(gpio_h12_in),
	.gpio_h13_out(gpio_h13_out),
	.gpio_h13_oe_n(gpio_h13_oe_n),
	.gpio_h13_in(gpio_h13_in),
	.gpio_h14_out(gpio_h14_out),
	.gpio_h14_oe_n(gpio_h14_oe_n),
	.gpio_h14_in(gpio_h14_in),
	.gpio_h15_out(gpio_h15_out),
	.gpio_h15_oe_n(gpio_h15_oe_n),
	.gpio_h15_in(gpio_h15_in) );
  //thumbnail data
  wire 			cam0_thumb_tvalid;
  wire 			cam0_thumb_tready;
  wire [15:0]	cam0_thumb_tdata;
  wire [1:0]	cam0_thumb_tstrb;
  wire 			cam0_thumb_tlast;
  wire 			cam0_pixel_tvalid;
  wire 			cam0_pixel_tready;
  wire [15:0]	cam0_pixel_tdata;
  wire [1:0]	cam0_pixel_tstrb;
  wire 			cam0_pixel_tlast;
  wire 			cam0_aidat_tvalid;
  wire 			cam0_aidat_tready;
  wire [15:0]	cam0_aidat_tdata;
  wire [1:0]	cam0_aidat_tstrb;
  wire 			cam0_aidat_tlast;
/* SDRAM access manager (frame mgr) */  
  
/* SDRAM INTERFACE */


/* CAM0 ISP subsystem */
ov2640_isp isp0_inst(
  .system_rstn(system_rstn),
  .cam_vsync(cam0_vsync),
  .cam_href(cam0_href),
  .cam_pclk(cam0_pclk), //Camera clock
  .cam_data(cam0_data),
  
  //SDRAM clock region
  .system_clock(clk_200m),
  //thumbnail data
  .axis_thumb_tvalid	(cam0_thumb_tvalid),
  .axis_thumb_tready	(cam0_thumb_tready),
  .axis_thumb_tdata		(cam0_thumb_tdata),
  .axis_thumb_tstrb		(cam0_thumb_tstrb),
  .axis_thumb_tlast		(cam0_thumb_tlast),
  .axis_pixel_tvalid	(cam0_pixel_tvalid),
  .axis_pixel_tready	(cam0_pixel_tready),
  .axis_pixel_tdata		(cam0_pixel_tdata),
  .axis_pixel_tstrb		(cam0_pixel_tstrb),
  .axis_pixel_tlast		(cam0_pixel_tlast),
  .axis_aidat_tvalid	(cam0_aidat_tvalid),
  .axis_aidat_tready	(cam0_aidat_tready),
  .axis_aidat_tdata		(cam0_aidat_tdata),
  .axis_aidat_tstrb		(cam0_aidat_tstrb),
  .axis_aidat_tlast		(cam0_aidat_tlast)
);
/* CAM1 ISP inst (TBI) */

/* QSPI slave memory HP interface */

/* HSSPI control / Ethernet interface */

/* UART interface (?) */

/* Ethernet interface */



endmodule
