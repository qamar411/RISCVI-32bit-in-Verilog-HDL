`include "defines.svh"

module RV32I_tb;
reg clk ,rst_n;

//Instantiate Top Level processor module
RV32I dut(
	.clk(clk),
	.rst_n(!rst_n)
	);

initial
begin
	clk=1;
	rst_n = 1;

	#20

	rst_n = 0;
	$readmemh("DMEM.s", dut.MEM_inst.DMEM_mem.dmem); // used in 4x4 matrix multiplication	
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
end

// Copying Instruction Machine codes to IMEM
initial 
begin
	$readmemh("IMEM.s", dut.IF_inst.IMEM_.imem);		
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
