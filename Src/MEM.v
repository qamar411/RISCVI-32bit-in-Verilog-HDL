module MEM #(
    parameter DM_WIDTH = 32,
    parameter DM_DEPTH = 256
)(
    input wire clk,
    input wire rst_n,
    input wire [31:0] alu_result_mem,
    input wire [31:0] rdata2_mem,
    input wire [31:0] result_wb,
    input wire MemRead_mem,
    input wire MemWrite_mem,
    input wire forward_rd2_mem,
    input wire [2:0] fun3_mem,
    output wire [31:0] dmem_out_mem
);

// ------------------------------ DMEM LOGIC STARTS HERE -----------------------------------//

    // Forwarding Mux at data input of DMEM
    wire [31:0] Mem_Write_Data;
    mux2to1 #(32) mem_data_in_mux (
        .sel(forward_rd2_mem),
        .in0(rdata2_mem),
        .in1(result_wb),
        .out(Mem_Write_Data)
    );

    /*
     *
     */

    // Data Memory Instantiation 
    DMEM #(
        .WIDTH(DM_WIDTH), 
        .DEPTH(DM_DEPTH)
    ) DMEM_mem (
        .clk(clk),
        .rst_n(rst_n),
        .addr(alu_result_mem),
        .MemWrite(MemWrite_mem),
        .MemRead(MemRead_mem),
        .Write_Data(Mem_Write_Data),
        .control(fun3_mem),
        .Read_Data(dmem_out_mem)
    );

// ------------------------------ DMEM LOGIC STARTS HERE -----------------------------------//

endmodule