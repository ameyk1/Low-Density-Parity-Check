//////////////////////////////////////////////////////////////////////////////////
// Engineer: Amey Kulkarni
// Design Name:  LDPC variable node
// Module Name:  variable_node
// Project Name: Low Density Parity Check
/////////////////////////////////////////////////////////////////////////////////

module variable_node (
   input wire [5:0] lambda, // 3.3
   input wire [5:0] alpha1, // 3.3
   input wire [5:0] alpha2, // 3.3
   output reg [5:0] beta1,  // 3.3
   output reg [5:0] beta2,  // 3.3
   output reg [7:0] z       // 5.3
);

   reg [6:0] sum_alpha; // 4.3

   reg [8:0] beta1_int; // 6.3
   reg [8:0] beta2_int; // 6.3

   always @(*) begin

      // 4.3 = 3.3 + 3.3
      sum_alpha = {alpha1[5], alpha1} + {alpha2[5], alpha2};

      // 5.3 = 4.3 + 3.3
      z = {sum_alpha[6], sum_alpha} + {{2{lambda[5]}}, lambda};

      // 6.3 = 5.3 - 3.3
      beta1_int = {z[7], z} - {{3{alpha1[5]}}, alpha1};
      beta2_int = {z[7], z} - {{3{alpha2[5]}}, alpha2};

      // Saturate the beta signals, 6.3 to 3.3.
      if ($signed(beta1_int) > $signed(8'b00011111))
         beta1 = 6'b011111;
      else if ($signed(beta1_int) < $signed(8'b11100000))
         beta1 = 6'b100000;
      else
         beta1 = beta1_int[5:0];

      if ($signed(beta2_int) > $signed(8'b00011111))
         beta2 = 6'b011111;
      else if ($signed(beta2_int) < $signed(8'b11100000))
         beta2 = 6'b100000;
      else
         beta2 = beta2_int[5:0];

   end

endmodule
