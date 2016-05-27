//////////////////////////////////////////////////////////////////////////////////
// Engineer: Amey Kulkarni
// Design Name:  Node checker
// Module Name:  check_node
// Project Name: Low Density Parity Check
//////////////////////////////////////////////////////////////////////////////

module check_node (
   input wire [5:0] beta1,  // 3.3
   input wire [5:0] beta2,  // 3.3
   input wire [5:0] beta3,  // 3.3
   input wire [5:0] beta4,  // 3.3
   output reg [5:0] alpha1, // 2.4
   output reg [5:0] alpha2, // 2.4
   output reg [5:0] alpha3, // 2.4
   output reg [5:0] alpha4  // 2.4
);

   /****************************************************************************
    * Internal Signals
    ***************************************************************************/

   // Each of these are in 4.3 sign magnitude format.
   reg [6:0] beta1_sm;
   reg [6:0] beta2_sm;
   reg [6:0] beta3_sm;
   reg [6:0] beta4_sm;

   reg [6:0] alpha1_sm;
   reg [6:0] alpha2_sm;
   reg [6:0] alpha3_sm;
   reg [6:0] alpha4_sm;

   wire [6:0] comp_0_0_low;
   wire [1:0] comp_0_0_low_index;
   wire [6:0] comp_0_0_high;
   wire [1:0] comp_0_0_high_index;
   wire [6:0] comp_0_1_low;
   wire [1:0] comp_0_1_low_index;
   wire [6:0] comp_0_1_high;
   wire [1:0] comp_0_1_high_index;
   wire [6:0] comp_1_0_low;
   wire [1:0] comp_1_0_low_index;
   wire [6:0] comp_1_1_high;
   wire [1:0] comp_1_1_high_index;

   wire [6:0] min1;
   wire [1:0] min1_index;
   wire [6:0] min2;

   reg overall_sign;
   reg [3:0] signs;

   /****************************************************************************
    * Twos Complement to Sign Magnitude
    ***************************************************************************/

   always @(*) begin

      if (beta1[5] == 1'b0)
         beta1_sm = {beta1[5], beta1};
      else
         beta1_sm = {1'b1, ~beta1[5:0] + 1};

      if (beta2[5] == 1'b0)
         beta2_sm = {beta2[5], beta2};
      else
         beta2_sm = {1'b1, ~beta2[5:0] + 1};

      if (beta3[5] == 1'b0)
         beta3_sm = {beta3[5], beta3};
      else
         beta3_sm = {1'b1, ~beta3[5:0] + 1};

      if (beta4[5] == 1'b0)
         beta4_sm = {beta4[5], beta4};
      else
         beta4_sm = {1'b1, ~beta4[5:0] + 1};

   end

   /****************************************************************************
    * Comparators
    ***************************************************************************/

   check_node_comp comp_0_0 (
      .n1 (beta1_sm),
      .n1_index (2'd0),
      .n2 (beta2_sm),
      .n2_index (2'd1),
      .low (comp_0_0_low),
      .low_index (comp_0_0_low_index),
      .high (comp_0_0_high),
      .high_index (comp_0_0_high_index)
   );

   check_node_comp comp_0_1 (
      .n1 (beta3_sm),
      .n1_index (2'd2),
      .n2 (beta4_sm),
      .n2_index (2'd3),
      .low (comp_0_1_low),
      .low_index (comp_0_1_low_index),
      .high (comp_0_1_high),
      .high_index (comp_0_1_high_index)
   );

   check_node_comp comp_1_0 (
      .n1 (comp_0_0_high),
      .n1_index (comp_0_0_high_index),
      .n2 (comp_0_1_high),
      .n2_index (comp_0_1_high_index),
      .low (comp_1_0_low),
      .low_index (comp_1_0_low_index),
      .high (),
      .high_index ()
   );

   check_node_comp comp_1_1 (
      .n1 (comp_0_0_low),
      .n1_index (comp_0_0_low_index),
      .n2 (comp_0_1_low),
      .n2_index (comp_0_1_low_index),
      .low (min1),
      .low_index (min1_index),
      .high (comp_1_1_high),
      .high_index (comp_1_1_high_index)
   );

   check_node_comp comp_2_0 (
      .n1 (comp_1_0_low),
      .n1_index (comp_1_0_low_index),
      .n2 (comp_1_1_high),
      .n2_index (comp_1_1_high_index),
      .low (min2)
   );

   /****************************************************************************
    * Sign Calculation
    ***************************************************************************/

   always @(*) begin

      overall_sign = beta1[5] ^ beta2[5] ^ beta3[5] ^ beta4[5];

      signs[0] = overall_sign ^ beta1[5];
      signs[1] = overall_sign ^ beta2[5];
      signs[2] = overall_sign ^ beta3[5];
      signs[3] = overall_sign ^ beta4[5];

   end

   /****************************************************************************
    * Alpha Calculation
    ***************************************************************************/

   always @(*) begin

      if (min1_index != 0)
         alpha1_sm = {signs[0], min1[5:0]};
      else
         alpha1_sm = {signs[0], min2[5:0]};

      if (min1_index != 1)
         alpha2_sm = {signs[1], min1[5:0]};
      else
         alpha2_sm = {signs[1], min2[5:0]};

      if (min1_index != 2)
         alpha3_sm = {signs[2], min1[5:0]};
      else
         alpha3_sm = {signs[2], min2[5:0]};

      if (min1_index != 3)
         alpha4_sm = {signs[3], min1[5:0]};
      else
         alpha4_sm = {signs[3], min2[5:0]};

   end

   /****************************************************************************
    * Sign Magnitude to Twos Complement
    ***************************************************************************/

   always @(*) begin

      if (alpha1_sm[6] == 1'b0)
         alpha1 = alpha1_sm;
      else
         alpha1 = ~alpha1_sm + 1;

      if (alpha2_sm[6] == 1'b0)
         alpha2 = alpha2_sm;
      else
         alpha2 = ~alpha2_sm + 1;

      if (alpha3_sm[6] == 1'b0)
         alpha3 = alpha3_sm;
      else
         alpha3 = ~alpha3_sm + 1;

      if (alpha4_sm[6] == 1'b0)
         alpha4 = alpha4_sm;
      else
         alpha4 = ~alpha4_sm + 1;

   end

endmodule
