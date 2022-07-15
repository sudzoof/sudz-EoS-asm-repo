
.relativeinclude on
.nds
.arm

.definelabel MaxSize, 0x2598

; For US
;.include "lib/stdlib_us.asm"
;.include "lib/dunlib_us.asm"
;.definelabel MoveStartAddress, 0x02330134
;.definelabel MoveJumpAddress, 0x023326CC
;.definelabel DungeonBaseStructPtr, 0x2353538

; For EU
.include "lib/stdlib_eu.asm"
.include "lib/dunlib_eu.asm"
.definelabel MoveStartAddress, 0x02330B74
.definelabel MoveJumpAddress, 0x0233310C
.definelabel DungeonBaseStructPtr, 0x2354138

; File creation
.create "./code_out.bin", 0x02330B74 ; For US 0x02330134
	.org MoveStartAddress
	.area MaxSize
		; secret string
		ldr r3, =DungeonBaseStructPtr
		ldr r3, [r3]
		ldr r0, =0x12B28
		add r3, r3, r0 ; sets r4 to monster table header address
		add r3, #0x50
		mov r12, #0
start_loop:
		cmp r12, #20
		bge end_loop
		ldr r0, [r4] ; calls entity address
		ldr r0, [r0, #+0xb4] ; calls monster data
		ldrh r0, [r0, #+0x2] ; calls species
		ldr r1, =0x0606
		cmp r0, #6
		cmpne r0, r1
		bne continue
		mov r0, r9
		ldr r1, =secret
		bl SendMessageWithStringLog
		b end_loop
continue:
		add r12, #1 ; iterates over loop
		add r3, #0x4 ; moves r4 forward by 4
		b start_loop ; loops back to start of loop
end_loop:
		; raise all stats by 1
		mov r0, r9
		mov r1, r4
		mov r2, #0
		mov r3, #1
		bl AttackStatUp
		mov r0, r9
		mov r1, r4
		mov r2, #1
		mov r3, #1
		bl AttackStatUp
		mov r0, r9
		mov r1, r4
		mov r2, #0
		mov r3, #1
		bl DefenseStatUp
		mov r0, r9
		mov r1, r4
		mov r2, #1
		mov r3, #1
		bl DefenseStatUp
		b MoveJumpAddress
		.pool
secret:
		.asciiz "OMG it's the unbeatable [CS:G]Charizard[CR]!"
	.endarea
.close
