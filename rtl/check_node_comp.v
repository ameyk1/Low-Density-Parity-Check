//////////////////////////////////////////////////////////////////////////////////
// Engineer: Amey Kulkarni
// Design Name:  LDPC node computation
// Module Name:  check_node_comp
// Project Name: Low Density Parity Check
/////////////////////////////////////////////////////////////////////////////

module check_node_comp (
   input wire [6:0] n1,
   input wire [1:0] n1_index,
   input wire [6:0] n2,
   input wire [1:0] n2_index,
   output reg [6:0] low,
   output reg [1:0] low_index,
   output reg [6:0] high,
   output reg [1:0] high_index
);

   always @(*) begin

      if (n1[5:0] < n2[5:0]) begin
         low = n1;
         low_index = n1_index;
         high = n2;
         high_index = n2_index;
      end

      else begin
         low = n2;
         low_index = n2_index;
         high = n1;
         high_index = n1_index;
      end

   end

endmodule
