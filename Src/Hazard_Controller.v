module Hazard_Controller (
    input wire PcSrc_exe,
    input wire exe_use_rs1_id,
    input wire exe_use_rs2_id,
    input wire [4:0] rs1_id,
    input wire [4:0] rs2_id,
    input wire MemRead_exe,
    input wire [4:0] rd_exe,

    output wire Load_hazard,
    output wire Branch_hazard
);

    assign Branch_hazard = PcSrc_exe;
    assign Load_hazard   =   (MemRead_exe  &  (rd_exe !=0)) 
                         &   (((rd_exe === rs1_id) & exe_use_rs1_id) | ((rd_exe === rs2_id) & exe_use_rs2_id));

endmodule