TITLE Program 06B   (Program06B.asm)

; Author: Philip Chang
; CS 271 / Program 06B          Date: March 19, 2017
; Description: This is a combinations calculator, it generates a number
; of elements in a set with n 3 to 12, and number of elements to choose from the
; n, or r from 1 to n, then calculates the total number of combinations. When
; finished calculating, it asks the user how many ways can you choose?.
; It validates the response and tells them if they are right or wrong, it also
; asks if they want another problem, if it does it starts all over again, if it
; doesn't, it displays a farewell message.All parameters will be passed on system
; stack while manitaining activation records.
; EC** problems will be numbered, and when user quits, it will report number right
; and number wrong.

INCLUDE Irvine32.inc

;-------------------------------------
;display Macro
;
;macro that is used to display strings
;using edx
;--------------------------------------
display MACRO string
	push		edx
	mov 		edx, OFFSET string
	call		WriteString
	pop			edx
ENDM
; (insert constant definitions here)
N_MIN       EQU <3>; min number of n
N_MAX       EQU <12>; max number of n
R_MIN       EQU <1>; min num of r

.data
;intro data
intro1      BYTE        "Welcome to the Combinations Calculator",0
intro2      BYTE        "       Implemented by Philip Chang",0
intro3      BYTE        "I'll give you a combinations problem. You enter the answer,",0
intro4      BYTE        "and I'll let you know if you're right.",0
;problem
prob1       BYTE        "Problem: ",0
prob2       BYTE        "Number of elements in the set:     ",0
prob3       BYTE        "Number of elements to chose from the set: ",0
prob4       BYTE        "How many ways can you choose? ",0
another     BYTE        "Another problem? (y/n): ",0
yes         BYTE        "y",0
no          BYTE        "n",0
;answer
answer1     BYTE        "There are ",0
answer2     BYTE        " combinations of ",0
answer3     BYTE        " items from the set of ",0
answer4		BYTE		".",0
;wrong or right or invalid
wrong       BYTE        "You need more practice.",0
right       BYTE        "You are correct!",0
invalid     BYTE        "Invalid response.",0
;farewell
byebye      BYTE        "OK ... goodbye.",0
; (insert variable definitions here)
temporary	BYTE		42 DUP(?); string to read from user input
answer      DWORD       ?;user answer to # of combinations after validation
n		    DWORD       ?;n - total set size
r			DWORD       ?;r - subset of n to chose from
result      DWORD       ?;total number of combinations

.code
; (insert additional procedures here)
;----------------------------------
;introduction
;
;displays introduction to the user
;using the macro
;----------------------------------
introduction PROC

    display intro1
    call    CrlF
    display intro2
    call    CrlF
    call    CrlF
    display intro3
    call    CrlF
	display intro4
    call    CrlF
    call    CrlF
    ret
introduction ENDP
;----------------------------------
;showProblem
;
;generates the random numbers and
;displays the problem
;using pushad all general registers
;----------------------------------
showProblem PROC
    pushad
	mov     ebp, esp
    mov     eax, N_MAX
    sub     eax, N_MIN
    inc     eax
    call    RandomRange
    add     eax, N_MIN
    mov     ebx, [ebp+40];nset
    mov     [ebx], eax;nset = eax
    mov     eax, [ebx]
    sub     eax, R_MIN
    inc     eax
    call    RandomRange
    add     eax, R_MIN
    mov     ebx, [ebp+36] ;rset
    mov     [ebx], eax ; rset = eax
    display prob1
    call    CrlF
    display prob2
    mov     ebx, [ebp+40];n
    mov     eax, [ebx];n
    call    WriteDec
    call    CrlF
    display prob3
    mov     ebx, [ebp+36];r
    mov     eax, [ebx]; r
    call    WriteDec
    call    CrlF
    popad
    ret     8
showProblem	ENDP

;----------------------------------
;getData
;
;promopt the user and gets the user's
;answer.
;using pushad - all general purpose registers
; 36 = answer
;----------------------------------
getData PROC
	pushad
	mov		ebp, esp
begin:
	mov		eax, 0 ; make sure eax has nothing in it
	mov		ebx, [ebp+36] ; answer
	mov		[ebx], eax
	display	prob4
	mov		edx, OFFSET temporary ;temporary string
	mov		ecx, (SIZEOF temporary) - 1 ;buffer size - 1
	call	ReadString
	mov		ecx, eax ;eax holding the size of string
	mov		esi, OFFSET temporary ;moving string to esi to check chars
	jmp		validate
validate:
	mov		ebx, [ebp+36];answer in ebx
	mov		eax, [ebx]
	mov		ebx, 10
	mul		ebx ; ebx*10
	mov		ebx, [ebp+36]
	mov		[ebx], eax
	mov		al, [esi]
	cmp		al, 57; 57 = 9
	jg		invalidate
	cmp		al, 48; 48 = 0
	jl		invalidate
	inc		esi;moves to next char
	sub		al, 48;convert back to num
	mov		ebx, [ebp+36]
	add		[ebx], al;add that char into the answer
	loop	validate
	jmp		good2go

invalidate:
	call	CrlF
	display	invalid
	call	CrLf
	jmp		begin

good2go:
	popad
	ret		4

getData ENDP
;----------------------------------
;factorial
;
;calculates the factorial
;using eax, ebx, ebp,esp
; from the textbook
;----------------------------------
factorial PROC
	push	ebp
	mov		ebp, esp
	mov		eax, [ebp+8]
	cmp		eax, 0
	ja		L1
	mov		eax, 1
	jmp		L2
L1:
	dec		eax
	push	eax
	call	factorial
ReturnFact:
	mov		ebx, [ebp+8]
	mul		ebx
L2:
	pop		ebp
	ret		4
factorial ENDP
;----------------------------------
;combinations
;
;calculates the # of combos
;using eax, ebx, edx, ebp, esp, edi
;----------------------------------
combinations PROC
	push	eax
	push	ebx
	push	ecx
	push	ebx
	push	ebp
	push	edi
	mov		ebp, esp
	
	push	[ebp+36]
	call	factorial			;n factorial
	mov		ecx, eax; moves eax to ecx

	push	[ebp+32]
	call	factorial			;r factorial
	mov		edi, eax; moves eax to edi

	mov		eax, [ebp+36]
	mov		ebx, [ebp+32]
	sub		eax, ebx
	push	eax
	call	factorial			;n-r factorial
	mov		ebx, edi
	mul		ebx					;r!(n-r)!
	mov		edi, eax; moves r!(n-r)! to ebx
	mov		edx, 0
	mov		eax, ecx;moves ecx to eax or n!
	mov		ebx, edi; moves edi to ebx
	div		ebx
	mov		edx, [ebp + 28]
	mov		[edx], eax

	pop		eax
	pop		ebx
	pop		ecx
	pop		ebx
	pop		ebp
	pop		edi
	ret		12
combinations ENDP
;----------------------------------
;showResults
;
;display answer, result, and brief 
;statment of studendents performance
;using eax, ebx, ebp,esp
;
;----------------------------------
showResults	PROC
	pushad
	mov		ebp, esp
	call	CrlF
	display answer1
	mov		eax, [ebp+36]
	call	WriteDec
	display	answer2
	mov		eax, [ebp+40]
	call	WriteDec
	display	answer3
	mov		eax, [ebp+44]
	call	WriteDec
	display	answer4
	call	CrlF
	mov		eax, [ebp+48]
	mov		ebx, [ebp+36]
	cmp		eax, ebx
	ja		needpractice
	jb		needpractice
	display right
	call	CrlF
	call	CrlF
	jmp		endResults
needpractice:
	display	wrong
	call	CrlF
	call	CrlF
	jmp		endResults
endResults:
	popad
	ret		16

showResults ENDP
;main

main PROC
    call    Randomize

    call    introduction

another1:
	call	CrlF
	push	OFFSET n;12
	push	OFFSET r;8
	call	showProblem

	push	OFFSET answer;8
	call	getData


	push	n;16 = 32
	push	r;12 = 28
	push	OFFSET result;8 = 24
	call	combinations


	push	answer;20 = 48
	push	n;16 = 44
	push	r;12 = 40
	push	result;8 = 36
	call	showResults

another2:
	display	another
	mov		edx, OFFSET temporary
	mov		ecx, (SIZEOF temporary) - 1
	call	ReadString
	mov		esi, OFFSET temporary
	mov		edi, OFFSET yes
	cmpsb
	je		another1
	mov		esi, OFFSET temporary
	mov		edi, OFFSET no
	cmpsb
	je		farewell
invalid2:
	call	CrlF
	display invalid
	jmp		another2
	

farewell:
	call	CrlF
	display	byebye
	call	CrlF

; (insert executable instructions here)

    exit    ; exit to operating system
main ENDP


END main
