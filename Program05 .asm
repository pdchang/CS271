TITLE Program 05     (Program05.asm)

; Author: Philip Chang			changp@oregonstate.edu
; CS 271 / Program 05           Date: March 5, 2017
; Description: Sorting Random Integers program. The program will display title
; programmer's name and brief instructions. It will validate the user input,
; use min, max, lo, and hi constants. The program will be constructed into procedures
; with main, introduction, get data, fill array, sort list, display median, and
; display list. Parameters will all be passed by value or reference on system stack.
; procedures other than main will not reference .data segment variables by name.

INCLUDE Irvine32.inc

; (insert constant definitions here)
MIN		EQU <10> ;min
MAX		EQU <200> ;max
LO		EQU	<100> ;lower number
HI		EQU	<999>; highest number
ROW_MAX EQU <10> ; number of integers in a row

.data
;intro data
intro1		BYTE		"Sorting Random Integers		Programmed by Philip Chang",0
intro2		BYTE		"This program generates random numbers in the range [100 .. 999],",0
intro3		BYTE		"displays the original list, sorts the list, and calculates the",0
intro4		BYTE		"median value. Finally, it displays the list sorted in descending order.",0
;get user data and validate
user1		BYTE		"How many numbers should be generated? [10 .. 200] :",0
error		BYTE		"Invalid input",0
;display stuff
unsorted	BYTE		"The unsorted random numbers are: ",0
median		BYTE		"The median is ",0
sorted		BYTE		"The sorted list: ",0
spaces		BYTE		"      ",0
; (insert variable definitions here)
array		DWORD		MAX DUP(?)
input		DWORD		?
iter		DWORD		?
rows		DWORD		0;counter

.code
; (insert executable instructions here)
;----------------------------------
;introduction
;
;displays introduction to the user
;using ebp and edx
;----------------------------------
introduction PROC

	push	ebp
	mov		ebp, esp
	mov		edx, [ebp+20] ;offset of intro1
	call	WriteString
	call	CrlF
	mov		edx, [ebp+16] ;offset of intro2
	call	WriteString
	call	CrlF
	mov		edx, [ebp+12] ;offset of intro3
	call	WriteString
	call	CrlF
	mov		edx, [ebp+8] ;offset of intro4
	call	WriteString
	call	CrlF
	pop		ebp
	ret		16

introduction ENDP
;----------------------------------
;getData
;
;gets user input and validates it
;using eax, edx, ebp
;----------------------------------
getData	PROC
	call	CrlF
	push	ebp
	mov		ebp, esp
begin:
	mov		edx, [ebp+16] ;offset of user1
	call	WriteString
	call	ReadInt;get input from the user
	cmp		eax, MIN;validate
	jl		errorer
	cmp		eax, MAX ; validate
	jg		errorer
	mov		ebx, [ebp+8] ;offset of input
	mov		[ebx], eax ;sets valid input
	jmp		ender
errorer:
	mov		edx, [ebp+12] ;offset of error
	call	WriteString
	call	CrlF
	jmp		begin
ender:
	pop		ebp
	ret		12
getData		ENDP
;----------------------------------
;fillArray
;
;fills the array using userinput
;and irvine's RandomRange
;using eax, ebp, ecx, esi
;----------------------------------
fillArray PROC
	push	ebp
	mov		ebp, esp
	mov		esi, [ebp+8];offset of array
	mov		ecx, [ebp+12];sets input to loop counter

filler:
	mov		eax, HI	; gets range for randomrange
	sub		eax, LO
	inc		eax
	call	RandomRange
	add		eax, LO
	mov		[esi], eax ; sets the random integer to location pointed to by esi
	add		esi, 4 ; moves to next part of array
	loop	filler ; loops
	pop		ebp
	ret		8
fillArray ENDP
;----------------------------------
;sortList
;
;sorts the array using bubble sort
;using eax, ebp, ecx, esi
;----------------------------------
sortList PROC
	push	ebp
	mov		ebp, esp
	mov		eax, [ebp+12] ; moves user input to eax
	dec		eax ; decreases eax
	mov		iter, eax ; sets iter to value in eax
	mov		ecx, iter ; moves iter to ecx, the loop counter
	mov		esi, [ebp+8] ; offset of array
for1:
	push	ecx ; push ecx on to stack
	mov		esi, [ebp+8] ; sets offset of array for the inner loop
for2:
	mov		eax,[esi] ; moves the value at esi to eax
	cmp		eax, [esi+4] ; compares the value to the next in array
	jg		nextIter; if esi > esi+4 then moves to next part of array
	push	[esi] ; else it pushes esi and esi+4 onto stack
	push	[esi+4]
	call	exchangeElements ;call exchange elemtns proc
	pop		[esi+4] ; pops the value of stack at current pointer location
	pop		[esi]
nextIter:
	add		esi, 4 ;adds 4 to esi to move pointer to next values
	loop	for2 ;loop inner
	pop		ecx ; pop ecx off for inner loop
	loop	for1 ; loops outer
	pop		ebp
	ret		8
sortList ENDP
;----------------------------------
;exchangeElements
;
;swaps numbers in the array
;using eax, ebx, ebp
;----------------------------------
exchangeElements PROC
	push	ebp
	mov		ebp, esp
	mov		eax, [ebp+8] ; mov first value to eax
	mov		ebx, [ebp+12] ; moves 2nd value to ebx
	mov		[ebp+12], eax ; swaps them around
	mov		[ebp+8], ebx
	pop		ebp
	ret		
exchangeElements ENDP
;----------------------------------
;displayMedian
;
;displays the median
;using eax, ebx, ebp, edx, ecx, esi
;----------------------------------
displayMedian	PROC
	push	ebp
	mov		ebp, esp
	mov		edx, [esp+16] ;offset of median
	call	CrlF
	call	WriteString
	mov 	esi,[ebp+8] ; offset of array
	mov		eax,[ebp+12] ; moves input to eax
	mov 	ebx, 2 ; divide the input value by 2 to see if it is even or odd
	mov		edx, 0
	div		ebx
	cmp		edx, 0
	je		evens
	jmp		odds
evens:
	mov		ebx, 4 ;finds the middle 2 numbers, then adds them and divides them by 2
	mul		ebx
	add		esi, eax 
	mov		eax, [esi]
	mov		ebx, eax
	sub		esi, 4
	mov		eax, [esi]
	add		eax, ebx
	mov		edx, 0
	mov		ebx, 2
	div		ebx
	call	WriteDec
	call	Crlf
	jmp		calculated
odds:
	mov		ebx, 4 ;finds the middle and sets eax to that value and prints it
	mul		ebx
	add		esi, eax
	mov		eax, [esi]
	call	WriteDec
	call	CrlF
	jmp		calculated
calculated:
	pop		ebp
	ret		8
displayMedian	ENDP
;----------------------------------
;displayList
;
;displays the contents of the array
;using edx, eax, ebx, ecx, esi
;----------------------------------
displayList	PROC
	push	ebp
	mov		ebp, esp
	mov		edx, [ebp+20];displays offset of sorted or unsorted depending which
	call	CrlF
	call	WriteString
	call	CrlF
	mov		esi, [ebp+8] ; offset of array
	mov		ecx, [ebp+16] ;user input for loop
	mov		ebx, 0;counter
	jmp		display
check_lines:
	cmp		ebx, ROW_MAX ; checkes to see if it needs a new line
	je		new_line
	jmp		loopy
display:
	inc		ebx ;increases counter
	mov		eax, [esi] ; prints first value esi points to
	call	WriteDec
	mov		edx,[ebp+12] ; spaces
	call	WriteString
	add		esi, 4 ; adds 4 to esi to display next value pointed to b y esi
	jmp		check_lines
new_line:
	call	CrlF ;prints new line, and sets ebx/counter
	mov		ebx, 0
	jmp		loopy
loopy:
	loop	display
	call	CrlF
	pop		ebp
	ret		16
displayList ENDP

main PROC
	call	Randomize
	
	push	OFFSET intro1;20
	push	OFFSET intro2;16
	push	OFFSET intro3;12
	push	OFFSET intro4;8
	call	introduction
	
	push	OFFSET user1;16
	push	OFFSET error;12
	push	OFFSET input;8
	call	getData
	
	push	input;12
	push	OFFSET array;8
	call	fillArray;
	
	push	OFFSET unsorted;20
	push	input;16
	push	OFFSET spaces;12
	push	OFFSET array;8
	call	displayList
	
	push	input;12
	push	OFFSET array;8
	call	sortList

	push 	OFFSET median;16
	push	input;12
	push	OFFSET array;8
	call	displayMedian
	
	push	OFFSET sorted;20
	push	input;16
	push	OFFSET spaces;12
	push	OFFSET array;8
	call	displayList
	


	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
