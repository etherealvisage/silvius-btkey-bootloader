#include <stdlib.h>
#include <stdint.h>

extern uint32_t __attribute__((section (".sfrs"))) TRISACLR;
extern uint32_t __attribute__((section (".sfrs"))) LATAINV;

#if 0
	la $t0, TRISACLR
	la $t1, LATAINV
	li $t2, 1

	/* enable output on RA0 */
	sw $t2, 0($t0)
.loop:
	/* toggle output on RA0 */
	sw $t2, 0($t1)

	/* busy-wait */
	la $t3, 0xffff
.busy_loop:
	add $t3, $t3, -1
	bne $t3, $zero, .busy_loop
	nop

	j .loop
	nop
#endif

void entry() {
    TRISACLR = 1;
    int j = 0;
    while(1) {
        if(j == 0) {
            j = 100000;
            LATAINV = 1;
        }
        j --;
    }
}
