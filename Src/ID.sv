module ID #(
    parameter RF_WIDTH = 32,
    parameter RF_DEPTH = 32
)(
    input wire clk,
    input wire rst_n,

    // instruction
    input wire [31:0] Inst_id,

    // immidiate unit input control signals
    input wire [2:0] ImmSel_id,

    // register file signals 
    input wire [4:0] rd_wb,
    input wire RegWen_wb,
    input wire [31:0] wdata_wb,
    input wire forward_rd1,
    input wire forward_rd2,

    // decoded instruction 
    output wire [6:0] opcode_id,
    output wire [4:0] rd_id,   
    output wire [2:0] fun3_id,
    output wire [4:0] rs1_id, 
    output wire [4:0] rs2_id,  
    output wire [6:0] fun7_id,

    // register file outputs
    output wire [31:0] rdata1_id,
    output wire [31:0] rdata2_id,

    // extended immidiate value
    output wire [31:0] Imm_id
);

    // Instantiate the Decompressor module to decompress the instruction first
    wire [31:0] Inst_id_uncompr;
    Decompressor Decompressor_inst (
        .Inst_In(Inst_id),
        .Inst_Out(Inst_id_uncompr)
    );


    //  After Decompressing the instruction, Decoding the Instruction here
    assign opcode_id = Inst_id_uncompr[ 6: 0];
    assign rd_id     = Inst_id_uncompr[11: 7];
    assign fun3_id   = Inst_id_uncompr[14:12];
    assign rs1_id    = Inst_id_uncompr[19:15];
    assign rs2_id    = Inst_id_uncompr[24:20];
    assign fun7_id   = Inst_id_uncompr[31:25];


    // After Decoding instruction and generating the control signals, passing those signals to register file
    wire [31:0] rdata1;
    wire [31:0] rdata2;
    RegFile #(
        .WIDTH(RF_WIDTH),
        .DEPTH(RF_DEPTH)
    ) RegFile_Dec (
        .clk(clk),
        .rst_n(rst_n),
        .RegWrite(RegWen_wb),
        .rs1(rs1_id),
        .rs2(rs2_id),
        .rd(rd_wb),
        .wd(wdata_wb),
        .rd1(rdata1),
        .rd2(rdata2)
    );

    // forwarding mux for rd1
    mux2to1 #(32) reg_file_rd1_mux (
        .sel(forward_rd1),
        .in0(rdata1),
        .in1(wdata_wb),
        .out(rdata1_id)
    );

    // forwarding mux for rd2
    mux2to1 #(32) reg_file_rd2_mux (
        .sel(forward_rd2),
        .in0(rdata2),
        .in1(wdata_wb),
        .out(rdata2_id)
    );    

  /*
   *
   */

// ------------------------ IMMIDIATE GENERATION LOGIC STARTS HERE ------------------------//
  
    // Instantiate the Immediate Generator module
    ImmGen ImmGen_Dec (
        .Inst(Inst_id_uncompr[31:7]),
        .ImmSel(ImmSel_id), // You may need to modify this depending on your design
        .Imm(Imm_id)
    );
// -------------------------- IMMIDIATE GENERATION LOGIC ENDS HERE ------------------------//   


endmodule
