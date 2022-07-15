; ------------------------------------------------------------------------------
; Petrifies an enemy
; ------------------------------------------------------------------------------

.relativeinclude on
.nds
.arm

.definelabel MaxSize, 0xCC4

; For US
;.include "lib/stdlib_us.asm"
;.include "lib/dunlib_us.asm"
;.definelabel ItemStartAddress, 0x0231BE50
;.definelabel ItemJumpAddress, 0x0231CB14

; For EU
.include "lib/stdlib_eu.asm"
.include "lib/dunlib_eu.asm"
.definelabel ItemStartAddress, 0x0231C8B0
.definelabel ItemJumpAddress, 0x0231D574

; File creation
.create "./code_out.bin", 0x0231C8B0 ; For US 0x0231BE50
	.org MoveStartAddress
	.area MaxSize
		mov r0, r8
		mov r1, r7
		bl Petrify
		b MoveJumpAddress
		.pool
	.endarea
.close