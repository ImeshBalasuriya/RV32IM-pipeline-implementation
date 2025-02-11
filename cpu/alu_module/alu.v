// TODO : write testbench 

`timescale 1ns/100ps


module alu (DATA1, DATA2, RESULT, SELECT);

    input   [31:0]  DATA1, DATA2;
    input   [5:0]   SELECT;
    output  [31:0]  RESULT;

    reg     [31:0]  RESULT;

    wire    [31:0]  INTER_ADD,
                    INTER_SUB,
                    INTER_AND,
                    INTER_OR,
                    INTER_XOR,
                    INTER_SLT,
                    INTER_SLTU,
                    INTER_SLL,
                    INTER_SRL,
                    INTER_SRA,
                    INTER_MUL,
                    INTER_MULH,
                    INTER_NUMHSU,
                    INTER_MULHU,
                    INTER_DIV,
                    INTER_REM,
                    INTER_REMU,
                    INTER_FWD; // intermediate to hold calculation




    //time delay set temp for operations
    assign #1 INTER_FWD = DATA2;

    assign #3 INTER_ADD = DATA1 + DATA2;
    assign #3 INTER_SUB = DATA1 - DATA2;
    assign #3 INTER_AND = DATA1 & DATA2;
    assign #3 INTER_OR = DATA1 | DATA2;
    assign #3 INTER_XOR = DATA1 ^ DATA2;

    // logical shift 
    assign #4 INTER_SLL = DATA1 << DATA2;
    assign #4 INTER_SRL = DATA1 >> DATA2;
    // arithmetic shift right
    assign #4 INTER_SRA = DATA1 >>> DATA2;

    assign #3 INTER_SLT = ($signed(DATA1) < $signed(DATA2)) ? 1'b1 : 1'b0 ; //set less than
    assign #3 INTER_SLTU = ($unsigned(DATA1) < $unsigned(DATA2)) ? 1'b1 : 1'b0; // set less than unsigned

    assign #8 INTER_MUL = DATA1 * DATA2; // multiplication
    // returns upper 32 bits of signed x unsigned  
    assign #8 INTER_MULHSU = $signed(DATA1) * $signed(DATA2); 
    // returns upper 32 bits of unsigned x unsigned  
    assign #8 INTER_MULHU = $unsigned(DATA1) * $unsigned(DATA2); // multiplication

    // signed integer division
    assign #8 INTER_DIV = $signed(DATA1) / $signed(DATA2);
    assign #8 INTER_REM = $signed(DATA1) % $signed(DATA2);

    // unsigned remainder
    assign #8 INTER_REMU = $unsigned(DATA1) % $unsigned(DATA2);

/*
ref: https://varshaaks.wordpress.com/2021/07/19/rv32i-base-integer-instruction-set/


R -Type

ADD, SUB , OR, XOR, AND
SLT, SLTU
SLL, SRL, SRA

I - Type

ADDI, ANDI, ORI, XORI
SLTI, (SLTUI)
SLLI, SRLI, SRAI


U -Type

LUI
AUIPC

J - Type

JALR
JAL

B - Type

BEQ BNEQ    
BLT BLTU
BGE BGEU

S - Type

LOAD LW LH LHU LB LBU
STORE SW SH SB 

*/

always @ (*)
begin
    case(SELECT)
        6'b000000:
            RESULT = INTER_ADD;
        6'b000001:
            RESULT = INTER_SLL;
        6'b000010:
            RESULT = INTER_SLT;
        6'b000011:
            RESULT = INTER_SLTU;

        6'b000100:
            RESULT = INTER_XOR;
        6'b000101:
            RESULT = INTER_SRL;
        6'b000110:
            RESULT = INTER_OR;
        6'b000111:
            RESULT = INTER_AND;
        // mul command
        6'b001000:
            RESULT = INTER_MUL;
        6'b001001:
            RESULT = INTER_MUL;
        6'b001010:
            RESULT = INTER_MULHSU;
        6'b001011:
            RESULT = INTER_MULHU;

        6'b001100:
            RESULT = INTER_DIV;
        6'b001011:
            RESULT = INTER_REM;
        6'b001011:
            RESULT = INTER_REMU;

        6'b010000:
            RESULT = INTER_SUB;
        6'b001001:
            RESULT = INTER_SRA;
        6'b011xxx:
            RESULT = INTER_FWD;
        default: RESULT = 0;
    endcase
end

endmodule
