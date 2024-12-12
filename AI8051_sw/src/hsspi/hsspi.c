
//-----------------变量定义----------------
bit B_SPI_DMA_busy;	   // SPI DMA忙标志， 1标志SPI-DMA忙，SPI DMA中断中清除此标志，使用SPI DMA前要确认此标志为0
u16 SPI_TxAddr;		   // SPI DMA要发送数据的首地址
u8 xdata DisTmp[3200]; // 显示缓冲，将要显示的内容放在显存里，启动DMA即可. 由于LCM DMA有4字节对齐问题，所以这里定位对地址为4的倍数

// DMA_SPI_CR 	SPI_DMA控制寄存器
#define DMA_ENSPI (1 << 7)	// SPI DMA功能使能控制位，    bit7, 0:禁止SPI DMA功能，  1：允许SPI DMA功能。
#define SPI_TRIG_M (1 << 6) // SPI DMA主机模式触发控制位，bit6, 0:写0无效，          1：写1开始SPI DMA主机模式操作。
#define SPI_TRIG_S (0 << 5) // SPI DMA从机模式触发控制位，bit5, 0:写0无效，          1：写1开始SPI DMA从机模式操作。
#define SPI_CLRFIFO 1		// 清除SPI DMA接收FIFO控制位，bit0, 0:写0无效，          1：写1复位FIFO指针。

// DMA_SPI_CFG 	SPI_DMA配置寄存器
#define DMA_SPIIE (1 << 7)	// SPI DMA中断使能控制位，bit7, 0:禁止SPI DMA中断，     1：允许中断。
#define SPI_ACT_TX (1 << 6) // SPI DMA发送数据控制位，bit6, 0:禁止SPI DMA发送数据，主机只发时钟不发数据，从机也不发. 1：允许发送。
#define SPI_ACT_RX (0 << 5) // SPI DMA接收数据控制位，bit5, 0:禁止SPI DMA接收数据，主机只发时钟不收数据，从机也不收. 1：允许接收。
#define DMA_SPIIP (0 << 2)	// SPI DMA中断优先级控制位，bit3~bit2, (最低)0~3(最高).
#define DMA_SPIPTY 0		// SPI DMA数据总线访问优先级控制位，bit1~bit0, (最低)0~3(最高).

// DMA_SPI_CFG2 	SPI_DMA配置寄存器2
#define SPI_WRPSS (0 << 2) // SPI DMA过程中使能SS脚控制位，bit2, 0: SPI DMA传输过程不自动控制SS脚。  1：自动拉低SS脚。
#define SPI_SSS 3		   // SPI DMA过程中自动控制SS脚选择位，bit1~bit0, 0: P1.4,  1：P2.4,  2: P4.0,  3:P3.5。

// DMA_SPI_STA 	SPI_DMA状态寄存器
#define SPI_TXOVW (1 << 2)	// SPI DMA数据覆盖标志位，bit2, 软件清0.
#define SPI_RXLOSS (1 << 1) // SPI DMA接收数据丢弃标志位，bit1, 软件清0.
#define DMA_SPIIF 1			// SPI DMA中断请求标志位，bit0, 软件清0.

// HSSPI_CFG  高速SPI配置寄存器
#define SS_HOLD (0 << 4) // 高速模式时SS控制信号的HOLD时间， 0~15, 默认3. 在DMA中会增加N个系统时钟，当SPI速度为系统时钟/2时执行DMA，SS_HOLD、SS_SETUP和SS_DACT都必须设置大于2的值.
#define SS_SETUP 3		 // 高速模式时SS控制信号的SETUP时间，0~15, 默认3. 在DMA中不影响时间，       当SPI速度为系统时钟/2时执行DMA，SS_HOLD、SS_SETUP和SS_DACT都必须设置大于2的值.

// HSSPI_CFG2  高速SPI配置寄存器2
#define SPI_IOSW (1 << 6) // bit6:交换MOSI和MISO脚位，0：不交换，1：交换
#define HSSPIEN (0 << 5)  // bit5:高速SPI使能位，0：关闭高速模式，1：使能高速模式
#define FIFOEN (1 << 4)	  // bit4:高速SPI的FIFO模式使能位，0：关闭FIFO模式，1：使能FIFO模式，使能FIFO模式在DMA中减少13个系统时间。
#define SS_DACT 3		  // bit3~0:高速模式时SS控制信号的DEACTIVE时间，0~15, 默认3, 不影响DMA时间.  当SPI速度为系统时钟/2时执行DMA，SS_HOLD、SS_SETUP和SS_DACT都必须设置大于2的值.

#define DMA_SPI_ITVH (*(unsigned char volatile far *)0x7efa2e) /*  SPI_DMA时间间隔寄存器高字节 */
#define DMA_SPI_ITVL (*(unsigned char volatile far *)0x7efa2f) /*  SPI_DMA时间间隔寄存器低字节 */
void SPITX_DMA_TRIG(u8 xdata *TxBuf, u16 size)
{
	//@40MHz, Fosc/4, 200字节258us，100字节  130us，50字节66us，N个字节耗时 N*1.280+2 us, 51T一个字节，其中状态机19T, 传输耗时32T.
	//@40MHz, Fosc/2, 200字节177us，100字节 89.5us，50字节46us，N个字节耗时 N*0.875+2 us, 35T一个字节，其中状态机19T, 传输耗时16T.
	//@40MHz, Fosc/2, SPI DMA传输一个字节, FIFO=1, HOLD=0，耗时16+3=19T(0.475us), HOLD=3，耗时16+6=22T(0.55us).
	//@40MHz, Fosc/4, SPI DMA传输一个字节, FIFO=1, HOLD=0，耗时32+3=35T(0.875us), HOLD=3，耗时32+6=38T(0.95us).
	HSSPI_CFG = SS_HOLD | SS_SETUP; // SS_HOLD会增加N个系统时钟, SS_SETUP没有增加时钟。驱动OLED 40MHz时SS_HOLD可以设置为0，
	HSSPI_CFG2 = FIFOEN | SS_DACT;	// FIFOEN允许FIFO会减小13个时钟.

	SPI_DC = 1; // 写数据
	// P_LCD_CS  = 0;	//片选
	B_SPI_DMA_busy = 1; // 标志SPI-DMA忙，SPI DMA中断中清除此标志，使用SPI DMA前要确认此标志为0

	SPI_TxAddr = (u16)TxBuf;			   // 要发送数据的首地址
	DMA_SPI_TXAH = (u8)(SPI_TxAddr >> 8);  // 发送地址寄存器高字节
	DMA_SPI_TXAL = (u8)SPI_TxAddr;		   // 发送地址寄存器低字节
	DMA_SPI_AMTH = (u8)((size - 1) / 256); // 设置传输总字节数(高8位),	设置传输总字节数 = N+1
	DMA_SPI_AMT = (u8)(size - 1);		   // 设置传输总字节数(低8位).
	DMA_SPI_ITVH = 0;
	DMA_SPI_ITVL = 0;
	DMA_SPI_STA = 0x00;
	DMA_SPI_CFG = DMA_SPIIE | SPI_ACT_TX | SPI_ACT_RX | DMA_SPIIP | DMA_SPIPTY;
	DMA_SPI_CFG2 = SPI_WRPSS | SPI_SSS;
	DMA_SPI_CR = DMA_ENSPI | SPI_TRIG_M | SPI_TRIG_S | SPI_CLRFIFO; // 启动SPI DMA发送命令
}

//========================================================================
// 函数: void SPI_DMA_ISR (void) interrupt DMA_SPI_VECTOR
// 描述:  SPI_DMA中断函数.
// 参数: none.
// 返回: none.
// 版本: V1.0, 2024-1-5
//========================================================================
void SPI_DMA_ISR(void)
#ifdef __MODEL__
	interrupt DMA_SPI_VECTOR
#endif
{
	DMA_SPI_CR = 0;		  // 关闭SPI DMA
	B_SPI_DMA_busy = 0;	  // 清除SPI-DMA忙标志，SPI DMA中断中清除此标志，使用SPI DMA前要确认此标志为0
	SPSTAT = 0x80 + 0x40; // 清0 SPIF和WCOL标志
	HSSPI_CFG2 = SS_DACT; // 使用SPI查询或中断方式时，要禁止FIFO
	// P_LCD_CS = 1;
	DMA_SPI_STA = 0; // 清除中断标志
}

//========================================================================
// 函数: void  SPI_Config(u8 SPI_io, u8 SPI_speed)
// 描述: SPI初始化函数。
// 参数: io: 切换到的IO,            SS  MOSI MISO SCLK
//                       0: 切换到 P1.4 P1.5 P1.6 P1.7
//                       1: 切换到 P2.4 P2.5 P2.6 P2.7
//                       2: 切换到 P4.0 P4.1 P4.2 P4.3
//                       3: 切换到 P3.5 P3.4 P3.3 P3.2
//       SPI_speed: SPI的速度, 0: fosc/4,  1: fosc/8,  2: fosc/16,  3: fosc/2
// 返回: none.
// 版本: VER1.0
// 日期: 2024-8-13
// 备注:
//========================================================================
void SPI_Config(u8 SPI_io, u8 SPI_speed)
{
	SPI_io &= 3;

	SPCTL = SPI_speed & 3; // 配置SPI 速度, 这条指令先执行, 顺便Bit7~Bit2清0
	SSIG = 1;			   // 1: 忽略SS脚，由MSTR位决定主机还是从机		0: SS脚用于决定主机还是从机。
	SPEN = 1;			   // 1: 允许SPI，								0：禁止SPI，所有SPI管脚均为普通IO
	DORD = 0;			   // 1：LSB先发，								0：MSB先发
	MSTR = 1;			   // 1：设为主机								0：设为从机
	CPOL = 1;			   // 1: 空闲时SCLK为高电平，					0：空闲时SCLK为低电平
	CPHA = 1;			   // 1: 数据在SCLK前沿驱动,后沿采样.			0: 数据在SCLK前沿采样,后沿驱动.
	//	SPR1 = 0;	//SPR1,SPR0   00: fosc/4,     01: fosc/8
	//	SPR0 = 0;	//            10: fosc/16,    11: fosc/2
	P_SW1 = (P_SW1 & ~0x0c) | ((SPI_io << 2) & 0x0c); // 切换IO

	HSCLKDIV = 1;		  // HSCLKDIV主时钟分频
	SPI_CLKDIV = 1;		  // SPI_CLKDIV主时钟分频
	SPSTAT = 0x80 + 0x40; // 清0 SPIF和WCOL标志
}

void SoftSPI_WriteByte(u8 Byte)
{
	SPDAT = Byte; // 发送一个字节
	while (SPIF == 0)
		;				  // 等待发送完成
	SPSTAT = 0x80 + 0x40; // 清0 SPIF和WCOL标志
}