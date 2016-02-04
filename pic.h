#ifndef PIC_H
#define PIC_H

#include <stdint.h>

extern uint32_t volatile __attribute__((section (".sfrs"))) SYSKEY;
extern uint32_t volatile __attribute__((section (".sfrs"))) OSCCON;

extern uint32_t volatile __attribute__((section (".sfrs"))) U1MODE;
extern uint32_t volatile __attribute__((section (".sfrs"))) U1STA;
extern uint32_t volatile __attribute__((section (".sfrs"))) U1TXREG;
extern uint32_t volatile __attribute__((section (".sfrs"))) U1RXREG;
extern uint32_t volatile __attribute__((section (".sfrs"))) U1BRG;

extern uint32_t volatile __attribute__((section (".sfrs"))) NVMCON;
extern uint32_t volatile __attribute__((section (".sfrs"))) NVMCONCLR;
extern uint32_t volatile __attribute__((section (".sfrs"))) NVMCONSET;
extern uint32_t volatile __attribute__((section (".sfrs"))) NVMCONINV;
extern uint32_t volatile __attribute__((section (".sfrs"))) NVMKEY;
extern uint32_t volatile __attribute__((section (".sfrs"))) NVMADDR;
extern uint32_t volatile __attribute__((section (".sfrs"))) NVMDATA;
extern uint32_t volatile __attribute__((section (".sfrs"))) NVMSRCADDR;

extern uint32_t volatile __attribute__((section (".sfrs"))) ANSELACLR;
extern uint32_t volatile __attribute__((section (".sfrs"))) TRISACLR;
extern uint32_t volatile __attribute__((section (".sfrs"))) LATAINV;

extern uint32_t volatile __attribute__((section (".sfrs"))) ANSELBCLR;
extern uint32_t volatile __attribute__((section (".sfrs"))) TRISBSET;
extern uint32_t volatile __attribute__((section (".sfrs"))) TRISBCLR;

extern uint32_t volatile __attribute__((section (".sfrs"))) U1RXR;
extern uint32_t volatile __attribute__((section (".sfrs"))) RPB15R;


#endif
