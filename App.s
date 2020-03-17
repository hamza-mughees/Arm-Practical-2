	AREA	AsmTemplate, CODE, READONLY
	;AREA	reset, CODE, READWRITE
	IMPORT	main

; sample program makes the 4 LEDs P1.16, P1.17, P1.18, P1.19 go on and off in sequence
; (c) Mike Brady, 2011 -- 2019.

	EXPORT	start
start

IO1DIR	EQU	0xE0028018
IO1SET	EQU	0xE0028014
IO1CLR	EQU	0xE002801C
	
	ldr r0,=0
	ldr r1,=0
	ldr r2,=0	
	ldr r3,=0
	ldr r4,=0
	ldr r5,=0
	ldr r6,=0
	ldr r7,=0	
	ldr r8, =0
	ldr r9, =0
	ldr r10, =0
	ldr r11, =0
	ldr r12, =0
	ldr	r1,=IO1DIR
	ldr	r2,=0x000f0000	;select P1.19--P1.16
	str	r2,[r1]		;make them outputs
	ldr	r1,=IO1SET
	str	r2,[r1]		;set them to turn the LEDs off
	ldr	r2,=IO1CLR
	
	ldr r0, =number		; number contains address of the value
	ldr r5, [r0]		; load r5 with value at the address number
	
	ldr r8,=0

;	-----------------------------------------------
	ldr r6, =digits		; digit analisation
	mov r9, r5
checkTens
	ldr r7, [r6]
	cmp r9, r7
	bge calcDigit
	add r6, #4
	b	checkTens
	
calcDigit
	sub r9, r7
	add r8, #1
	cmp r9, r7				
	bge calcDigit
	add r6, #4
	bl  display				
	
	mov r8,#0
	
	ldr r7, [r6]
	cmp r9, r7
	bge otherwise
	add r6, #4
	bl	display
	ldr r7, [r6]
otherwise
	cmp r9, #0
	bgt calcDigit
	mov r9, r5
	ldr r6, =digits
	b	checkTens
	
stop	B	stop

number	DCD 0x00000619
digits	DCD 1000000000, 100000000, 10000000, 1000000, 100000, 10000, 1000, 100, 10, 1

display
	push{r0-r7,r9-r12,lr}
	
	ldr	r4, =800000
deloop	
	subs r4,r4,#1
	cmp  r4,#0	
	bne	deloop
	
	mov r11, #0x000f0000
	str r11, [r1]
	
	
	ldr r11, =0x000f0000
	cmp r8, #0
	bne cmpOne
    str r11, [r2]
	b finish
cmpOne	
	cmp r8, #1
	bne cmpTwo
	mov r11, #0x00080000
	str r11, [r2]
	b finish
cmpTwo
	cmp r8, #2
	bne cmpThree
	mov r11, #0x00040000
	str r11, [r2]
	b finish
cmpThree
	cmp r8, #3
	bne cmpFour
	mov r11, #0x000C0000
	str r11, [r2]
	b finish
cmpFour
	cmp r8, #4
	bne cmpFive
	mov r11, #0x00020000
	str r11, [r2]
	b finish
cmpFive
	cmp r8, #5
	bne cmpSix
	mov r11, #0x000A0000
	str r11, [r2]
	b finish
cmpSix
	cmp r8, #6
	bne cmpSeven
	mov r11, #0x00060000
	str r11, [r2]
	b finish
cmpSeven
	cmp r8, #7
	bne cmpEight
	mov r11, #0x000E0000
	str r11, [r2]
	b finish
cmpEight
	cmp r8, #8
	bne cmpNine
	mov r11, #0x00010000
	str r11, [r2]
	b finish
cmpNine
	cmp r8, #9
	bne finish
	mov r11, #0x00090000
	str r11, [r2]
finish
	ldr	r4, =8000000
dloop	
	subs r4,r4,#1
	cmp  r4,#0	
	bne	dloop
	mov r11, #0x000f0000
	str r11, [r1]
	pop{r0-r7,r9-r12,pc}
	bx lr

	END