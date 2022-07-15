; 
; ------------------------------------------------------------------------------
; Sucks enemies in
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
;.definelabel Pounce, 0x0231FC20

; For EU
.include "lib/stdlib_eu.asm"
.include "lib/dunlib_eu.asm"
.definelabel MoveStartAddress, 0x02330B74
.definelabel MoveJumpAddress, 0x0233310C
.definelabel Pounce, 0x02320688

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
		beq ret
		mov r0, r9
		mov r1, r4
		ldr r2, [r9, #+0xb4]
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
ret:
		b MoveJumpAddress
		.pool
	.endarea
.close