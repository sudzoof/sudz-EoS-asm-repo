; ------------------------------------------------------------------------------
; Pulls enemy towards you
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
;.definelabel Pounce, 0x0231FC20

; For EU
.include "lib/stdlib_eu.asm"
.include "lib/dunlib_eu.asm"
.definelabel ItemStartAddress, 0x0231C8B0
.definelabel ItemJumpAddress, 0x0231D574
.definelabel Pounce, 0x02320688

; File creation
.create "./code_out.bin", 0x0231C8B0 ; For US 0x0231BE50
	.org ItemStartAddress
	.area MaxSize
		
		mov r0, r8
		mov r1, r7
		ldr r2, [r8, #+0xb4]
		ldrb r2, [r2, #+0x4c] ; User Direction
		cmp r2, #3
		ble case_1
		cmp r2, #4
		bge case_2
case_1:
		add r2, #4
		b end
case_2: 
		sub r2, #4
		b end
end:
		mov r3, #0
		bl Pounce ; Pounces in opposite of user's direction
		b ItemJumpAddress
		.pool
	.endarea
.close