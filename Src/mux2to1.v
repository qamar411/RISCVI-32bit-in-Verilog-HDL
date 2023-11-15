module mux2to1 #(
    parameter n = 32
)(
    input wire  [ 0 :0] sel,
    input wire  [n-1:0] in0,
    input wire  [n-1:0] in1,
    output wire [n-1:0] out
);

    // selection signals 
    wire sel0, sel1;

    // selection signals logic
    assign sel0 = ~sel[0]; 
    assign sel1 =  sel[0];  

    // selecting signals using selection signals
    assign out =  {n{sel0}} & in0
                | {n{sel1}} & in1;
                
endmodule