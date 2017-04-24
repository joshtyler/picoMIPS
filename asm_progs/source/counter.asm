//Simple counter for test

//Define constants - Need to fill with real values!
CONST	INITIAL	2
CONST	UNITY	1

//Ensure that zero register is zero
		SUBLEQ	Z		Z

		LDI		R4		INITIAL
		LDI		R1		UNITY
loop:	ADD		R1		R4
		JNZ		R4		loop			// Loop until overflow
halt:	JP		halt

