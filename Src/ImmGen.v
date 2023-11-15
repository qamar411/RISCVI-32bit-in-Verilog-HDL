/************************************ Immediate Generator ***************************************/
/* Designed by Qamar Moavia
 Details =>
 This unit extracts immidiate value from the instruction depending upon instruction type,
 Because in different type of instructions, immidiate value is placed at different indexes
*/
module ImmGen(
    input wire [24:0] Inst,
    input wire [2:0] ImmSel,
    output reg [31:0] Imm
);
    // local parameters for readability
    localparam  ITYPE = 3'b000,
                STYPE = 2'b001,
                BTYPE = 2'b010,
                UTYPE = 2'b011,
                JTYPE = 3'b100;

    always @(*)
    begin
        case (ImmSel)
            ITYPE: Imm = {{20{Inst[24]}},Inst[24:13]};
            STYPE: Imm = {{20{Inst[24]}},Inst[24:18],Inst[4:0]};
            BTYPE: Imm = {{19{Inst[24]}}, Inst[24], Inst[0], Inst[23:18], Inst[4:1], 1'b0};
            UTYPE: Imm = {Inst[24:5], 12'b0};
            JTYPE: Imm = {{12{Inst[24]}}, Inst[24], Inst[12:5], Inst[13], Inst[23:14], 1'b0};
            default: Imm = 32'b0;
        endcase
    end
    
endmodule

/********************************* Immediate Generator Ends *************************************/