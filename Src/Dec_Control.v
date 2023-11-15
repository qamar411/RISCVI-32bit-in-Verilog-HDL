/****************************************************** Decode Control Unit *******************************************************/
/* Designed by Qamar Moavia
 Details =>
 At input the 2 LSBs are not needed as they will always be 11  
 RegWen is Register write enable signal, ASel and BSel are the ALU mux signals
 MemWrite is memory write enable signal, Branch and Jump are the signals for Branch Controller
 The selection for selecting the right immediate making out of 6 instructions types done here
 WBSel is last write back mux selecting between ALU, memory read or pc+4 as its 3 inputs
*/

module Dec_Control(
    input reg [4:0] opcode,
    output reg RegWen,
    output reg ASel,
    output reg BSel,
    output reg exe_use_rs1,
    output reg exe_use_rs2,
    output reg MemWrite,
    output reg MemRead,
    output reg [1:0] WBSel,
    output reg [2:0] ImmSel,
    output reg [1:0] ALUop,
    output reg Branch,
    output reg Jump
);

always @(*)
begin
    case (opcode)
    5'b01100: // R Type 
    begin
        RegWen = 1;
        ASel = 0;
        BSel = 0;
        exe_use_rs1 = 1;
        exe_use_rs2 = 1;
        MemWrite = 0;
        MemRead  = 0; 
        ImmSel = 3'b000; // Don't care
        WBSel = 2'b01;
        ALUop = 2'b00;
        Branch = 1'b0;
        Jump = 1'b0;
    end
    5'b00100: // I Type
    begin
        RegWen = 1;
        ASel = 0;
        BSel = 1;
        exe_use_rs1 = 1;
        exe_use_rs2 = 0;
        MemWrite = 0;
        MemRead  = 0; 
        ImmSel = 3'b000;
        WBSel = 2'b01;
        ALUop = 2'b01;
        Branch = 1'b0;
        Jump = 1'b0;
    end
    5'b00000: // I Type (Loads)
    begin
        RegWen = 1;
        ASel = 0;
        BSel = 1;
        exe_use_rs1 = 1;
        exe_use_rs2 = 0;
        MemWrite = 0;
        MemRead  = 1; 
        ImmSel = 3'b000;
        WBSel = 2'b00;
        ALUop = 2'b10;
        Branch = 1'b0;
        Jump = 1'b0;
    end
    5'b11001: // I Type (Jalr)
    begin
        RegWen = 1;
        ASel = 0;
        BSel = 1;
        exe_use_rs1 = 1;
        exe_use_rs2 = 0;
        MemWrite = 0;
        MemRead  = 0; 
        ImmSel = 3'b000;
        WBSel = 2'b10;
        ALUop = 2'b10;
        Branch = 1'b0;
        Jump = 1'b1;
    end
    5'b01000: // S Type
    begin
        RegWen = 0;
        ASel = 0;
        BSel = 1;
        exe_use_rs1 = 1;
        exe_use_rs2 = 0;
        MemWrite = 1;
        MemRead  = 0; 
        ImmSel = 3'b001;
        WBSel = 2'b00; //dont care
        ALUop = 2'b10;
        Branch = 1'b0;
        Jump = 1'b0;
    end
    5'b11000: // SB Type
    begin
        RegWen = 0;
        ASel = 1;
        BSel = 1;
        exe_use_rs1 = 1;
        exe_use_rs2 = 1;
        MemWrite = 0;
        MemRead  = 0; 
        ImmSel = 3'b010;
        WBSel = 2'b00; //dont care
        ALUop = 2'b10;
        Branch = 1'b1;
        Jump = 1'b0;
    end
    5'b11011: // J Type
    begin
        RegWen = 1;
        ASel = 1;
        BSel = 1;
        exe_use_rs1 = 0;
        exe_use_rs2 = 0;
        MemWrite = 0;
        MemRead  = 0; 
        ImmSel = 3'b100;
        WBSel = 2'b10; //dont care
        ALUop = 2'b10;
        Branch = 1'b0;
        Jump = 1'b1;
    end
    5'b01101: // U Type (LUI)
    begin
        RegWen = 1;
        ASel = 0; // don't care
        BSel = 0; // don't care
        exe_use_rs1 = 0;
        exe_use_rs2 = 0;
        MemWrite = 0;
        MemRead  = 0; 
        ImmSel = 3'b011;
        WBSel = 2'b11;  // to select imm value as output in the wb stage
        ALUop = 2'b00;  // don't care
        Branch = 1'b0;
        Jump = 1'b0;
    end
    5'b00101: // U Type (AUIPC)
    begin
        RegWen = 1;
        ASel = 1;
        BSel = 1;
        exe_use_rs1 = 0;
        exe_use_rs2 = 0;
        MemWrite = 0;
        MemRead  = 0; 
        ImmSel = 3'b011;
        WBSel = 2'b01;
        ALUop = 2'b10;
        Branch = 1'b0;
        Jump = 1'b0;
    end 
    default: // all the writes are disabled intentionally so that states are not changed
    begin
        RegWen = 0;
        ASel = 0;
        BSel = 0;
        exe_use_rs1 = 0;
        exe_use_rs2 = 0;
        MemWrite = 0;
        MemRead  = 0; 
        ImmSel = 3'b000;
        WBSel = 2'b00;
        ALUop = 2'b00;
        Branch = 1'b0;
        Jump = 1'b0;
    end 
    endcase
end

endmodule

/****************************************************  Decode Control Unit End  ***************************************************/
