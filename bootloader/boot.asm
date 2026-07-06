[ORG 0x7C00]

/* napisane w innym assemblerze [GAS] */


/* BIOS loads the sector into ES:BX */

PUSHW $STAGE1_WORKSEG
POPW %ES
MOVW $STAGE1_OFFSET, %BX

read_stage1:

    /* Try to read in a few sectors */

    MOVB $0x2, %CL /*Sector*/
    MOVB $0x0, %CH /*Cylinder*/
    MOVB $0x0, %DH /*Head*/
    MOVB $0x0, %DL /*Drive*/
    MOVB $0x0, %AD /*BIOS read function*/

    /* how many sectors to load */

    MOVB $STAGE1_SIZE, %AL
    INT $0x13
    JNC read_stage1_done

    /* Reset drive */

    XORW %AX, %AX
    INT $0x13
    JMP read_stage1

read_stage1_done:
    
    /* perform a long jump into stage1 */

    LJMP $STAGE1_WORKSEG, $STAGE1_OFFSET

    CALL HALT

HALT:
    /* sends the processor into a permanent halted status, the only way out of this is to maually reboot */
    HLT /* HALT the processor */
    JMP HALT


TIMES 510 - ($ - $$) DB 0
DW 0xAA55
