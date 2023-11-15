//////////////////////////////////////////      DMEM         //////////////////////////////////

// this module has only 1 address line input, so at max only we can read or write one location in 1 cycle time
// this module has asynchronous read but synchronous write
// this module has its own controller delivering the dmem control lines
// DMEM control lines are non other than the fun3 bits
// memory is word addressable

module DMEM #(
  parameter WIDTH = 32, DEPTH = 64
)(
  input wire [WIDTH-1:0] addr,         // 32 bit address line for the memory location - word addressable address*
  input wire MemWrite,
  input wire MemRead,
  input wire clk,
  input wire rst_n,
  input wire [WIDTH-1:0]Write_Data,
  input wire [2:0] control,
  output reg [WIDTH-1:0]Read_Data
);

reg [WIDTH-1:0] dmem [DEPTH-1:0];
int i;

/////////////// store //////////////
always @(posedge clk, negedge rst_n)
begin
if(!rst_n)  // DMEM is reset before use first time in test bench
begin
for(i = 0; i < DEPTH; i = i + 1)
begin
dmem[i][WIDTH-1:0] <= 'b0;
end
end
else if(MemWrite)
begin
case (control) // DMEM control lines specify the operation within the broader operation
                          // i.e within store operation, whether to store byte, halfword or word
3'b000: // sb
                          // the lower 2 bits of the address tells us the exact location (each location has 4 bytes) where to store the byte 
if(addr[1:0] == 0)       dmem[addr[WIDTH-1:2]][7:0] <= Write_Data[7:0];
else if(addr[1:0] == 1)  dmem[addr[WIDTH-1:2]][15:8] <= Write_Data[7:0];
else if(addr[1:0] == 2)  dmem[addr[WIDTH-1:2]][23:16] <= Write_Data[7:0];
else                     dmem[addr[WIDTH-1:2]][31:24] <= Write_Data[7:0];
3'b001: // sh
begin
                          // only the 1st bit of the address is needed for deciding where to store half word (on first 16 places or last 16 places)
if (addr[1]==0)          dmem[addr[WIDTH-1:2]][15:0]  <= Write_Data[15:0];
else                     dmem[addr[WIDTH-1:2]][31:16] <= Write_Data[15:0];
end    // sw
3'b010:                   // in case of store word, we have no option to select where to put data i.e all 4 bytes of a location will be used
begin
                         dmem[addr[WIDTH-1:2]][31:0] <= Write_Data[31:0];
end                
endcase
end
end

////////////// load //////////////

// in this case again for byte load we look for the last 2 bits, for halfword we look for the 1st bit
// and address-2 bits for load word.
// difference from store is that here we have registers size of 32 bits each wherease data loaded in registers 
// is less than word size, remaining is sign extended
// in case of unsigned load, RISC-V has seperate instruction for it
always @(*)
begin
  if(MemRead)
  begin
    case (control)
    3'b000: //lb
    if(addr[1:0] == 0)       Read_Data = {{24{dmem[addr[WIDTH-1:2]][7]}}, dmem[addr[WIDTH-1:2]][7:0]};
    else if(addr[1:0] == 1)  Read_Data = {{24{dmem[addr[WIDTH-1:2]][15]}}, dmem[addr[WIDTH-1:2]][15:8]};
    else if(addr[1:0] == 2)  Read_Data = {{24{dmem[addr[WIDTH-1:2]][23]}}, dmem[addr[WIDTH-1:2]][23:16]};
    else                     Read_Data = {{24{dmem[addr[WIDTH-1:2]][31]}}, dmem[addr[WIDTH-1:2]][31:24]};
    3'b001: //lh
    if (addr[1] == 0)        Read_Data = {{16{dmem[addr[WIDTH-1:2]][15]}}, dmem[addr[WIDTH-1:2]][15:0]};
    else                     Read_Data = {{16{dmem[addr[WIDTH-1:2]][31]}}, dmem[addr[WIDTH-1:2]][31:16]};
    3'b010: //lw
      Read_Data = {dmem[addr[WIDTH-1:2]][31:0]};
    3'b100: //lbu
    if(addr[1:0] == 0)      Read_Data = {{24{1'b0}}, dmem[addr[WIDTH-1:2]][7:0]};
    else if(addr[1:0] == 1) Read_Data = {{24{1'b0}}, dmem[addr[WIDTH-1:2]][15:8]};
    else if(addr[1:0] == 2) Read_Data = {{24{1'b0}}, dmem[addr[WIDTH-1:2]][23:16]};
    else                    Read_Data = {{24{1'b0}}, dmem[addr[WIDTH-1:2]][31:24]};
    3'b101: //lhu
    if (addr[1]==0) Read_Data = {{16{1'b0}}, dmem[addr[WIDTH-1:2]][15:0]};
    else            Read_Data = {{16{1'b0}}, dmem[addr[WIDTH-1:2]][31:16]};                
    default: Read_Data = 'b0;
    endcase
  end
  else
  begin
    Read_Data = 32'b0;
  end
end
endmodule

/////////////////////////////////////////////////////////////////////////////////////////////