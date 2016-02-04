#include <stdlib.h>
#include <stdint.h>

extern uint32_t volatile __attribute__((section (".sfrs"))) TRISACLR;
extern uint32_t volatile __attribute__((section (".sfrs"))) LATAINV;

uint32_t __attribute__((section (".devcfg3"))) devcfg3 = 0xffffffff;
uint32_t __attribute__((section (".devcfg2"))) devcfg2 = 0xffffffff;
uint32_t __attribute__((section (".devcfg1"))) devcfg1 = 0xffffffff;
uint32_t __attribute__((section (".devcfg0"))) devcfg0 = 0xffffffff;

void entry() {
    TRISACLR = 1;
    int j = 0;
    while(1) {
        LATAINV = 1;
        for(j = 0; j < 100000; j ++) {}
    }
}

void nmi_handler() {
    
}
