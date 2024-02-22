; Keona Abad
; CS 271 Computer Architecture and Assembly Language - Program 3 
; Feb. 21, 2024

; Description: This program can calculate and display all composite numbers ranging from 1 - 400. First, the user is instructed to enter the number of composites to be displayed, and is prompted to enter an integer in the range [1 .. 400]. The user
;enters a number, n, and the program verifies that 1 ≤ n ≤ 400. If n is out of range, the user is re-prompted until s/he enters a value in the specified range. The program then calculates and displays all of the composite numbers up 
;to and including the nth composite.



INCLUDE Irvine32.inc

.DATA
   
    programmerName BYTE "Program by Keona Abad", 0 ; String containing the programmer's name to be displayed at the start of the program.
    programTitle BYTE "Program 3 - Composite Numbers", 0dh, 0ah, 0   ; String containing the title of the program to be displayed at the start of the program.
    programDescription BYTE "This program can calculate and display all composite numbers ranging from 1 - 400.", 0dh, 0ah, 0 ; String containing the description of the program's functionality.
    maxComposites EQU 400  ; Constant representing the maximum number of composite numbers the program can handle.
    promptMsg BYTE "Enter the number of composites to display (1-400): ", 0  ; Prompt message asking the user to enter the number of composites to display..
    errorMsg BYTE "Invalid input. Please enter a number between 1 and 400.", 0     ; Error message displayed when the user enters a value outside the valid range
    farewellMsg BYTE "Results certified by Keona Abad. Goodbye.", 0     ; Farewell message displayed before the program exits, confirming the results are verified.
    numComposites DWORD ? ; Variable to store the number of composite numbers the user wishes to display.
    compositeCounter DWORD 0     ; Counter for the number of composite numbers found (not used in the provided snippet).
    retryMsg BYTE "Would you like to go again (Yes=1/No=0): ", 0     ; Prompt message asking if the user would like to run the program again.
    userChoice DWORD ?     ; Variable to store the user's choice when asked if they would like to run the program again.
    spaceStr BYTE "   ", 0     ; String of three spaces used to separate the composite numbers when displayed.


.CODE
; Procedure to display the introduction with the programmer's name
Introduction PROC
    ; Print the program title
    mov edx, OFFSET programTitle
    call WriteString
    call Crlf  ; New line after the title

    ; Print the programmer's name
    mov edx, OFFSET programmerName
    call WriteString
    call Crlf  ; New line after your name

    ; Print the program description
    mov edx, OFFSET programDescription
    call WriteString
    call Crlf  ; New line after the description

    ; Print the prompt message
    mov edx, OFFSET promptMsg
    call WriteString
    call Crlf  ; New line before user input prompt
    ret


Introduction ENDP
; Procedure to get user data
GetUserData PROC
    call ReadInt
    mov numComposites, eax
    ret
GetUserData ENDP



; Procedure to validate user input
Validate PROC
    cmp numComposites, 1
    jl InvalidInput         ; If input is less than 1, jump to InvalidInput
    cmp numComposites, maxComposites
    jg InvalidInput         ; If input is greater than maxComposites, jump to InvalidInput
    ret                     ; Valid input, return from procedure

InvalidInput:
    mov edx, OFFSET errorMsg  ; Load the address of errorMsg into EDX
    call WriteString          ; Display the error message
    call Crlf                 ; New line for readability
    call GetUserData          ; Call GetUserData to get a new input from the user
    call Validate             ; Recursively call Validate to check the new input
    ret
Validate ENDP




; Procedure to show composites
ShowComposites PROC
    mov ecx, numComposites   ; Get the number of composites to display from the user input
    mov ebx, 4               ; Start checking from the first composite number
    mov esi, 0               ; Counter for composites per line

    ; Loop to find and print composites
FindComposites:
    ; If we have printed the requested number of composites, we are done
    cmp ecx, 0
    je DonePrinting

    ; Check if the current number is a composite
    call IsComposite
    cmp eax, 1
    je PrintComposite

    ; If not composite, increment the number and continue searching
    inc ebx
    jmp FindComposites

    ; Procedure to print a composite number
PrintComposite:
    ; Increase the count of composites per line
    inc esi

    ; Print the composite number
    mov eax, ebx
    call WriteDec
    mov edx, OFFSET spaceStr
    call WriteString

    ; Check if we have printed 10 composites on this line
    cmp esi, 10
    jne ContinuePrinting

    ; If we have printed 10, insert a new line and reset the counter
    call Crlf
    mov esi, 0

ContinuePrinting:
    ; Decrement the total number of composites left to print
    dec ecx
    ; Increment the number to check next
    inc ebx
    jmp FindComposites

DonePrinting:
    ; After printing all composites, check if we need to print a final newline
    cmp esi, 0
    je SkipFinalNewLine
    call Crlf

SkipFinalNewLine:
    ret
ShowComposites ENDP




WriteSpaces PROC
    mov edx, OFFSET spaceStr
    call WriteString
    ret
WriteSpaces ENDP



; Procedure to check if a number is composite
IsComposite PROC
    mov eax, ebx               ; Move the number to check into eax
    cmp eax, 2
    jle NotComposite           ; Exclude numbers less than or equal to 2

    mov esi, 2                 ; Start checking from 2

CheckDivisor:
    cmp esi, eax
    jge NotComposite           ; If esi >= eax, then not a composite
    mov edx, 0
    div esi                    ; Divide eax by esi
    cmp edx, 0                 ; Check remainder
    je CompositeFound          ; If remainder is zero, it's a composite number
    inc esi                    ; Increment the divisor
    mov eax, ebx               ; Reset eax to the original number
    jmp CheckDivisor           ; Continue checking

CompositeFound:
    mov eax, 1                 ; Return 1 if composite
    ret

NotComposite:
    xor eax, eax               ; Return 0 if not composite
    ret
IsComposite ENDP



; Procedure to calculate the square root of a number
SquareRoot PROC
    ; Implement the square root calculation here
    ; Return the square root in esi
    ret
SquareRoot ENDP



; Procedure for 'PromptAgain'
PromptAgain PROC
    mov edx, OFFSET retryMsg   ; Load the address of the retry message
    call WriteString           ; Display the retry message
    call ReadInt               ; Read the user's choice
    mov userChoice, eax        ; Store the user's choice

    cmp userChoice, 1
    je Restart                 ; If user chooses to restart, jump to Restart label
    ret                        ; Otherwise, return and proceed to Farewell

Restart:
    call Introduction          ; Re-run the introduction
    call GetUserData           ; Re-run get user data
    call Validate              ; Re-run validate user data
    call ShowComposites        ; Re-run show composites
    jmp PromptAgain            ; Ask again to restart or not

PromptAgain ENDP



; Procedure for farewell message
Farewell PROC
    mov edx, OFFSET farewellMsg
    call WriteString
    call Crlf
    ret
Farewell ENDP



; Main procedure
main PROC
    call Introduction
    call GetUserData
    call Validate
    call ShowComposites
    call PromptAgain
    call Farewell
    exit
main ENDP

END main
