module Control_Logic (
    
    // Decode control inputs 
    input wire [4:0] opcode_id,
    // Decode Control Signals 
    output wire RegWen_id, 
    output wire ASel_id, 
    output wire BSel_id, 
    output wire MemWrite_id, 
    output wire MemRead_id, 
    output wire [1:0] WBSel_id, 
    output wire [2:0] ImmSel_id,
    output wire [1:0] ALUop_id, 
    output wire Branch_id, 
    output wire Jump_id, 


    // ALU Controller inputs 
    input wire [1:0] ALUop_exe,
    input wire fun7_0_exe,
    input wire fun7_5_exe,
    input wire [2:0] fun3_exe,
    // ALU Controller outputs
    output wire [3:0] ALUCtrl,


    // Branch Controller inputs
    input wire BrEq_exe,
    input wire BrLt_exe,
    input wire Branch_exe,
    input wire Jump_exe,
    // Branch Controller outputs
    output wire BrUn_exe,
    output wire PcSrc_exe,


    // Forwarding and Hazard Detion Unit inputs
    input wire [4:0] rs1_id,
    input wire [4:0] rs2_id,
    input wire [4:0] rs1_exe,
    input wire [4:0] rs2_exe,
    input wire [4:0] rs2_mem,
    input wire [4:0] rd_mem,
    input wire [4:0] rd_wb,
    input wire RegWen_mem,
    input wire RegWen_wb,
    input wire MemRead_exe,
    input wire [4:0] rd_exe,    
    // Forwarding and Hazard Detion Unit outputs
    output wire       forward_rd1_id,
    output wire       forward_rd2_id,
    output wire [1:0] forward_rd1_exe,
    output wire [1:0] forward_rd2_exe,
    output wire       forward_rd2_mem,
    output wire       Load_hazard_id,
    output wire       Branch_hazard_id


);

    // After Decoding the instruction, Generating Control Signals here
    wire exe_use_rs1_id;
    wire exe_use_rs2_id;
    Dec_Control Decode_Control_inst (
        .opcode(opcode_id),
        .RegWen(RegWen_id),
        .ASel(ASel_id),
        .BSel(BSel_id),
        .exe_use_rs1(exe_use_rs1_id),
        .exe_use_rs2(exe_use_rs2_id),
        .MemWrite(MemWrite_id),
        .MemRead(MemRead_id),
        .WBSel(WBSel_id),
        .ImmSel(ImmSel_id),
        .ALUop(ALUop_id),
        .Branch(Branch_id),
        .Jump(Jump_id)
    );



    // Instantiate the ALU Control module
    ALU_Control ALU_Control_inst (
        .ALUOp(ALUop_exe),
        .func3(fun3_exe),
        .func7_0(fun7_0_exe), // You may need to modify this depending on your design
        .func7_5(fun7_5_exe), // You may need to modify this depending on your design
        .ALUCtrl(ALUCtrl)
    );

    // Instantiate branch_controller module
    branch_controller branch_controller_inst (
        .Branch(Branch_exe),      
        .Jump(Jump_exe),         
        .beq(BrEq_exe),          
        .blt(BrLt_exe),          
        .fun3(fun3_exe),         
        .PcSrc(PcSrc_exe), 
        .BrUn(BrUn_exe)    
    );


     // Instantiate Hazard_Controller module
  Hazard_Controller hazard_controller_inst (
    .PcSrc_exe(PcSrc_exe),          
    .exe_use_rs1_id(exe_use_rs1_id), 
    .exe_use_rs2_id(exe_use_rs2_id), 
    .rs1_id(rs1_id),               
    .rs2_id(rs2_id),               
    .MemRead_exe(MemRead_exe),    
    .rd_exe(rd_exe),            
    .Load_hazard(Load_hazard_id), 
    .Branch_hazard(Branch_hazard_id) 
  );

  // Instantiate Forwarding_Unit module
  Forwarding_Unit forwarding_unit_inst (
    .rs1_id(rs1_id),           // 
    .rs2_id(rs2_id),           // 
    .rs1_exe(rs1_exe),         // 
    .rs2_exe(rs2_exe),         // 
    .rs2_mem(rs2_mem),         // 
    .rd_mem(rd_mem),           // 
    .rd_wb(rd_wb),             // 
    .RegWen_mem(RegWen_mem),   // 
    .RegWen_wb(RegWen_wb),     // 
    .forward_rd1_id(forward_rd1_id), // 
    .forward_rd2_id(forward_rd2_id), // 
    .forward_rd1_exe(forward_rd1_exe), // 
    .forward_rd2_exe(forward_rd2_exe), //
    .forward_rd2_mem(forward_rd2_mem)  //
  );



endmodule