module mux4to1 #(
    parameter n = 32
)(
    input wire  [ 1 :0] sel,
    input wire  [n-1:0] in0,
    input wire  [n-1:0] in1,
    input wire  [n-1:0] in2,
    input wire  [n-1:0] in3,
    output wire [n-1:0] out
);

    // selection signals 
    wire sel0, sel1, sel2, sel3;

    // selection signals logic
    assign sel0 = ~sel[1] & ~sel[0]; 
    assign sel1 = ~sel[1] &  sel[0]; 
    assign sel2 =  sel[1] & ~sel[0]; 
    assign sel3 =  sel[1] &  sel[0];   

    // selecting signals using selection signals
    assign out =  {n{sel0}} & in0
                | {n{sel1}} & in1
                | {n{sel2}} & in2
                | {n{sel3}} & in3;
                
endmodule