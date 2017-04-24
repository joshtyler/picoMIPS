//Assembly for Affine Transform

//Define constants
CONST A11 1
CONST A12 1
CONST A21 1
CONST A22 1

CONST B1 1
CONST B2 1

//Ensure that zero register is zero
SUBLEQ Z Z

//Load pixels
start:  JZ      SW8     start           // Wait for SW8 = 0
        MOV     SW17    R1              // Store X1 in R1
poll2:  JNZ     SW8      poll2
poll3:  JZ      SW8      poll3
        MOV     SW17    R2              // Store Y1 in R2
poll4:  JNZ     SW8     poll4

//Begin Affine algorithm execution part 1
//Note this could be optimised if some coefficients are repeated
        MULTI   A21     R1      R3      // Multiply A21, and X1, store in R3
        MULTI   A22     R2      R4      // Multiply A22, and Y1, store in R4
        ADD     R4      R3              // Add R3 and R4, store in R4
        LDI     B2      R3              // Store B2 in R3
        ADD     R4      R3              // R4 = Y2 = B2 + (A21*X1) + (A22*Y1)

//Begin output stage
//No need to move R4 to LED as it is already connected
poll5:  JZ      SW8     poll5
        
//Begin Affine algorithm execution part 2
//Note this could be optimised if some coefficients are repeated
        MULTI   A11     R1      R3      // Multiply A11, and X1, store in R3
        MULTI   A12     R2      R4      // Multiply A12, and Y1, store in R4
        ADD     R4      R3              // Add R3 and R4, store in R4
        LDI     B1      R3              // Store B1 in R3
        ADD     R4      R3              // R4 = X2 = B1 + (A11*X1) + (A12*Y1)

//Begin output stage
//No need to move R4 to LED as it is already connected
poll6:  JNZ     SW8     poll6
        JP      start
