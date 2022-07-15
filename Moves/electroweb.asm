
.relativeinclude on
.nds
.arm

.definelabel MaxSize, 0x2598

; For US
;.include "lib/stdlib_us.asm"
;.include "lib/dunlib_us.asm"
;.definelabel MoveStartAddress, 0x02330134
;.definelabel MoveJumpAddress, 0x023326CC

; For EU
.include "lib/stdlib_eu.asm"
.include "lib/dunlib_eu.asm"
.definelabel MoveStartAddress, 0x02330B74
.definelabel MoveJumpAddress, 0x0233310C
.definelabel RandomFunc, 0x22EB448

; File creation
.create "./code_out.bin", 0x02330B74 ; For US 0x02330134
	.org MoveStartAddress
	.area MaxSize
		mov r0, r9
		mov r1, r4
		mov r2, r8
		mov r3, #0x100
		bl DealDamage ; deals damage to target with a x1 multiplier
		cmp r0, #0
		beq @@ret
		mov r0, #10
		bl RandomFunc
		cmp r0, #7
		ble @@ret
		mov r0, r9
		mov r1, r4
		mov r2, #1
		mov r3, #1
		bl SpeedStatDown
@@ret:
		b MoveJumpAddress
		.pool
	.endarea
.close
