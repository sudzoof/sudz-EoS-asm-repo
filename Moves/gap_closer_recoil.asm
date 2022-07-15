; ------------------------------------------------------------------------------
; Closes the distance between you and an enemy. Does recoil damage.
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

		ldr r0,[r9,#+0xb4]
		ldrb r2,[r0,#+0x4c]
		mov r0, r9
		mov r1, r9
		bl Pounce
		mov r0, r9
		mov r1, r4
		mov r2, r8
		mov r3, r7
		bl DamageWithRecoil
		b MoveJumpAddress
		.pool
	.endarea
.close
