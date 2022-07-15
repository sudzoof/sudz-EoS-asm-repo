; ------------------------------------------------------------------------------
; Blows back enemies
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
;.definelabel BlowAway, 0x0231FDE0

; For EU
.include "lib/stdlib_eu.asm"
.include "lib/dunlib_eu.asm"
.definelabel ItemStartAddress, 0x0231C8B0
.definelabel ItemJumpAddress, 0x0231D574
.definelabel BlowAway, 0x02320848

; File creation
.create "./code_out.bin", 0x0231C8B0 ; For US 0x0231BE50
	.org ItemStartAddress
	.area MaxSize
		
		mov r0, r8
		mov r1, r7
		ldr r2, [r8, #+0xb4]
		ldrb r2, [r2, #+0x4c] ; User Direction
		bl BlowAway ;  Blows back in user's direction
		b ItemJumpAddress
		.pool
	.endarea
.close