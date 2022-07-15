; 
; ------------------------------------------------------------------------------
; A template to code your own move effects
; ------------------------------------------------------------------------------


.relativeinclude on
.nds
.arm


.definelabel MaxSize, 0x2598

; Uncomment the correct version

; For US
;.include "lib/stdlib_us.asm"
;.include "lib/dunlib_us.asm"
;.definelabel MoveStartAddress, 0x02330134
;.definelabel MoveJumpAddress, 0x023326CC
;.definelabel GetTilePointer, 0x23360FC

; For EU
.include "lib/stdlib_eu.asm"
.include "lib/dunlib_eu.asm"
.definelabel MoveStartAddress, 0x02330B74
.definelabel MoveJumpAddress, 0x0233310C
.definelabel GetTilePointer, 0x2336CCC


; File creation
.create "./code_out.bin", 0x02330B74 ; For US 0x02330134
	.org MoveStartAddress
	.area MaxSize
		mov r0, r9
		mov r1, r4
		mov r2, r8
		mov r3, 0x100 ; sets center damage
		bl DealDamage ; damages center target
		mov r2, #0
		mov r3, #0
start_loop:		; iterate through surrounding tiles
		cmp r3, #3
		bge end_loop
		; sets position for tile check
		ldrh r0, [r4, #+0x4]
		ldrh r1, [r4, #+0x6]
		cmp r2, #1
		sublt r0, r0, #1
		addgt r0, r0, #1
		cmp r3, #1
		sublt r1, r1, #1
		addgt r1, r1, #1
		and r12, r2, r3
		cmp r12, #1
		beq continue_loop ; continues loop if targeting center
		bl check_tile
continue_loop:
		add r2, r2, #1
		cmp r2, #3
		addge r3, r3, #1
		movge r2, #0
		b start_loop
end_loop:
		b MoveJumpAddress
		.pool
check_tile:		; checks tile, does damage if spread damage target is the same alignment as the attack target
		push {r0-r3, lr}
		bl GetTilePointer
		ldr r1, [r0, #+0xc]
		cmp r1, #0
		beq end_check_tile
		ldr r2, [r1, #+0xb4] ; checks alignment of target of spread damage
		ldrb r0, [r2, #+0x6]
		ldrb r2, [r2, #+0x8]
		cmp r0, #1
		cmpeq r2, #0
		moveq r3, #1
		movne r3, #0 ; 0 if ally, 1 if enemy
		ldr r2, [r4, #+0xb4] ; checks alignment of attack target
		ldrb r0, [r2, #+0x6]
		ldrb r2, [r2, #+0x8]
		cmp r0, #1
		cmpeq r2, #0
		moveq r0, #1
		movne r0, #0 ; 0 if ally, 1 if enemy
		cmp r0, r3
		bne end_check_tile ; branches to end if attack target and spread damage target are not the same alignment
		mov r0, r9
		mov r2, r8
		mov r3, 0x100 ; sets spread damage
		bl DealDamage
end_check_tile:
		pop{r0-r3, lr}
		bx lr
	.endarea
.close