
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

; File creation
.create "./code_out.bin", 0x02330B74 ; For US 0x02330134
	.org MoveStartAddress
	.area MaxSize
		mov r0, r9
		mov r1, r9
		mov r2, #0
		mov r3, #2
		bl DefenseStatUp
		mov r0, r9
		mov r1, r9
		mov r2, #1
		mov r3, #2
		bl DefenseStatUp
		b MoveJumpAddress
		.pool
	.endarea
.close
