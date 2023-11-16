	;; R0: base address for data
	;; R1: base adderss for coeff
	;; R2: data ring buffer head pointer
	;; R3: loop counter
	;; R4: TMP1
	;; R5: accumulator
	;; R6: memory address
	;; R7: TMP2
	;;
	;; ===========================================================================	
	;; Initializations
	;; ===========================================================================	
	;; Set base address 128 for data in R0
	LDI R0 4
	SHL R0 R0
	SHL R0 R0
	SHL R0 R0
	SHL R0 R0
	SHL R0 R0
	;; Set base address data+5 for coeff in R1
	ADI R1 R0 5
	;;  Initialize ring buffer pointer
	CLR R2
	;; Initialize coeffs
	;; C0 = 2
	CLR R3
	LDI R7 2
	ADD R6 R1 R3
	ST R6 R7
	INC R3 R3
	;; C1 = -3
	LDI R7, 3
	CLR R4
	SUB R7 R4 R7
	ADD R6 R1 R3
	ST R6 R7
	INC R3 R3
	;; C2 = 5
	LDI R7, 5
	ADD R6 R1 R3
	ST R6 R7
	INC R3 R3
	;; C3 = -6
	LDI R7, 6
	CLR R4
	SUB R7 R4 R7
	ADD R6 R1 R3
	ST R6 R7
	INC R3 R3
	;; C4 = 7
	LDI R7, 7
	ADD R6 R1 R3
	ST R6 R7
	;; ===========================================================================
	;; FIR Loop Begin
	;; ===========================================================================
	;; Reset loop counter and accu
	CLR R3
	CLR R5
	;; Read sample from ioport 0 (R3 == 0) to R4
	IOR R4 R3
	;; Create memory address (data base + ring buffer pointer)
	ADD R6 R0 R2
	;; Store sample to memory
	ST R6 R4
	;; Decrement ring buffer pointer
	DEC R2 R2
	;; Branch to set piunter = 4 if it went negative
	BRN R2 3
	;; Branch over the LDI instruction (is there any other way to do this..?)
	CLR R7
	BRZ R7 2
	LDI R2 4
	;; -------------------------------------------------------------------------
	;; MAC Loop Begin
	;; -------------------------------------------------------------------------	
	;; Coeff address = base + loop ctr
	ADD R6 R1 R3
	LD R7 R6
	;; Data index = (counter + (pointer + 1) loop ctr
	ADD R6 R3 R2
	INC R6 R6
	LDI R4 4
	SUB R4 R4 R6
	;; Fix if negative
	BRN R4, 2
	CLR R4
	BRZ R4 3
	LDI R4 5
	SUB R6 R6 R4
	;; Add base address
	ADD R6 R0 R6
	;; Load data sample from memory
	LD R4 R6
	;; Multiply
	MUL R7 R7 R4
	;; Accumulate
	ADD R5 R5 R7
	;; Increment loop counter
	INC R3 R3
	;; Check of loop counter is 5
	LDI R7 5
	SUB R7 R3 R7
	;; Not yet, go back to MAC loop beginning
	BRN R7 -18
	;; -------------------------------------------------------------------------
	;; MAC Loop End
	;; -------------------------------------------------------------------------		
	;; Write result to output port
	CLR R7
	IOW R7 R5
	;; Branch back to FIR Loop Begin
	BRZ R7 -31
	;; ===========================================================================
	;; FIR Loop End
	;; ===========================================================================	
	;; This is never reached, but just in case...
	HAL
	
	
	
	
