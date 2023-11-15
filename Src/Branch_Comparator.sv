/************************************** Branch Comparator ************************************/
/* Designed by Qamar Moavia
 Details =>
    only on the basis of BrUn we will be calculating the BrLt, BrEq
    all the branch conditions can be extracted from these three (BrLt, BrEq, BrUn)
    BrEq is independent of whether instruction is signed or unsigned
*/
module Branch_Comparator(
    input logic [31:0] a,   
    input logic [31:0] b,    
    input logic        BrUn, 
    output logic       BrLt,  
    output logic       BrEq    
);

    assign BrEq = (a == b);  
    assign BrLt = BrUn ? (a < b) : ($signed(a) < $signed(b));

endmodule

/*********************************** Branch Comparator Ends **********************************/
