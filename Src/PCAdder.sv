/************************************** Program Counter Adder ************************************/
/* Designed by Qamar Moavia
 Details =>
 This module takes the decision whether the instruction fetched is 32 bit valid instruction or 16 bit RV C type
 This adder adds 4 to current_pc/pc_in in case the instruction is 32 bit RV I type else 2
 This module is used in IF stage for calculating the next pc also in the MEM stage where pc + 4/2 is stored as return address
*/

module PCAdder(
    input wire  [31:0]   pc_current,
    input wire           Inst_Compr,
    output wire [31:0]   pc_next
);

    assign pc_next = Inst_Compr === 1'b1 ? pc_current + 2 : pc_current + 4; 

endmodule

/*********************************** Program Counter Adder Ends **********************************/