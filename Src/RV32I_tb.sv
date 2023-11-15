`include "defines.svh"

module RV32I_tb;
reg clk ,rst_n;

//Instantiate Top Level processor module
RV32I dut(
	.clk(clk),
	.rst_n(!rst_n)
	);

reg [`RV_DMEM_WIDTH-1:0] ref_dmem [`RV_DMEM_DEPTH-1:0];
reg [`RV_RF_WIDTH-1:0] ref_regfile [`RV_RF_DEPTH-1:0];
reg [4:0]  RF_mismatch = 0;
reg [31:0] MEM_mismatch = 0;


initial
begin
	clk=1;
	rst_n = 1;

	#20

	rst_n = 0;
	$readmemh("../R_Type/R_type_initial_MEM.s", dut.MEM_inst.DMEM_mem.dmem); // initializing the DMEM here 
	$readmemh("../R_Type/R_type_register_initial.s", dut.ID_inst.RegFile_Dec.regfile); // initializing the Register file here	
	$readmemh("../R_Type/R_type_final_MEM.s",ref_dmem ); // saving the final memory of true reference design in reference memory
	$readmemh("../R_Type/R_type_register_final.s", ref_regfile); // saving the final register file content of true reference design in reference regfile

	// ------------ Start of Simulation --------------------
	$display($time, " PC value = %d", dut.pc_current_if);

	for(integer i = 0; i < 32; i++)
	begin
		$display("Value of register %d = %d", i, dut.ID_inst.RegFile_Dec.regfile[i]);
	end

	#10000

	// ------------ End of Simulation --------------------
	$display($time, " PC value = %d", dut.pc_current_if);

	for(integer i = 0; i < 32; i++)
	begin
		$display("Value of register %d = %d", i, dut.ID_inst.RegFile_Dec.regfile[i]);
	end

	// Automatically testing by matching the content of Register File and Data memory with there required values.
	$display ("");
	$display ("");	
	$display ("************************************************************");
	$display ("********* Starting Register File Content Matching ... ******");
	$display ("************************************************************");
	$display ("");
	$display ("");
	for(integer i = 0; i < 32; i++)
	begin
		if(dut.ID_inst.RegFile_Dec.regfile[i] != ref_regfile[i])
		begin
		$display("Error... RegFile[%d] = %d is not equal to Ref_RegFile[%d] = %d", i, dut.ID_inst.RegFile_Dec.regfile[i],i,ref_regfile[i]);
		RF_mismatch = RF_mismatch + 1;
		end
		else
		$display("Success... RegFile[%d] = %d is equal to Ref_RegFile[%d] = %d", i, dut.ID_inst.RegFile_Dec.regfile[i],i,ref_regfile[i]);
		
	end
	$display ("");
	$display ("");
    if(RF_mismatch == 0)
	begin
		$display ("************************************************************");
		$display ("********************** RF Test Passed **********************");
		$display ("************************************************************");
	end
	else
		begin
		$display ("************************************************************");
		$display ("********************** RF Test Failed **********************");
		$display ("************************************************************");

	end
	$display ("");
	$display ("");
	$display ("************************************************************");
	$display ("************ Starting Memory Content Matching ... **********");
	$display ("************************************************************");
	$display ("");
	$display ("");

	for(integer i = 0; i < `RV_DMEM_DEPTH; i++)
	begin
		if(dut.MEM_inst.DMEM_mem.dmem[i] != ref_dmem[i])
		begin
		$display("Error... DMEM[%d] = %d is not equal to Ref_DMEM[%d] = %d", i, dut.MEM_inst.DMEM_mem.dmem[i],i,ref_dmem[i]);
		RF_mismatch = RF_mismatch + 1;
		end
		else
		begin
		$display("Success... DMEM[%d] = %d is equal to Ref_DMEM[%d] = %d", i, dut.MEM_inst.DMEM_mem.dmem[i],i,ref_dmem[i]);
		end
	end
	$display ("");
	$display ("");
    if(MEM_mismatch == 0)
	begin
		$display ("************************************************************");
		$display ("********************* MEM Test Passed **********************");
		$display ("************************************************************");
	end
	else
		begin
		$display ("************************************************************");
		$display ("********************* MEM Test Failed **********************");
		$display ("************************************************************");
	end	

end

// Copying Instruction Machine codes to IMEM
initial 
begin
	$readmemh("../R_Type/R_type_machine.s", dut.IF_inst.IMEM_.imem);		
end

// Clock will toggle iff DMEM last entry is not equal to 32'hFE23
// whenever this value is written at last location of DMEM, clk will go zero
// PC will not further increment
always
begin
	#10;
	if (dut.MEM_inst.DMEM_mem.dmem[`RV_DMEM_DEPTH-1] != 32'hFE23) clk = ~clk;
	else clk = 0;
end


// $fwrite to write to a file in case we need HEX file directly 
// Good idea in image processing tasks!



endmodule
