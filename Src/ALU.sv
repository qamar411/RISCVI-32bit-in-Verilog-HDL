/************************************** Arithmatic and Logic Unit ************************************/
/* Designed by Qamar Moavia
 Details =>

*/

module ALU(
    input logic [31:0] in1,
    input logic [31:0] in2,
    input logic [3:0] ALUCtrl,              // ALUController Signal tells ALU which operation to perform
    output logic [31:0] Result
);

    // local parameters are the ALUCtrl lines
    // each ALUCtrl line is responsible for seperate operation in the ALU
    // there are total 10 different operations in the ALU
    localparam ADD = 4'b0000, SUB = 4'b1000, XOR = 4'b0100, OR = 4'b0110, AND = 4'b0111, 
            SLL = 4'b0001, SRL = 4'b0101, SRA = 4'b1101, SLT = 4'b0010, SLTU = 4'b0011;

    always @(*)
    begin
        case (ALUCtrl)
            ADD :    Result = in1 + in2;
            SUB :    Result = in1 - in2;
            XOR :    Result = in1 ^ in2;
            OR  :    Result = in1 | in2;
            AND :    Result = in1 & in2;
            SLL :    Result = in1 << in2[4:0];
            SRL :    Result = in1 >> in2[4:0];
            SRA :    Result = $signed(in1) >>> in2[4:0];
            SLT :    Result = $signed(in1) < $signed(in2);
            SLTU:    Result = in1 < in2;
            default: Result = 0;
        endcase
    end

endmodule

/*********************************** Arithmatic and Logic Unit Ends **********************************/
