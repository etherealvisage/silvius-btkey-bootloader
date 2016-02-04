.section .reset
.global _start

_start:
	/* check if this was caused by a power-on or hardware reset... */
	la	$k0, 0xbf80f600 /* RCON register */
	lw	$k1, 0($k0)
	and	$k1, $k1, 0x83
	beqz	$k1, .use_target_code /* if $k1 = 0, some other reset caused this. */
	nop

	/* OK, power-on. Use bootloader code. */
.use_bootloader:
	jal	initialize_ram
.extern entry
	jal	entry

	/* if entry returns, just busy-wait forever... */
.loop_forever:
	j	.loop_forever
	nop

.use_target_code:
	/* let's ensure first that there is a valid target */
	li	$k0, 0xbd000000
	lw	$k0, 0($k0)
	li	$k1, 0xffffffff
	beq	$k0, $k1, .use_bootloader /* if invalid, use the bootloader */
	nop

	/* otherwise, jump to target code. */
	li	$k0, 0xbd000000
	jr	$k0
	nop

initialize_ram:
.extern _gp
	/* set up $gp register */
	la 	$gp, _gp
	/* set up $sp register */
	la	$sp, _sp

	/* set up bss */
.extern bss_ram_begin
.extern bss_ram_end
	la	$t0, bss_ram_begin
	la	$t1, bss_ram_end

.zero_loop:
	beq	$t0, $t1, .zero_loop_end
	nop

	sw	$zero, 0($t0)
	add	$t0, $t0, 4
	j	.zero_loop
	nop

.zero_loop_end:
	/* set up data */
.extern data_ram_begin
.extern data_ram_end
.extern data_flash_end
	la	$t0, data_ram_begin
	la	$t1, data_ram_end
	la	$t2, data_flash_begin

.copy_loop:
	beq	$t0, $t1, .copy_loop_end
	nop

	lw	$t3, 0($t0)
	sw	$t3, 0($t2)

	add	$t0, $t0, 4
	add	$t2, $t2, 4

	j	.copy_loop
	nop
.copy_loop_end:

	jr 	$ra
	nop
