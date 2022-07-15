; ------------------------------------------------------------------------------
; Warps an enemy and then petrifies it
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
;.definelabel Warp, 0x02320D08

; For EU
.include "lib/stdlib_eu.asm"
.include "lib/dunlib_eu.asm"
.definelabel ItemStartAddress, 0x0231C8B0
.definelabel ItemJumpAddress, 0x0231D574
.definelabel Warp, 0x02321770

; File creation
.create "./code_out.bin", 0x0231C8B0 ; For US 0x0231BE50
	.org ItemStartAddress
	.area MaxSize
		mov r0, r8
		mov r1, r7
		mov r2, #0
		bl Warp
		bl Petrify
		b ItemJumpAddress
		.pool
	.endarea
.close