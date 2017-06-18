TITLE Program 02     (Program02.asm)

; Author:Philip Chang
; CS 271 / Program 02		Date:January 29, 2017
; Description:Displays name and program title, asks for user's name
; says hello to user, asks for a range to display fibonacci's sequence
; gets and validates range, calculates and displays the numbers to nth term
; says goodbye to user's name, and termiantes the program

INCLUDE Irvine32.inc

UPPER_LIMIT EQU <46>
LOWER_LIMIT EQU <1>
; (insert constant definitions here)

.data
intro1		BYTE	"Fibonacci Numbers",0
intro2		BYTE	"Programmed by Philip Chang",0
askname		BYTE	"What's your name? ",0
hello		BYTE	"Hello, ",0
tell1		BYTE	"Enter the number of Fibonacci terms to be displayed",0
tell2		BYTE	"Give the number as an integer in the range [1 .. 46]",0
ask			BYTE	"How many Fibonacci terms do you want? ",0
error		BYTE	"Out of range. Enter a number in [1 .. 46]",0
certify		BYTE	"Results certified by Philip Chang",0
bye			BYTE	"Goodbye, ",0
EC1			BYTE	"**EC:Doing something incredible",0
EC2			BYTE	"******IT'S A RAINBOW using a post test loop*****",0
spacer		BYTE	"      ",0
rainbow		BYTE	"oooooooooooooooo",0
; (insert variable definitions here)
.data?
namer		BYTE	42	DUP(?)
range		DWORD	?
fib1		DWORD	?
fib2		DWORD	?
fib3		DWORD	?
placer		DWORD	?
eCount		DWORD	?
.code
main PROC

; (insert executable instructions here)
	mov		eax, eCount
	jmp		introduction
;Introduction
introduction:
	mov		edx, OFFSET intro1
	call	WriteString
	call	CrLF
	mov		edx, OFFSET intro2
	call	WriteString
	call	CrlF
	call	CrlF
	jmp		userInstructions
;User Introduction
userInstructions:
	 mov	edx, OFFSET askname
	 call	WriteString
	 mov	edx, OFFSET namer
	 mov	ecx, SIZEOF namer
	 call	ReadString
	 call	CrlF
	 mov	edx, OFFSET hello
	 call	WriteString
	 mov	edx, OFFSET namer
	 call	WriteString
	 call	CrlF
;userInstructions
getUserData:
	mov		edx, OFFSET tell1
	call	WriteString
	call	CrlF
	mov		edx, OFFSET tell2
	call	WriteString
	call	CrlF
	mov		edx, OFFSET ask
	call	WriteString
	call	ReadInt
	mov		range, eax
	jmp		checker
;checks if range is good
checker:
	mov		eax, range
	cmp		range, LOWER_LIMIT
	jl		errorizer
	cmp		range, UPPER_LIMIT
	jg		errorizer
	jmp		initializer
;displays error message and jumps back to ask for user input
errorizer:
	mov		edx, OFFSET error
	call	WriteString
	call	CrlF
	jmp		getUserData
;this section of code calculates and displays
initializer:
	mov		ecx, range
	mov		fib1, 1
	mov		fib2, 1
	jmp		first
;print either the first number or the first num and 2nd number
first:
	mov		ecx, range
	mov		eax, fib1
	call	WriteDec
	inc		placer
	dec		ecx
	mov		edx, OFFSET spacer
	call	WriteString
	cmp		range, 1
	je		special
	mov		eax, fib2
	call	WriteDec
	inc		placer
	mov		edx, OFFSET spacer
	call	WriteString
	dec		ecx
	cmp		range, 2
	je		special
	mov		eax, 2
	cmp		range, 2
	jg		displayFibs

displayFibs:
	mov		eax, fib1
	add		eax, fib2
	mov		fib3, eax
	call	WriteDec
	mov		edx, OFFSET spacer
	call	WriteString
	inc		placer
	mov		eax, placer
	cmp		placer, 5
	je		row
	jne		continue

row:
	call	CrlF
	mov		placer, 0
	jmp		continue

continue:
	mov		eax, fib2
	mov		fib1, eax
	mov		eax, fib3
	mov		fib2, eax
	loop	displayFibs
;**EC - Something special
special:
	call	CrlF
	mov		edx, OFFSET EC1
	call	WriteString
	call	CrlF
	mov		edx, OFFSET EC2
	call	WriteString
	call	CrlF
	jmp		loops1
loops1:
	mov		eax, red
	call	SetTextColor
	mov		edx, OFFSET rainbow
	call	WriteString
	mov		eax, yellow
	call	SetTextColor
	mov		edx, OFFSET rainbow
	call	WriteString
	mov		eax, green
	call	SetTextColor
	mov		edx, OFFSET rainbow
	call	WriteString
	mov		eax, blue
	call	SetTextColor
	mov		edx, OFFSET rainbow
	call	WriteString
	mov		eax, 5
	call	SetTextColor
	mov		edx, OFFSET rainbow
	call	WriteString
	call	CrlF
	inc		eCount
	cmp		eCount, 16
	jg		farewell
	jle		loops1;
farewell: 
	mov		eax, white
	call	SetTextColor
	call	CrlF
	mov		edx, OFFSET certify
	call	WriteString
	call	CrlF
	mov		edx, OFFSET bye
	call	WriteString
	mov		edx, OFFSET namer
	call	WriteString
	call	CrlF

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
