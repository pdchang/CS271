TITLE Program 01     (Program01.asm)

; Author:Philip Chang
; CS 271 / Program 01		Date:January 22, 2017
; Description:Displays name and program title, gives user instructions,
; prompt user to enter two numbers, calculates sum, difference, product,
; integer quotient and remainder and a terminating message
; Extra Credit: Repeats until user quits, validates second number to be
; less than the first and calculates quotient as floating point number
; rounded to the nearest .001


INCLUDE Irvine32.inc

; (insert constant definitions here)

.data
display		BYTE		"Elementary Arithmetic by Philip Chang",0
intro		BYTE		"I will show you the sum, difference, product and integer quotient and remainder",0
instruct	BYTE		"Enter 2 numbers, and I'll show you the sum, difference,  product, quotient, and remainder.",0
instruct1	BYTE		"First Number: ",0
instruct2	BYTE		"Second Number: ",0
bye			BYTE		"Impressed? Bye",0
plus		BYTE		" + ",0
minus		BYTE		" - ",0
times		BYTE		" x ",0
divide		BYTE		" / ",0
remain		BYTE		" Remainder: ",0
equals		BYTE		" = ",0
zero		BYTE		"Second number can't be zero",0
;ExtraCredit
ex1			BYTE		"**EC: I can repeat until user chooses to quit",0
ex2			BYTE		"**EC: I can validate if the second number is less than the first",0
ex3			BYTE		"**EC: I can calculate and display the quotient  as a floating-point rounded to the nearest .001",0
extra1		BYTE		"**EC: Press 1 to continue, press 0 to quit",0
extra2		BYTE		"**EC: The second number must be less than the first!",0
extra3		BYTE		"**EC: Floating-point quotient rounded to the nearest .001 is: ",0
choose		BYTE		"**EC: Enter 1 or 0: ",0
point		BYTE		".",0
thousand	DWORD		1000;
zerop		BYTE		"0",0

; (insert variable definitions here)
.data?
num1		DWORD		?; first number
num2		DWORD		?; second number
sum			DWORD		?; first + second
diff		DWORD		?; first - second
mult		DWORD		?; first x second
quot		DWORD		?; first / second
rem			DWORD		?; remainder
;**EC 
floaty		REAL4		?; float of quotient
cont		DWORD		?; continue or not

.code
main PROC
; (insert executable instructions here)

;name and program name
	mov			edx, OFFSET display
	call		WriteString
	call		CrLF
	call		CrLF
;introduction
	mov			edx, OFFSET intro
	call		WriteString
	call		CrlF
;extra credit intros
	mov			edx, OFFSET ex1
	call		WriteString
	call		CrlF
	mov			edx, OFFSET ex2
	call		WriteString
	call		CrlF
	mov			edx, OFFSET ex3
	call		WriteString
	call		CrlF
	call		CrlF
;instructions
	mov			edx, OFFSET instruct
	call		WriteString
	call		CrlF
	call		CrlF
;gets data from user
UserInput:
	mov			edx, OFFSET instruct1
	call		WriteString
	call		ReadInt
	mov			num1, eax
	call		CrlF
	mov			edx, OFFSET instruct2
	call		WriteString
	call		ReadInt
	mov			num2, eax
	call		CrlF

;**EC:validate - compare inputs
	mov			eax, num1
	mov			ebx, num2
	cmp			eax, ebx
	jl			ValidateError
	jge			CheckZero
;**EC: if second number bigger than first, display error and jumps to UserInput
ValidateError:
	mov			edx, OFFSET extra2
	call		WriteString
	call		CrlF
	jmp			UserInput
;Check that second integer isn't zero, since you can't divide by zero.
CheckZero:
	cmp			num2, 0
	je			zerom
	jg			Calculate
;check zero message
zerom:
	mov		edx, OFFSET zero
	call	WriteString
	call	CrlF
	call	CrlF
	jmp		UserInput			
;calculation and display for sum, difference, divide and multiply
Calculate:
;sum
	mov			eax, num1
	mov			ebx, num2
	add			eax, ebx
	mov			sum, eax
;difference
	mov			eax, num1
	mov			ebx, num2
	sub			eax, ebx
	mov			diff, eax
;product
	mov			eax, num1
	mov			ebx, num2
	mul			ebx
	mov			mult, eax
;division
	mov			eax, num1
	mov			ebx, num2
	mov			edx, 0
	div			ebx
	mov			quot, eax
	mov			rem, edx
;**EC:float division
	fild		rem
	fmul		thousand
	fdiv		num2
	fistp		floaty

;Results Output
	;sum output
	mov		eax, num1
	call	WriteDec
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, num2
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, sum
	call	WriteDec
	call	CrlF
	;difference output
	mov		eax, num1
	call	WriteDec
	mov		edx, OFFSET minus
	call	WriteString
	mov		eax, num2
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, diff
	call	WriteDec
	call	CrlF
	;multipilcation output
	mov		eax, num1
	call	WriteDec
	mov		edx, OFFSET times
	call	WriteString
	mov		eax, num2
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, mult
	call	WriteDec
	call	CrlF
	;division output
	mov		eax, num1
	call	WriteDec
	mov		edx, OFFSET divide
	call	WriteString
	mov		eax, num2
	call	WriteDec
	mov		edx, OFFSET equals
	call	WriteString
	mov		eax, quot
	call	WriteDec
	mov		edx, OFFSET remain
	call	WriteString
	mov		eax, rem
	call	WriteDec
	call	CrlF
	;**EC Float Division
	mov		edx, OFFSET extra3
	call	WriteString
	mov		eax, quot
	call	WriteDec
	mov		edx, OFFSET point
	call	WriteString
	cmp		floaty,100
	jge		zeroness
	mov		edx, OFFSET zerop
	call	WriteString
	cmp		floaty, 10
	jge		zeroness
	mov		edx, OFFSET zerop
	call	WriteString
;**EC print after zeros after decimal point
zeroness:
	mov		eax, floaty
	call	WriteDec
	call	CrlF
;**EC continue until user quits
Continue:
	mov		edx, OFFSET ex1
	call	WriteString
	call	CrlF
	mov		edx, OFFSET extra1
	call	WriteString
	call	CrlF
	mov		edx, OFFSET choose
	call	WriteString
	call	ReadInt
	mov		cont, eax
	cmp		cont, 1
	je		UserInput
;bye
	mov		edx, OFFSET bye
	call	WriteString
	call	CrlF

	


	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
