; 
; ------------------------------------------------------------------------------
; Heals user for 50% and allies for 25%
; ------------------------------------------------------------------------------


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
		
		ldr r0,[r4,#+0xb4]
		ldrsh r1,[r0, #+0x12]
		ldrsh r0,[r0, #+0x16]
		add r0,r0,r1 ; Compute the user's Max HP
		cmp r4, r7
		moveq r1, #2
		movne r1, #4
		bl EuclidianDivision
		mov r2,r0
		mov r0,r9
		mov r1,r4
		mov r3,#0
		bl RaiseHP

		b MoveJumpAddress
		.pool
	.endarea
.close