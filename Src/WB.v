 /*
  * This module is designed by Qamar Moavia
  * Its not currently being used in RV32I, as the wb selection mux is now in the MEM stage.
  */
module WB (

    input wire [31:0] alu_result_wb,
    input wire [31:0] dmem_out_wb,
    input wire [31:0] pc_adder_out_wb,
    input wire [31:0] Imm_wb,
    input wire [1:0] WBSel_wb,
    output wire [31:0] result_wb
);

// ------------------------------ Write Back LOGIC STARTS HERE -----------------------------------//

    // Mux at WB stage
    mux4to1 #(32) alu_in_A_mux (
        .sel(WBSel_wb),
        .in0(dmem_out_wb),        
        .in1(alu_result_wb),
        .in2(pc_adder_out_wb),
        .in3(Imm_wb),
        .out(result_wb)
    );

// ------------------------------ Write Back LOGIC STARTS HERE -----------------------------------//

endmodule