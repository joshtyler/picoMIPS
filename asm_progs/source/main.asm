//Assembly for Affine Transform

//Define constants - data set 2
		CONST	A11		4			// 00100 = 0.5
		CONST	A12		25			// 11001 = -0.875
		CONST	A21		25			// 11001 = -0.875
		CONST	A22		6			// 00110 = 0.75

		CONST	B1		5			// 00101 = 5
		CONST	B2		12			// 01100 = 12

//Ensure that zero register is zero
SUBLEQ Z Z

//Load pixels
start:	JLEZ	SW8     start           // Wait for SW8 = 0
        MOV     SW17    R1              // Store X1 in R1
poll2:  JGZ     SW8		poll2
poll3:  JLEZ	SW8     poll3
        MOV     SW17    R2              // Store Y1 in R2
poll4:  JGZ     SW8     poll4

//Begin Affine algorithm execution part 1
//Note this could be optimised if some coefficients are repeated
        MULTI   R1      R3		A11      // Multiply A11, and X1, store in R3
        MULTI   R2      R4		A12      // Multiply A12, and Y1, store in R4
        ADD     R3      R4              // Add R3 and R4, store in R4
        LDI     R3		B1              // Store B2 in R3
        ADD     R3      R4              // R4 = Y2 = B2 + (A21*X1) + (A22*Y1)

//Begin output stage
//No need to move R4 to LED as it is already connected
poll5:  JLEZ      SW8     poll5
        
//Begin Affine algorithm execution part 2
//Note this could be optimised if some coefficients are repeated
        MULTI   R1      R3		A21      // Multiply A21, and X1, store in R3
        MULTI   R2      R4		A22      // Multiply A22, and Y1, store in R4
        ADD     R3      R4              // Add R3 and R4, store in R4
        LDI     R3		B2              // Store B1 in R3
        ADD     R3      R4              // R4 = X2 = B1 + (A11*X1) + (A12*Y1)

//Begin output stage
//No need to move R4 to LED as it is already connected
poll6:  JGZ     SW8     poll6
        JP      start
