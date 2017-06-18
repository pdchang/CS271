TITLE Program 03     (Program03.asm)

; Author: Philip Chang
; CS 271 / Program 03		Date:February 12, 2017
; Description:Displays the program title and my name, gets the user's name
; greets teh user, display instructions to the users, repeatedly prompt user to enter
; a number, then validates the user input to be between -100 and -1 inclusively.
; The user numbers counted and accumulated until non-negative number is entered with
; the non negative number being discarded. Finally it calculates the rounded integer
; average of the negative numbers, and displays the number of negative integers, the
; sum, the average rounded to the nearest integer, and a party message with the
; user's name. 
; Extra Credit 1 - Number of lines during user input
; Extra Credit 2 - Calculate and display average floating point number, rounded to 
;					nearest .001.


INCLUDE Irvine32.inc

; (insert constant definitions here)

UPPER_LIMIT EQU <-1>
LOWER_LIMIT EQU <-100>

.data
intro		BYTE		"Welcome to the Integer Accumulator by Philip Chang",0
p1			BYTE		"What is your name? ",0
p2			BYTE		"Hello, ",0
p3			BYTE		"Please enter numbers in [-100, -1]", 0
p4			BYTE		"Enter a non-negative number when you are finished to see the results.",0
p5			BYTE		"You didn't enter any valid numbers!!!!",0
a1			BYTE		"Enter Number: ",0
a21			BYTE		"You entered ",0
a22			BYTE		" valid numbers.",0
a3			BYTE		"The sum of your valid numbers is ",0 
a4			BYTE		"The rounded average is ",0
bye			BYTE		"Thank you for playing Integer Accumulator! It's been a pleasure to meet you, ",0
point		BYTE		".",0
thousand	DWORD		1000
valid		DWORD		0;valid number accumulator
zerop		DWORD		"0",0
hearts		DWORD		0;# of hearts accumulator
;**EC stuff
e1			BYTE		"**EC1: I will number the lines during user input",0
e2			BYTE		"**EC2: The average floating point number, rounded to the nearest .001 is ",0
lines		DWORD		1;line number accumulator
e3			BYTE		"**EC3: I don't know anything amazing but I have something cute",0
h1			BYTE		"       .....           .....",0
h2			BYTE		"   ,ad8PPPP88b,     ,d88PPPP8ba,",0
h3			BYTE		"  d8P'      'Y8b, ,d8P'      'Y8b",0
h4			BYTE		" dP'            8a8            `YdP",0
h5			BYTE		" 8(              @              )8P",0
h6			BYTE		" I8    Happy Valentine's Day   8IP",0
h7			BYTE		"  Yb,       Assembly <3      ,dP",0
h8			BYTE		"    @,                     ,a8",0
h9			BYTE		"      @,                 ,a8",0
h10			BYTE		"       Yba,             ,adP",0
h11			BYTE		"         `Y8a         a8P",0
h12			BYTE		"          `88,     ,88'",0
h13			BYTE		"            '8b   d8'",0
h14			BYTE		"             '8b d8'",0
h15			BYTE		"              '888'",0
h16			BYTE		"                '' ",0



; (insert variable definitions here)

namer		BYTE		42	DUP(?);user name
cnum		DWORD		?;current number 
sum			DWORD		?;sum
avg			DWORD		?;rounded average
rem			DWORD		?;remainder after division
floaty		REAL4		?;float rounded to nearest .001
frontf		DWORD		?;front of decimal point
changes		DWORD		?;rounded average

.code
main PROC

;introduction
	mov		eax, white
	call	SetTextColor
	mov		edx, OFFSET intro
	call	WriteString
	call	CrlF
	mov		edx, OFFSET e1
	call	WriteString
	call	CrlF
;get user name and greet
	mov		edx, OFFSET p1
	call	WriteString
	mov		edx, OFFSET namer
	mov		ecx, SIZEOF namer
	call	ReadString
	call	CrlF
	mov		edx, OFFSET p2
	call	WriteString
	mov		edx, OFFSET namer
	call	WriteString
	call	CrlF
;display instructions for user
	mov		edx, OFFSET p3
	call	WriteString
	call	CrlF
	mov		edx, OFFSET p4
	call	WriteString
	call	CrlF
	jmp		enternum
;Repeatedly prompt user to enter a number
enternum:
	mov		eax, lines
	call	WriteDec
	inc		lines
	mov		edx, OFFSET point
	call	WriteString
	mov		edx, OFFSet a1
	call	WriteString
	call	ReadInt
	mov		cnum, eax
	jmp		validate
;validate number and increase valid number count if valid
validate:
	cmp		eax, UPPER_LIMIT
	jg		calculate
	cmp		eax, LOWER_LIMIT
	jl		calculate
	inc		valid
	jmp		summer
;adds to sum 
summer:
	add		eax, sum
	mov		sum, eax
	jmp		enternum

;displays no valid numbers message and jumps to farewell
novalid:
	call	CrlF
	mov		edx, OFFSET p5
	call	WriteString
	call	CrlF
	jmp		amazing
;calculates the average and checks for inputs
calculate:
	cmp		valid, 0
	je		novalid
	mov		edx, 0
	mov		eax, sum
	CDQ
	mov		ebx, valid
	idiv	ebx
	mov		avg, eax
	mov		changes, eax
	mov		rem, edx
	neg		rem
	jmp		rounder
;checks if needs rounding
rounder:
	mov		eax, rem
	mov		ebx, 2
	imul	ebx
	cmp		eax, valid
	jle		display
	mov		eax, avg
	add		eax,-1
	mov		avg, eax
	jmp		display

;display the results
display:
	call	CrlF
	mov		edx, OFFSET a21
	call	WriteString
	mov		eax, valid
	call	WriteDec
	mov		edx, OFFSET a22
	call	WriteString
	call	CrlF
	mov		edx, OFFSET a3
	call	WriteString
	mov		eax, sum
	call	WriteInt
	call	CrlF
	mov		edx, OFFSET a4
	call	WriteString
	mov		eax, avg
	call	WriteInt
	call	CrlF
	jmp		float_point
;**EC Floating Point calculate and checks position of floating point
float_point:
	fild	rem
	fmul	thousand
	fdiv	valid
	fistp	floaty
	mov		edx, OFFSET e2
	call	WriteString
	mov		eax, changes
	call	WriteInt
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
	jmp		zeroness
;**EC print after zeros after decimal point
zeroness:
	mov		eax, floaty
	call	WriteDec
	call	CrlF
	jmp		amazing
;**EC something amazing
amazing:
	cmp		hearts, 3
	jge		farewell
	call	CrlF
	call	CrlF
	mov		edx, OFFSET e3
	call	WriteString
	call	CrlF
	mov		eax, red
	call	SetTextColor
	mov		edx,OFFSET  h1
	call	WriteString
	call	CrlF
	mov		edx,OFFSET  h2
	call	WriteString
	call	CrlF
	mov		edx,OFFSET  h3
	call	WriteString
	call	CrlF
	mov		edx,OFFSET  h4
	call	WriteString
	call	CrlF
	mov		edx,OFFSET  h5
	call	WriteString
	call	CrlF
	mov		edx,OFFSET  h6
	call	WriteString
	call	CrlF
	mov		edx,OFFSET  h7
	call	WriteString
	call	CrlF
	mov		edx,OFFSET  h8
	call	WriteString
	call	CrlF
	mov		edx,OFFSET  h9
	call	WriteString
	call	CrlF
	mov		edx,OFFSET  h10
	call	WriteString
	call	CrlF
	mov		edx,OFFSET  h11
	call	WriteString
	call	CrlF
	mov		edx,OFFSET  h12
	call	WriteString
	call	CrlF
	mov		edx,OFFSET  h13
	call	WriteString
	call	CrlF
	mov		edx,OFFSET  h14
	call	WriteString
	call	CrlF
	mov		edx,OFFSET  h15
	call	WriteString
	call	CrlF
	mov		edx,OFFSET  h16
	call	WriteString
	call	CrlF
	inc		hearts
	
;say bye to the user
farewell:
	mov		eax, white
	call	SetTextColor
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
