/*FIFO, DSP*/
module ov2640_isp(
  input system_rstn,

  input cam_vsync,
  input cam_href,
  input cam_pclk, //Camera clock
  input [7:0]cam_data,
  
  //SDRAM clock region
  input system_clock,
  //thumbnail data
  output 		axis_thumb_tvalid,
  input 		axis_thumb_tready,
  output [15:0]	axis_thumb_tdata,
  output [1:0]	axis_thumb_tstrb,
  output 		axis_thumb_tlast,
  //raw pixel data
  output 		axis_pixel_tvalid,
  input 		axis_pixel_tready,
  output [15:0]	axis_pixel_tdata,
  output [1:0]	axis_pixel_tstrb,
  output 		axis_pixel_tlast,
  //preprocessed for AI data, YUV422?
  
  output 		axis_aidat_tvalid,
  input 		axis_aidat_tready,
  output [15:0]	axis_aidat_tdata,
  output [1:0]	axis_aidat_tstrb,
  output 		axis_aidat_tlast
);
wire camdata_wr_last;
wire camdata_wren; 
wire [15:0]camdata_rd;
wire [1:0]camdata_last_data;
wire camdata_rden;
wire camfifo_empty,camfifo_full,camfifo_hlvl;
wire sof_sys;
/* 1 stage FF to generate HSYNC */
/* 1x wr_last is end of line */
reg caminfo_ff0;
reg [7:0]camdata_ff0;
reg [4:0]sof_sync; //VSYNC sync to SYS_CLK to mark SOF;

always@(posedge cam_pclk or negedge system_rstn)
if(!system_rstn)
begin
	caminfo_ff0<=1'b0;
end
else
begin
	caminfo_ff0<=cam_href;
end

assign camdata_wren = caminfo_ff0;
assign camdata_wr_last = caminfo_ff0 & (!cam_href);
fifo_1kx9 input_fifo(
	.rst(!system_rstn),
	.di({camdata_wr_last,cam_data}), 
	.clkw(cam_pclk), 
	.we(camdata_wren),
	.do({camdata_last_data[1],camdata_rd[15:8],camdata_last_data[1],camdata_rd[7:0]}), 
	.clkr(system_clock), 
	.re(camdata_rden),
	.empty_flag(camfifo_empty),
	.full_flag(camfifo_full), 
	.afull_flag(camfifo_hlvl) 
);

always@(posedge cam_pclk or negedge system_rstn)
if(!system_rstn)
begin
	sof_sync<=1'b0;
end
else
begin
	sof_sync<={sof_sync[3:0],cam_vsync};
end
/* to end previous frame and present new frame*/
assign sof_sys = sof_sync [4:1] == 4'b0111;



endmodule
