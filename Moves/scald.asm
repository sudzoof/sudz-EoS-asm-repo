; 
; ------------------------------------------------------------------------------
; Scald but higher chance to burn
; ------------------------------------------------------------------------------


.relativeinclude on
.nds
.arm


.definelabel MaxSize, 0x2598

; Uncomment the correct version

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
.definelabel RandomFunc, 0x22EB448

; File creation
.create "./code_out.bin", 0x02330B74 ; For US 0x02330134
	.org MoveStartAddress
	.area MaxSize ; Define the size of the area
		; Usable Variables: 
		; r6 = Move ID
		; r9 = User Monster Structure Pointer
		; r4 = Target Monster Structure Pointer
		; r8 = Move Data Structure Pointer (8 bytes: flags [4 bytes], move_id [2 bytes], pp_left [1 byte], boosts [1 byte])
		; r7 = ID of the item that called this move (0 if the move effect isn't from an item)
		; Returns: 
		; r10 (bool) = ???
		; Registers r4 to r9, r11 and r13 must remain unchanged after the execution of that code
		
		sub sp, sp, 4h
		mov r0, r9
		mov r1, r4
		mov r2, r8
		mov r3, #0x100
		cmp r0, #0
		beq ret
		bl DealDamage ; deals damage to target with a x1 multiplier
		mov r0, #2
		bl RandomFunc
		cmp r0, #0
		beq ret
		mov r0, #0
		str r0, [sp]
		mov r0, r9
		mov r1, r4
		mov r2, #0
		mov r3, #1
		bl Burn
ret:
		add sp, sp, 4h
		b MoveJumpAddress
		.pool
	.endarea
.close