module IF #(
    parameter IM_WIDTH = 32,
    parameter IM_DEPTH = 256
)(
    input wire clk,
    input wire rst_n,
    input wire PC_en,
    input wire PCSrc,
    input wire Inst_flush,
    input wire [31:0] branch_target,
    output wire [31:0] pc_addr_out,
    output wire [31:0] pc_next,
    output wire [31:0] pc_current,
    output wire [31:0] Inst_if,
    output wire misaligned_pc
);

    localparam Nop_Inst = 32'h00000013;

    // Instantiate the Program Counter Adder module
    wire Inst_Compr_if;
    assign Inst_Compr_if = ~(&Inst_if[1:0]);

    PCAdder PCAdder_inst (
        .pc_current(pc_current),
        .Inst_Compr(Inst_Compr_if), // You can set this to your control signal
        .pc_next(pc_addr_out)
    );

    // the mux is present in the IF stage which decides whether to send ALU address or pc + 4/2
    mux2to1 pc_mux (
        .in0(pc_addr_out), // either +4 or +2
        .in1(branch_target), 
        .sel((PCSrc===1)), 
        .out(pc_next)
    );

    // Instantiate the Program Counter module
    PC PC_inst (
        .clk(clk),
        .rst_n(rst_n),
        .en(PC_en), // You can set this to your control signal
        .pc_next(pc_next),
        .pc_current(pc_current)
    );

    // Instantiate the Instruction Memory module
    wire [IM_WIDTH - 1:0] Imem_out;
    IMEM #(
        .WIDTH(IM_WIDTH), 
        .DEPTH(IM_DEPTH)
    ) IMEM_ (
        .addr(pc_current),
        .instr(Imem_out),
        .misaligned_addr(misaligned_pc)
    );

        // the mux is present in the IF stage which decides whether to send ALU address or pc + 4/2
    mux2to1 IF_out_mux (
        .in0(Imem_out), // either +4 or +2
        .in1(Nop_Inst), 
        .sel((Inst_flush===1)), 
        .out(Inst_if)
    );

endmodule
