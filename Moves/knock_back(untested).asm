; 
; ------------------------------------------------------------------------------
; Pushes back enemy a tile
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
;.definelabel Pounce, 0x0231FC20
;.definelabel GetTilePointer, 0x23360FC

; For EU
.include "lib/stdlib_eu.asm"
.include "lib/dunlib_eu.asm"
.definelabel MoveStartAddress, 0x02330B74
.definelabel MoveJumpAddress, 0x0233310C
.definelabel Pounce, 0x02320688
.definelabel GetTilePointer, 0x2336CCC

; File creation
.create "./code_out.bin", 0x02330B74 ; Change to the actual offset as this directive doesn't accept labels
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
		
		
		; Code here
		
		; create wall behind target
		ldrh r0, [r4, #+0x4] ; Get target x position
		ldrh r1, [r4, #+0x6] ; Get target y position
		ldr r2, [r0, #+0xb4]
		ldrb r2, [r2,#+0x4c] ; Get user direction
		
		; sets position 2 away from target in user direction
		cmp r2, #0
		addeq r1, #2 ; make sure to test that this actually creates a wall in the correct position
		beq end_switch

		cmp r2, #1
		addeq r0, #2
		addeq r1, #2
		beq end_switch

		cmp r2, #2
		addeq r0, #2
		beq end_switch

		cmp r2, #3
		addeq r0, #2
		subeq r1, #2
		beq end_switch

		cmp r2, #4
		subeq r1, #2
		beq end_switch

		cmp r2, #5
		subeq r0, #2
		subeq r1, #2
		beq end_switch

		cmp r2, #6
		subeq r0, #2
		beq end_switch

		cmp r2, #7
		subeq r0, #2
		addeq r1, #2

end_switch:
		
		bl GetTilePointer 
		ldrh r1, [r0] ; gets tile info
		push {r0, r1} ; stores tile and tile info for future use
		orr r1, r1, 0xc800
		sub r1, r1, 0xc000
		strh r1, [r0] ; sets tile to unpassable wall

		; pounce enemy towards created wall
		mov r0, r9
		mov r1, r4
		mov r2, 8h
		bl Pounce

		; reset wall to whatever tile type it was beforehand
		pop {r0, r1} ; gets tile and tile info
		strh r1, [r0] ; sets tile to original data

		; deal damage
		mov r0, r9
		mov r1, r4
		mov r2, r6
		mov r3, 0x100
		bl DealDamage

		b MoveJumpAddress
		.pool
	.endarea
.close