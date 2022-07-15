; ------------------------------------------------------------------------------
; Pounce Wand but good
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
;.definelabel Warp, 0x02320D08
;.definelabel DungeonBaseStructPtr, 0x2353538

; For EU
.include "lib/stdlib_eu.asm"
.include "lib/dunlib_eu.asm"
.definelabel ItemStartAddress, 0x0231C8B0
.definelabel ItemJumpAddress, 0x0231D574
.definelabel Pounce, 0x02320688
.definelabel Warp, 0x02321770
.definelabel DungeonBaseStructPtr, 0x2354138

; File creation
.create "./code_out.bin", 0x0231C8B0 ; For US 0x0231BE50
	.org ItemStartAddress
	.area MaxSize
		
		mov r0, r8
		mov r1, r8
		ldr r2, [r8, #+0xb4]
		ldrb r2, [r2, #+0x4c] ; User Direction
		mov r3, #0
		bl Pounce ; Pounces in user's direction
		ldr r0, [r8, #+0xb4]
		ldrb r0, [r0, #+0x06] ; loads if user is a team member
		cmp r0, #1
		beq end_loop ; jumps to end if user is not a team member (unknown if this is required, kept just in case)
		mov r12, #0
		ldr r4, =DungeonBaseStructPtr
		ldr r4, [r4]
		ldr r0, =0x12B28
		add r4, r4, r0 ; sets r4 to monster table header address
start_loop:
		cmp r12, #4
		bge end_loop ; ends loop when r12 is greater than or equal to 4
		ldr r1, [r4] ; sets warp target to the value at the address in r4
		ldr r0, [r1]
		cmp r0, #0 ; checks if teammate exists
		beq continue ; continues loop if teammate does not exist
		cmp r1, r8 ; checks if warp target and user are the same
		beq continue ; continues loop if warp target and user are the same
		mov r0, r8 ; sets user to user
		mov r2, #5 ; sets to warp to leader
		bl Warp ; Warps ally to leader
continue:
		add r12, #1 ; iterates over loop
		add r4, #0x4 ; moves r4 forward by 4
		b start_loop ; loops back to start of loop
end_loop:
		b ItemJumpAddress
		.pool
	.endarea
.close