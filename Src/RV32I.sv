`include "defines.svh"
module RV32I (
    input wire clk,
    input wire rst_n
);

// --------------------------------- IF STAGE STARTS HERE --------------------------------//
    // inputs 

    wire [31:0] alu_result_ex;

    // outputs 
    wire [31:0] pc_adder_out_if;
    wire [31:0] pc_next_if;
    wire [31:0] Inst_if;
    wire [31:0] pc_current_if;
    wire misaligned_pc_if;

    // Instantiate the IF module
    IF #(
        .IM_WIDTH(`RV_IMEM_WIDTH),
        .IM_DEPTH(`RV_IMEM_DEPTH)
    ) IF_inst (
        .clk(clk),
        .rst_n(rst_n),
        .PC_en(~Load_hazard_id), // control
        .PCSrc(PcSrc_exe),// control
        .Inst_flush(Branch_hazard_id),// control
        .branch_target(alu_result_ex),
        .pc_addr_out(pc_adder_out_if),
        .pc_next(pc_next_if),
        .pc_current(pc_current_if),
        .Inst_if(Inst_if),
        .misaligned_pc(misaligned_pc_if)
    );

// ---------------------------------- IF STAGE ENDS HERE ---------------------------------//


    // Instantiate the register_w_enable module between IF and ID stages

    wire [31:0] pc_current_id;
    wire [31:0] pc_adder_out_id;
    wire [31:0] Inst_id;

    register_w_enable #(
        .WIDTH(96)  
    ) REG_IF_ID (
        .clk(clk),
        .rst_l(rst_n),        
        .din({pc_current_if,pc_adder_out_if,Inst_if}),     // Output from IF stage
        .en(~Load_hazard_id),                
        .dout({pc_current_id,pc_adder_out_id,Inst_id})   // Input to ID stage
    );


// --------------------------------- ID STAGE STARTS HERE --------------------------------//

    // inputs from write back stage
    wire [31:0] result_wb;
    wire        RegWen_wb;
    wire [4:0]  rd_wb;

    // signals from forwarding unit
    wire forward_rd1_id;
    wire forward_rd2_id;



    // decoded outputs signals
    wire [6:0] opcode_id;
    wire [4:0] rd_id;  
    wire [2:0] fun3_id;
    wire [4:0] rs1_id; 
    wire [4:0] rs2_id; 
    wire [6:0] fun7_id;

    // Signals from the controller
    wire RegWen_id;
    wire ASel_id;
    wire BSel_id;
    wire MemWrite_id;
    wire MemRead_id;
    wire [1:0] WBSel_id;
    wire [2:0] ImmSel_id;
    wire [1:0] ALUop_id;
    wire Branch_id;
    wire Jump_id;
    

    // reg file outputs 
    wire [31:0] rdata1_id;
    wire [31:0] rdata2_id;

    // imm output
    wire [31:0] Imm_id;

    // Instantiate the ID module
    ID #(
        .RF_WIDTH(`RV_RF_WIDTH),  // Assuming RF_WIDTH is 32
        .RF_DEPTH(`RV_RF_DEPTH)  // Assuming RF_DEPTH is 32
    ) ID_inst (
        .clk(clk),
        .rst_n(rst_n),
        .Inst_id(Inst_id),
        .ImmSel_id(ImmSel_id),
        .rd_wb(rd_wb),
        .RegWen_wb(RegWen_wb),
        .wdata_wb(result_wb),
        .forward_rd1(forward_rd1_id),
        .forward_rd2(forward_rd2_id),       
        .opcode_id(opcode_id),
        .rd_id(rd_id),
        .fun3_id(fun3_id),
        .rs1_id(rs1_id),
        .rs2_id(rs2_id),
        .fun7_id(fun7_id),
        .rdata1_id(rdata1_id),
        .rdata2_id(rdata2_id),
        .Imm_id(Imm_id)
    );

// ---------------------------------- ID STAGE ENDS HERE ---------------------------------//

    wire [31:0] pc_current_exe;
    wire [31:0] pc_adder_out_exe;
    wire [2:0] fun3_exe;
    wire fun7_0_exe;
    wire fun7_5_exe;
    wire [31:0] rdata1_exe;
    wire [31:0] rdata2_exe;
    wire [31:0] Imm_exe;

    // Contrl Signals
    wire [1:0] ALUop_exe;
    wire RegWen_exe;
    wire[4:0] rd_exe;
    wire [4:0] rs1_exe;
    wire [4:0] rs2_exe;
    wire MemWrite_exe; 
    wire MemRead_exe;
    wire Branch_exe;
    wire Jump_exe;
    wire [1:0] WBSel_exe;
    wire ASel_exe;
    wire BSel_exe;

    wire [190:0] ID_EXE_in;
    assign ID_EXE_in = (Branch_hazard_id | Load_hazard_id) ? (191'd0) : 
                                         ({pc_current_id,pc_adder_out_id,fun3_id,fun7_id[0],fun7_id[5],rdata1_id, rdata2_id, Imm_id, ASel_id, BSel_id, ALUop_id, rs1_id, rs2_id,rd_id, RegWen_id, MemWrite_id, MemRead_id, WBSel_id, Branch_id, Jump_id});
   
   
   
    register_w_enable #(
        .WIDTH(191)  
    ) REG_ID_EXE (
        .clk(clk),
        .rst_l(rst_n),        
        .din(ID_EXE_in),     // Output from IF stage
        .en(1),                
        .dout({pc_current_exe,pc_adder_out_exe,fun3_exe,fun7_0_exe,fun7_5_exe,rdata1_exe, rdata2_exe, Imm_exe, ASel_exe, BSel_exe, ALUop_exe,  rs1_exe, rs2_exe, rd_exe, RegWen_exe, MemWrite_exe, MemRead_exe, WBSel_exe, Branch_exe, Jump_exe})   // Input to ID stage
    );

// ------------------------------- EXE STAGE STARTS HERE ---------------------------------//
    // inputs from control unit
    wire [31:0] result_mem;
    wire [1:0] forward_rd1_exe;
    wire [1:0] forward_rd2_exe;
    wire [31:0] rdata2_forwarded;
    wire [3:0] ALUCtrl_exe;
    // Instantiate the EXE module
    EXE EXE_inst (
        .rdata1_exe(rdata1_exe),
        .rdata2_exe(rdata2_exe),
        .result_mem(result_mem),
        .result_wb(result_wb),
        .pc_exe(pc_current_exe),
        .selA(ASel_exe),
        .selB(BSel_exe),
        .forward_rd1_exe(forward_rd1_exe),
        .forward_rd2_exe(forward_rd2_exe),
        .ALUCtrl(ALUCtrl_exe),
        .Imm_exe(Imm_exe),
        .Branch_exe(Branch_exe),
        .Jump_exe(Jump_exe),
        .BrUn_exe(BrUn_exe),
        .alu_result_ex(alu_result_ex),
        .rdata2_forwarded(rdata2_forwarded),
        .BrEq_exe(BrEq_exe),
        .BrLt_exe(BrLt_exe)
    );

// -------------------------------- EXE STAGE ENDS HERE ----------------------------------//

    wire [31:0] pc_adder_out_mem;
    wire [31:0] rdata2_mem;
    wire [31:0] Imm_mem;
    wire [31:0] alu_result_mem;
    wire MemRead_mem;
    wire MemWrite_mem;
    wire RegWen_mem;
    wire[4:0] rd_mem;
    wire [4:0] rs2_mem;
    wire [1:0] WBSel_mem;
    wire [2:0] fun3_mem;
    
    register_w_enable #(
        .WIDTH(146)  
    ) REG_EXE_MEM (
        .clk(clk),
        .rst_l(rst_n),        
        .din({alu_result_ex,pc_adder_out_exe,rdata2_forwarded,Imm_exe,fun3_exe,MemRead_exe,MemWrite_exe,rd_exe,rs2_exe, RegWen_exe,WBSel_exe}),     // Output from IF stage
        .en(1'b1),                
        .dout({alu_result_mem,pc_adder_out_mem,rdata2_mem,Imm_mem,fun3_mem,MemRead_mem,MemWrite_mem, rd_mem,rs2_mem, RegWen_mem,WBSel_mem})   // Input to ID stage
    );


// ------------------------------- MEM STAGE STARTS HERE ---------------------------------//

    wire [31:0] dmem_out_mem;
    wire forward_rd2_mem;
    // Data Memory instantiation 
    MEM #(
        .DM_WIDTH(`RV_DMEM_WIDTH),
        .DM_DEPTH(`RV_DMEM_DEPTH)        
    )MEM_inst ( 
        .clk(clk),
        .rst_n(rst_n),
        .alu_result_mem(alu_result_mem),
        .rdata2_mem(rdata2_mem),
        .result_wb(result_wb),
        .MemRead_mem(MemRead_mem),
        .MemWrite_mem(MemWrite_mem),
        .forward_rd2_mem(forward_rd2_mem),
        .fun3_mem(fun3_mem),
        .dmem_out_mem(dmem_out_mem)
    );

// -------------------------------- MEM STAGE ENDS HERE ----------------------------------//

    // wire [31:0] alu_result_wb;
    // wire [31:0] dmem_out_wb;
    // wire [31:0] pc_adder_out_wb;
    // wire [31:0] Imm_wb;
    // wire [1:0]  WBSel_wb;

    // ************** result selection mux starts here *************** //
    mux4to1 #(32) alu_in_A_mux (
        .sel(WBSel_mem),
        .in0(dmem_out_mem),        
        .in1(alu_result_mem),
        .in2(pc_adder_out_mem),
        .in3(Imm_mem),
        .out(result_mem)
    );

    // *************** result selection mux ends here **************** //    

    register_w_enable #(
        .WIDTH(38)  
    ) REG_MEM_WB (
        .clk(clk),
        .rst_l(rst_n),        
        .din({result_mem,  rd_mem, RegWen_mem}),     // Output from IF stage
        .en(1'b1),                
        .dout({result_wb,   rd_wb,  RegWen_wb})   // Input to ID stage
    );

// --------------------------------- Wb STAGE ENDS HERE ----------------------------------//
 /*
  * Writing back the value to the register file in this stage
  * Although Reg file is instantiated in ID stage. It get input write data frmo WB stage.
  */
// --------------------------------- WB STAGE ENDS HERE ----------------------------------//


    // Instantiating Control_Logic 
    Control_Logic Control_Logic_inst (
        /* Decode control inputs */
        .opcode_id(opcode_id[6:2]),
        /* Decode Control Signals */
        .RegWen_id(RegWen_id),
        .ASel_id(ASel_id),
        .BSel_id(BSel_id),
        .MemWrite_id(MemWrite_id),
        .MemRead_id(MemRead_id),
        .WBSel_id(WBSel_id),
        .ImmSel_id(ImmSel_id),
        .ALUop_id(ALUop_id),
        .Branch_id(Branch_id),
        .Jump_id(Jump_id),
        /* ALU Controller inputs */
        .ALUop_exe(ALUop_exe),
        .fun7_0_exe(fun7_0_exe),
        .fun7_5_exe(fun7_5_exe),
        .fun3_exe(fun3_exe),
        /* ALU Controller outputs */
        .ALUCtrl(ALUCtrl_exe),
        /* Branch Controller inputs */
        .BrEq_exe(BrEq_exe),
        .BrLt_exe(BrLt_exe),
        .Branch_exe(Branch_exe),
        .Jump_exe(Jump_exe),
        /* Branch Controller outputs */
        .BrUn_exe(BrUn_exe),
        .PcSrc_exe(PcSrc_exe),
        /* Forwarding and Hazard Detection Unit inputs */
        .rs1_id(rs1_id),
        .rs2_id(rs2_id),
        .rs1_exe(rs1_exe),
        .rs2_exe(rs2_exe),
        .rs2_mem(rs2_mem),
        .rd_mem(rd_mem),
        .rd_wb(rd_wb),
        .RegWen_mem(RegWen_mem),
        .RegWen_wb(RegWen_wb),
        .MemRead_exe(MemRead_exe),
        .rd_exe(rd_exe),
        /* Forwarding and Hazard Detection Unit outputs */
        .forward_rd1_id(forward_rd1_id),
        .forward_rd2_id(forward_rd2_id),
        .forward_rd1_exe(forward_rd1_exe),
        .forward_rd2_exe(forward_rd2_exe),
        .forward_rd2_mem(forward_rd2_mem),
        .Load_hazard_id(Load_hazard_id),
        .Branch_hazard_id(Branch_hazard_id)
    );


endmodule
