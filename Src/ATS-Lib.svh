// ATS Library 
// Library contains 
// - Registers 
// 
//==============================================================

// Registers in the ATS Library

// Register wihout reset
module register_wo_rst #( parameter WIDTH=1 )
   (
     input logic [WIDTH-1:0] din,
     input logic           clk,
     
     output logic [WIDTH-1:0] dout
     );

   always_ff @( posedge clk ) begin
      dout[WIDTH-1:0] <= din[WIDTH-1:0];
   end

endmodule

// Register with asynchronous reset
module register_async_rst #( parameter WIDTH=1 )
   (
     input logic [WIDTH-1:0] din,
     input logic           clk,
     input logic                   rst_l,

     output logic [WIDTH-1:0] dout
     );

   always_ff @(posedge clk or negedge rst_l) begin
      if (rst_l == 0)
        dout[WIDTH-1:0] <= 0;
      else
        dout[WIDTH-1:0] <= din[WIDTH-1:0];
   end

endmodule

// Registers with synchronous reset
module register_sync_rst #( parameter WIDTH=1 )
   (
     input logic [WIDTH-1:0] din,
     input logic           clk,
     input logic                   rst_l,

     output logic [WIDTH-1:0] dout
     );

   always_ff @( posedge clk ) begin
      if (rst_l == 0)
        dout[WIDTH-1:0] <= 0;
      else
        dout[WIDTH-1:0] <= din[WIDTH-1:0];
   end

endmodule


// register  with input enable signal
module register_w_enable #( parameter WIDTH=1 )
   (
     input logic [WIDTH-1:0] din,
     input logic             en,   
     input logic           clk,
     input logic           rst_l,
     output logic [WIDTH-1:0] dout
     );

   logic [WIDTH-1:0]          din_new;

   assign din_new = (en ? din[WIDTH-1:0] : dout[WIDTH-1:0]);
  
   always_ff @(posedge clk or negedge rst_l) begin
      if (rst_l == 0)
        dout[WIDTH-1:0] <= 0;
      else
        dout[WIDTH-1:0] <= din_new[WIDTH-1:0];
   end

endmodule


