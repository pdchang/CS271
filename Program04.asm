TITLE Program 04    (Program04.asm)

; Author:Philip Chang			changp@oregonstate.edu
; CS 271 / Program 04			Date:February 19, 2017
; Description:	Programmer's name and program name displayed on output,
; a counting loop between 1 to n is implemetned using loopp instruction,
; main procedure will use mostly procedure calls, each procedure specify 
; how logic of its section is implemented. The program will be modularlized
; into at least, introduction, getUserData, validate, showComposite, isComposite
; and farewell. The upper limit will be defined as a constant, there will be
; data validation.
; Extra Credit - Align output columns

INCLUDE Irvine32.inc

; (insert constant definitions here)
UPPER_LIMIT EQU <400>
LOWER_LIMIT EQU <1>
COL_MAX		EQU	<10>

.data
;intro data
intro1		BYTE		"Composite Numbers	Programmed by Philip Chang",0
intro2		BYTE		"Enter the number of composite numbers you would like to see.",0
intro3		BYTE		"I'll accept orders for up to 400 composites.",0
intro4		BYTE		"**EC: I will align the output columns",0
;user, validate, calculate data
user1		BYTE		"Enter the number of composites to display [1 .. 400]: ",0
error		BYTE		"Out of range. Try again",0
space3		BYTE		"   ",0
space4		BYTE		"    ",0
space5		BYTE		"     ",0
first_num	DWORD		3
num_num		DWORD		0;counter for numbers in line
;farewell data
byebye		BYTE		"Results certified by Philip Chang. Goodbye.",0

; (insert variable definitions here)
.data?
range		DWORD		?
divisor		DWORD		?
a_num		DWORD		?

.code
;----------------------------------
;introduction
;
;displays introduction to the user
;and what it does in edx
;----------------------------------
introduction PROC
	mov		edx, OFFSET intro1
	call	WriteString
	call	CrlF
	call	CrlF
	mov		edx, OFFSET intro2
	call	WriteString
	call	CrlF
	mov		edx, OFFSET intro3
	call	WriteString
	call	CrlF
	mov		edx, OFFSET intro4
	call	WriteString
	call	CrlF
	call	CrlF
	ret
introduction ENDP
;--------------------------------------------
;getUserData
;
;prompts user to input data in edx and 
;validates it.
;Recieves: range, eax
;Returns: validated number or error message
;--------------------------------------------
getUserData	PROC
	mov		edx, OFFSET user1
	call	WriteString
	call	ReadInt
	mov		range, eax
	call	validate
	ret
getUserData ENDP
;--------------------------------------------
;validate
;
;validates user input if is range otherwise error
;Recieves: receives range in eax
;Returns: validated number or error message
;--------------------------------------------
validate PROC
	cmp		eax, UPPER_LIMIT
	jg		wrong
	cmp		eax, LOWER_LIMIT
	jl		wrong
	jmp		right
wrong:
	mov		edx, OFFSET error
	call	WriteString	
	call	CrlF
	call	getUserData
right:
	ret
validate ENDP
;--------------------------------------------
;showComposites
;
;displays composite numbers
;Recieves: range and put its in to ecx to loop
;Returns: displays number if isComposite
;--------------------------------------------
showComposites PROC
	call	CrlF
	mov		ecx, range
	jmp		display
check_lines:
	cmp		num_num, COL_MAX
	je		new_line
	jmp		loopy
display:
	inc		num_num
	call	isComposite
	mov		eax, a_num
	cmp		eax, 10
	jl		write3
	cmp		eax, 100
	jl		write2
	mov		eax, a_num
	call	WriteDec
	mov		edx, OFFSET space3
	call	WriteString
	jmp		check_lines
	
write2:
	mov		eax, a_num
	call	WriteDec
	mov		edx, OFFSET space4
	call	WriteString
	jmp		check_lines
write3:
	mov		eax, a_num
	call	WriteDec
	mov		edx, OFFSET space5
	call	WriteString
	jmp		check_lines
new_line:
	call	CrlF
	mov		num_num, 0
	jmp		loopy
loopy:
	loop	display
showComposites ENDP


;--------------------------------------------
;isComposite
;
;checks if the number is composite or not
;Recieves: first_num in eax
;Returns: first_num if validated
;--------------------------------------------
isComposite PROC

first:
	inc		first_num
	mov		edx, 0					
	mov		eax,first_num
	mov		ebx, 2
	div		ebx
	mov		divisor, eax
	jmp		check
check:
	mov		edx, 0
	mov		eax, first_num
	mov		ebx, divisor
	div		ebx
	cmp		edx, 0
	je		send	
	dec		divisor									
	cmp		divisor, 1
	jg		check
	jmp		first
send:
	mov		eax, first_num
	mov		a_num, eax
	ret

isComposite ENDP
;--------------------------------------------
;farewell
;
;says bye to the user
;--------------------------------------------
farewell PROC
	call	CrlF
	call	CrlF
	mov		edx, OFFSET byebye
	call	WriteString
	call	CrlF
	ret
farewell ENDP
main PROC


; (insert executable instructions here)
	call	introduction
	call	getUserData
	call	showComposites
	call	farewell

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
