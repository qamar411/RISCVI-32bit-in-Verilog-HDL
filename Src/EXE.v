module EXE (
    input wire [31:0] rdata1_exe,
    input wire [31:0] rdata2_exe,
    input wire [31:0] alu_result_mem,
    input wire [31:0] result_wb,
    input wire [31:0] pc_exe,
    input wire selA,      // selection logic at alu input A, coming from forwarding logic
    input wire selB,      // -  -  -  -  -  -  -  -  -  - B,  -  -  -  - -  -  -  -  -  - 
    input wire [1:0] forward_rd1_exe,
    input wire [1:0] forward_rd2_exe, 
    input wire [3:0] ALUCtrl,
    input wire [31:0] Imm_exe,
    input wire Branch_exe,
    input wire Jump_exe,
    input wire BrUn_exe,   // input to the branch comparator

    output wire [31:0] alu_result_ex,
    output wire [31:0] rdata2_forwarded,
    output wire BrEq_exe,  // output of the br compartor
    output wire BrLt_exe  // output of the br comparator
);
 
  /*
   *
   */

// ------------------------------ ALU LOGIC STARTS HERE -----------------------------------//

    wire [31:0] rdata1_forwarded;
    // Forwarding mux for rd1
    mux3to1 #(32) forwarding_mux_a (
        .sel(forward_rd1_exe),
        .in0(rdata1_exe),
        .in1(alu_result_mem),
        .in2(result_wb),
        .out(rdata1_forwarded)
    );

    // Forwarding mux for rd2
    mux3to1 #(32) forwarding_mux_b (
        .sel(forward_rd2_exe),
        .in0(rdata2_exe),
        .in1(alu_result_mem),
        .in2(result_wb),
        .out(rdata2_forwarded)
    );      



    // Mux at ALU input A
    wire [31:0] alu_in_a;
    mux2to1 #(32) alu_in_A_mux (
        .sel(selA),
        .in0(rdata1_forwarded),
        .in1(pc_exe),
        .out(alu_in_a)
    );

    // Mux at ALU input B
    wire [31:0] alu_in_b;
    mux2to1 #(32) alu_in_B_mux (
        .sel(selB),
        .in0(rdata2_forwarded),
        .in1(Imm_exe),
        .out(alu_in_b)
    );    

    // ALU module Instantiation 
    ALU ALU_inst (
        .in1(alu_in_a),
        .in2(alu_in_b),
        .ALUCtrl(ALUCtrl),
        .Result(alu_result_ex)
    );

// -------------------------------- ALU LOGIC ENDS HERE -------------------------------------//
 
  /*
   *
   */

// ------------------------ BRANCH COMPARATOR LOGIC STARTS HERE -----------------------------//
     
    // Instantiation of Branch Comparator module
    Branch_Comparator Branch_Comparator_inst (
        .a(rdata1_forwarded),
        .b(rdata2_forwarded),
        .BrUn(BrUn_exe),
        .BrLt(BrLt_exe),
        .BrEq(BrEq_exe)
    );

// ------------------------ BRANCH COMPARATOR LOGIC ENDS HERE -----------------------------//


endmodule
