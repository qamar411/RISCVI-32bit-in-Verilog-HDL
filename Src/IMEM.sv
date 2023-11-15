///////////////////////////////////////// IMEM //////////////////////////////////////////////

// IMEM is the ROM memory
// this memory has 1 address port and 1 instruction comes out at a time
// this IMEM block is designed such that always 32 bits are extracted whether instruction there is compressed or not
// this keeps our IMEM simple
// logic for selecting the 32 bits within IMEM is catered here based on the 1st bit of the instruction
// in case 1st bit is 1, it means that we have 16 bits of the 32 bit I type instruction in one location and 
// other 16 bits on the next location 

module IMEM #(parameter WIDTH = 32, DEPTH = 256) (addr, instr,misaligned_addr); // ROM

    input logic [WIDTH-1:0]   addr;
    output logic [WIDTH-1:0]  instr;
    output logic misaligned_addr;

    // instruction memory of size DEPTH * WIDTH
    logic [WIDTH-1:0]imem[0:DEPTH-1];

    // on the basis of the 1st bit of the address, it will be decided whether the instruction to be 
    // fetched is complete 32 bits on single location or half from one and half from other location
    assign instr = addr[1] ? {imem[addr[31:2]+1][15:0], imem[addr[31:2]][31:16]} : imem[addr[31:2]][31:0];
    assign misaligned_addr = addr[0];
endmodule

/////////////////////////////////////////////////////////////////////////////////////////////