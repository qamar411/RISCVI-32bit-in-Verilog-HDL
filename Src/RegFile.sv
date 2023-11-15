/********************************************* RegFile *********************************************/
/* Designed by Qamar Moavia
 Details =>
    1. This is 32by32 register file, with reg0 hardwired to zero, so my code only synthesize 
       31 registers. 
    2. If RegWrite is high, 32bit Data wd is written to register number rd at the rising edge of clk.
    3. Whenever rst_n signal goes low, all the register gets value zero instantly (asynchronous reset).
    4. Condtantly, rs1 and rd2 are assigned values of register number rs1 and register number rs2 respectively.
*/
module RegFile #(
    parameter WIDTH = 32,
    parameter DEPTH = 32
)(
    input logic clk,
    input logic rst_n,
    input logic RegWrite,
    input logic [$clog2(DEPTH)-1:0] rs1,
    input logic [$clog2(DEPTH)-1:0] rs2,
    input logic [$clog2(DEPTH)-1:0] rd,
    input logic [WIDTH-1:0] wd,
    output logic [WIDTH-1:0] rd1,
    output logic [WIDTH-1:0] rd2
);

    logic [WIDTH-1:0] regfile [0:DEPTH-1];
    logic [DEPTH-1:0] enables;  // enable 0 is not used anywhere
    assign regfile [0] = 32'b0; // X0 is Hardwired to value zero.


    // Generating Write enables for each register
    integer j;
    always @(*)
    begin
        for(j = 1; j < DEPTH; j = j + 1)
        begin
            if(j == rd) enables[j] = RegWrite;
            else enables[j] = 0;
        end
    end


    // Generating Registers using register_w_enable module
    genvar i;   
    generate
        for (i = 1; i < DEPTH; i = i + 1)
        begin
            register_w_enable #(32) Reg_ (
            .din(wd),
            .en(enables[i]),
            .clk(clk),
            .rst_l(rst_n),
            .dout(regfile[i]));
        end
    endgenerate


    // reading asynchronously
    assign rd1 = regfile[rs1];
    assign rd2 = regfile[rs2];

endmodule

/********************************************* RegFile Ends *********************************************/