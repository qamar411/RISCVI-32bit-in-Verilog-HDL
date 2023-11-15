// ********************* Program Counter **************************// 
/* Designed by Qamar Moavia
*/

module PC(
    input wire clk,
    input wire rst_n,
    input wire en,
    input  wire [31:0] pc_next,
    output wire [31:0] pc_current
    );

    // instantiating regsiter with write enable
    register_w_enable #(32) Pc(
        .din(pc_next),
        .en(en),
        .clk(clk),
        .rst_l(rst_n),
        .dout(pc_current)
    );
    
endmodule

// ********************* Program Counter Ends *********************//