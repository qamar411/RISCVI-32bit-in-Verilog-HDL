/****************************************************      ALU Control      ***************************************************/
/* Designed by Qamar Moavia
 Details =>
 1. ALUOp[1] indicate addition only situation when high, otherwire ALUop[0] indicate type of instruction.
 2. Incase of Addition only instructions (Memory Read and Write, Jump, Branch etc), ALUCtrl is 4'b0000.
 2. ALUop[0] indicate whether instruction is I type (0) or R type (1). 
*/

module ALU_Control (  
    input wire [1:0] ALUOp,   
    input wire [2:0] func3,       
    input wire func7_0, // Will be Used in Rv32M Extensison
    input wire func7_5,           
    output wire [3:0]ALUCtrl
);
    assign ALUCtrl = {ALUOp[0] ? ( (func3 == 5) ? {func7_5, func3} : {0, func3}) : ({func7_5, func3})} & {4{~ALUOp[1]}};
endmodule

/****************************************************  ALU Control END  ************************************************************/