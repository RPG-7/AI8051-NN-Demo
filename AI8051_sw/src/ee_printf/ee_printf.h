/*
Copyright 2018 Embedded Microprocessor Benchmark Consortium (EEMBC)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Original Author: Shay Gal-on
*/

/* Topic: Description
        This file contains  declarations of the various benchmark functions.
*/

/* Configuration: TOTAL_DATA_SIZE
        Define total size for data algorithms will operate on
*/

/*
Copyright 2018 Embedded Microprocessor Benchmark Consortium (EEMBC)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Original Author: Shay Gal-on
*/
/* Topic : Description
        This file contains configuration constants required to execute on
   different platforms
*/
/************************/
/* Data types and settings */
/************************/
/* Configuration : HAS_FLOAT
        Define to 1 if the platform supports floating point.
*/
#define HAS_FLOAT 0
// #ifndef HAS_FLOAT

// #endif
// typedef signed short   ee_s16;
// typedef unsigned short ee_u16;
// typedef signed int     ee_s32;
// typedef double         ee_f32;
// typedef unsigned char  ee_u8;
// typedef unsigned int   ee_u32;
typedef unsigned int   ee_size_t;
typedef unsigned int   size_t;
#include "uart.h"
#define UART1      ((Uart_Reg*)(0xF0010000))



int ee_printf(const char *fmt, ...);

#define printf ee_printf



