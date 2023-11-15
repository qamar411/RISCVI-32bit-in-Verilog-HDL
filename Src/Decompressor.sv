/**************************************************** Decompressor ***************************************************/
/* Designed by Qamar Moavia
 Details =>
    1. This module takes 32 bits from the Inst_Inuction memory then decides whether the Inst_Inuction is
       Compressed or Integer type on the basis of Inst[1:0].
    2. In case of integer type Inst_Inuction, same 32 bits are passed on.
    3. In case of compressed Inst_In, Inst_In is converted to its corresponding Integer type instruction 
       and that integer instruction is forwarded to Decode unit.
*/
module Decompressor (
    input  wire [31:0] Inst_In,
    output reg [31:0] Inst_Out,
    output wire [0 :0] Inst_Compr
);

    localparam Nop_Inst = 32'h00000013;

    assign Inst_Compr = &Inst_In[1:0];

    always @(*)
    begin
    if (Inst_In[1:0] == 2'b11) // Inst_Inuction is 32 bits valid i.e Integer type Inst_Inuction
    begin 
        if(Inst_In[6:2] == 5'b01100 | Inst_In[6:2] == 5'b00100 | Inst_In[6:2] == 5'b00000 | Inst_In[6:2] == 5'b11001 | Inst_In[6:2] == 5'b01000 | Inst_In[6:2] == 5'b11000 | Inst_In[6:2] == 5'b11011 | Inst_In[6:2] == 5'b01101 | Inst_In[6:2] == 5'b00101)
        Inst_Out = Inst_In;
        else 
        Inst_Out = Nop_Inst; // nop --- addi x0, x0, 0
    end
    else // compressed Inst_Inuction
    begin
        case (Inst_In[1:0])
        2'b00: //c.lw,c.sw
        begin
            if(Inst_In[15:13] == 3'b010) // c.lw 
            Inst_Out = {{5{1'b0}}, Inst_In[5], Inst_In[12:10], Inst_In[6], {2{1'b0}}, 1'b0, 1'b1, Inst_In[9:7], 3'b010, 1'b0, 1'b1, Inst_In[4:2], 7'b0000011};
            else if (Inst_In[15:13] == 3'b110) // c.sw
            Inst_Out = {{5{1'b0}}, Inst_In[5], Inst_In[12], 2'b01, Inst_In[4:2], 1'b0, 1'b1, Inst_In[9:7], 3'b010, Inst_In[11:10], Inst_In[6], 1'b0, 1'b0, 7'b0100011};
            else Inst_Out = Nop_Inst; // nop
        end
        2'b01: // c.j,c.jal,c.beqz,c.bnez,c.li,c.lui,c.addi,c.srli,c.srai,c.andi,c.and,c.or,c.xor,c.sub,c.nop
        begin
        if(Inst_In[15:13] == 3'b101) // c.j
        Inst_Out = {Inst_In[12], Inst_In[8], Inst_In[10:9], Inst_In[6], Inst_In[7], Inst_In[2], Inst_In[11], Inst_In[5:3], Inst_In[12], {8{Inst_In[12]}}, 1'b0, 1'b0, 3'b000, 7'b1101111};
        else if (Inst_In[15:13] == 3'b001) // c.jal
        Inst_Out = {Inst_In[12], Inst_In[8], Inst_In[10:9], Inst_In[6], Inst_In[7], Inst_In[2], Inst_In[11], Inst_In[5:3], Inst_In[12], {8{Inst_In[12]}} , 1'b0, 1'b0, 3'b001, 7'b1101111};
        else if (Inst_In[15:13] == 3'b110) // c.beqz
        Inst_Out = {{3{Inst_In[12]}}, Inst_In[12], Inst_In[6:5], Inst_In[2], 5'b00000, 2'b01, Inst_In[9:7], 3'b000, Inst_In[11:10], Inst_In[4:3], Inst_In[12], 7'b1100011};
        else if (Inst_In[15:13] == 3'b111) // c.bnez
        Inst_Out = {{3{Inst_In[12]}}, Inst_In[12], Inst_In[6:5], Inst_In[2], 5'b00000, 2'b01, Inst_In[9:7], 3'b001, Inst_In[11:10], Inst_In[4:3], Inst_In[12], 7'b1100011};
        else if (Inst_In[15:13] == 3'b010) // c.li
        Inst_Out = {{6{Inst_In[12]}}, Inst_In[12], Inst_In[6:2], 5'b00000, 3'b000, Inst_In[11:7], 7'b0010011};
        else if (Inst_In[15:13] == 3'b011) // c.lui
        Inst_Out = {{14{Inst_In[12]}}, Inst_In[12], Inst_In[6:2], Inst_In[11:7], 7'b0110111};
        else if (Inst_In[15:13] == 3'b000 && Inst_In[11:7] == 5'b00000) // c.nop
        Inst_Out = {{12{1'b0}}, 5'b00000, 3'b000, 5'b00000, 7'b0010011};
        else if (Inst_In[15:13] == 3'b000) // c.addi
        Inst_Out = {{6{Inst_In[12]}}, Inst_In[12], Inst_In[6:2], Inst_In[11:7], 3'b000, Inst_In[11:7], 7'b0010011};
        else if (Inst_In[15:13] == 3'b100) // c.srli, c.srai, c.andi, c.and,c.or,c.xor,c.sub
        begin
            if (Inst_In[11:10] == 2'b00) // c.srli
            Inst_Out = {{6{1'b0}}, Inst_In[12], Inst_In[6:2], 2'b01, Inst_In[9:7], 3'b101, 2'b01, Inst_In[9:7], 7'b0010011};
            else if (Inst_In[11:10] == 2'b01) // c.srai
            Inst_Out = {{6{1'b0}}, Inst_In[12], Inst_In[6:2], 2'b01, Inst_In[9:7], 3'b101, 2'b01, Inst_In[9:7], 7'b0010011};
            else if (Inst_In[11:10] == 2'b10) // c.andi
            Inst_Out = {{6{Inst_In[12]}}, Inst_In[12], Inst_In[6:2], 2'b01, Inst_In[9:7], 3'b111, 2'b01, Inst_In[9:7], 7'b0010011};
            else if ((Inst_In[11:10] == 2'b11) && (Inst_In[6:5] == 2'b11)) // c.and
            Inst_Out = {7'b0000000, 2'b01, Inst_In[4:2], 2'b01, Inst_In[9:7], 3'b111, 2'b01, Inst_In[9:7], 7'b0110011};
            else if ((Inst_In[11:10] == 2'b11) && (Inst_In[6:5] == 2'b10)) // c.or
            Inst_Out = {7'b0000000, 2'b01, Inst_In[4:2], 2'b01, Inst_In[9:7], 3'b110, 2'b01, Inst_In[9:7], 7'b0110011};
            else if ((Inst_In[11:10] == 2'b11) && (Inst_In[6:5] == 2'b01)) // c.xor
            Inst_Out = {7'b0000000, 2'b01, Inst_In[4:2], 2'b01, Inst_In[9:7], 3'b100, 2'b01, Inst_In[9:7], 7'b0110011};
            else if ((Inst_In[11:10] == 2'b11) && (Inst_In[6:5] == 2'b00)) // c.sub
            Inst_Out = {7'b0100000, 2'b01, Inst_In[4:2], 2'b01, Inst_In[9:7], 3'b000, 2'b01, Inst_In[9:7], 7'b0110011};
            else
            Inst_Out = Nop_Inst; // nop
        end
        else 
            Inst_Out = Nop_Inst; // nop
        end
        2'b10: // c.jr, c.jalr, c.slli, c.mv, c.add
        begin
            if (Inst_In[15:13] == 3'b000) // c.slli
            Inst_Out = {{6{1'b0}}, Inst_In[12], Inst_In[6:2], Inst_In[11:7], 3'b001, Inst_In[11:7], 7'b0010011};
            else if (Inst_In[15:13] == 3'b100) // c.jr, c.jalr, c.mv, c.add
            begin
            if ((Inst_In[12] == 1'b0) && (Inst_In[6:2] == 5'b00000)) // c.jr
            Inst_Out = {12'b000000000000, Inst_In[11:7], 3'b000, 5'b00000, 7'b1100111};
            else if ((Inst_In[12] == 1'b1) && (Inst_In[6:2] == 5'b00000)) // c.jalr
            Inst_Out = {12'b000000000000, Inst_In[11:7], 3'b000, 5'b00001, 7'b1100111};
            else if (Inst_In[12] == 1'b0) // c.mv
            Inst_Out = {7'b0000000, Inst_In[6:2], 5'b00000, 3'b000, Inst_In[11:7], 7'b0110011};
            else if (Inst_In[12] == 1'b1) // c.add
            Inst_Out = {7'b0000000, Inst_In[6:2], Inst_In[11:7], 3'b000, Inst_In[11:7], 7'b0110011};
            else
            Inst_Out = Nop_Inst; // nop
            end
            else
            Inst_Out = Nop_Inst; // nop 
        end
        default:
        Inst_Out = Nop_Inst; // nop
        endcase
    end
    end
endmodule

/**************************************************** Decompressor ENDs ***************************************************/
