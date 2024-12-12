#include "uart.h"
#include "usb_cdc.h"



static void
uart_send_char(char c)
{
//#error "You must implement the method uart_send_char to use this file!\n";
    /*	Output of a char to a UART usually follows the following model:
            Wait until UART is ready
            Write char to UART
            Wait until UART is done

            Or in code:
            while (*UART_CONTROL_ADDRESS != UART_READY);
            *UART_DATA_ADDRESS = c;
            while (*UART_CONTROL_ADDRESS != UART_READY);

            Check the UART sample code on your platform or the board
       documentation.
    */
   uart_write(UART1,c);
}