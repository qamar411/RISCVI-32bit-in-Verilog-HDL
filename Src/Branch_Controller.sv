/****************************************************     Branch Control      ***************************************************/
/* Designed by Qamar Moavia
 Details =>
*/
module branch_controller (Branch, Jump, beq, blt, fun3, BrUn,  PcSrc);

    // the branch and jump signals are extracted in the decode stage
    input Branch;
    input Jump;
    input beq, blt;              // input signals coming from the branch unit/branch comparator 
    input [2:0] fun3;            // fun3 bits specifies particular operation within conditional branch category
    output PcSrc;                // this is the PCSel signal. will tell if ALU output is to be used as pc_next or pc+4
    output logic BrUn;           // sends the signal to Branch Comparator

    assign BrUn = fun3[1];

    localparam  BEQ = 3'b000, BNE = 3'b001, BLT = 3'b100, BGE = 3'b101, BLTU  = 3'b110, BGEU = 3'b111;
    
    logic Branch_Taken;
    
    always @(*)
    begin
        case (fun3)
            BEQ:  Branch_Taken  =  beq;
            BNE:  Branch_Taken  = ~beq;
            BLT:  Branch_Taken  =  blt;
            BLTU: Branch_Taken  =  blt;
            BGE:  Branch_Taken  = ~blt;
            BGEU: Branch_Taken  = ~blt; 
            default: Branch_Taken =  0;  
        endcase
    end

    // PCSel will be high no matter its a branch or a jump (unconditional)
    assign PcSrc = (Branch & Branch_Taken) | Jump;

endmodule

/****************************************************   Branch Control End    ***************************************************/