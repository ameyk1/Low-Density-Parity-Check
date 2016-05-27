//////////////////////////////////////////////////////////////////////////////////
// Engineer: Amey Kulkarni
// Design Name:  LDPC decoder top module
// Module Name:  ldpc_decoder
// Project Name: Low Density Parity Check
////////////////////////////////////////////////////////////////////////////

/*
 *
 * \tparam BPS The number of bits per symbol or codeword
 * \tparam IBITS The number of integer bits per lambda value
 * \tparam FBITS The number of fractional bits per lambda value
 */

module ldpc_decoder #(
   parameter BPS = 12,
   parameter LAMBDA_IBITS = 3,
   parameter LAMBDA_FBITS = 3,
   parameter LAMBDA_NBITS = LAMBDA_IBITS + LAMBDA_FBITS
)(
   input wire clk,
   input wire lambda_valid,
   input wire [(BPS*LAMBDA_NBITS)-1:0] lambda,
   output wire [BPS-1:0] v_hat,
   output wire done
);

   localparam Z_NBITS = 8;

   reg [(BPS*LAMBDA_NBITS)-1:0] lambda_F;

   wire [5:0] c1_alpha1;
   wire [5:0] c1_alpha2;
   wire [5:0] c1_alpha3;
   wire [5:0] c1_alpha4;
   wire [5:0] c2_alpha1;
   wire [5:0] c2_alpha2;
   wire [5:0] c2_alpha3;
   wire [5:0] c2_alpha4;
   wire [5:0] c3_alpha1;
   wire [5:0] c3_alpha2;
   wire [5:0] c3_alpha3;
   wire [5:0] c3_alpha4;
   wire [5:0] c4_alpha1;
   wire [5:0] c4_alpha2;
   wire [5:0] c4_alpha3;
   wire [5:0] c4_alpha4;
   wire [5:0] c5_alpha1;
   wire [5:0] c5_alpha2;
   wire [5:0] c5_alpha3;
   wire [5:0] c5_alpha4;
   wire [5:0] c6_alpha1;
   wire [5:0] c6_alpha2;
   wire [5:0] c6_alpha3;
   wire [5:0] c6_alpha4;

   wire [5:0] v1_beta1;
   wire [5:0] v1_beta2;
   wire [5:0] v2_beta1;
   wire [5:0] v2_beta2;
   wire [5:0] v3_beta1;
   wire [5:0] v3_beta2;
   wire [5:0] v4_beta1;
   wire [5:0] v4_beta2;
   wire [5:0] v5_beta1;
   wire [5:0] v5_beta2;
   wire [5:0] v6_beta1;
   wire [5:0] v6_beta2;
   wire [5:0] v7_beta1;
   wire [5:0] v7_beta2;
   wire [5:0] v8_beta1;
   wire [5:0] v8_beta2;
   wire [5:0] v9_beta1;
   wire [5:0] v9_beta2;
   wire [5:0] v10_beta1;
   wire [5:0] v10_beta2;
   wire [5:0] v11_beta1;
   wire [5:0] v11_beta2;
   wire [5:0] v12_beta1;
   wire [5:0] v12_beta2;

   reg [5:0] v1_beta1_F;
   reg [5:0] v1_beta2_F;
   reg [5:0] v2_beta1_F;
   reg [5:0] v2_beta2_F;
   reg [5:0] v3_beta1_F;
   reg [5:0] v3_beta2_F;
   reg [5:0] v4_beta1_F;
   reg [5:0] v4_beta2_F;
   reg [5:0] v5_beta1_F;
   reg [5:0] v5_beta2_F;
   reg [5:0] v6_beta1_F;
   reg [5:0] v6_beta2_F;
   reg [5:0] v7_beta1_F;
   reg [5:0] v7_beta2_F;
   reg [5:0] v8_beta1_F;
   reg [5:0] v8_beta2_F;
   reg [5:0] v9_beta1_F;
   reg [5:0] v9_beta2_F;
   reg [5:0] v10_beta1_F;
   reg [5:0] v10_beta2_F;
   reg [5:0] v11_beta1_F;
   reg [5:0] v11_beta2_F;
   reg [5:0] v12_beta1_F;
   reg [5:0] v12_beta2_F;

   wire [(BPS*Z_NBITS)-1:0] z;

   wire [5:0] syndrome;

   always @(posedge clk) begin

      // Register the input lambda value.
      if (lambda_valid == 1'b1) begin
         lambda_F <= lambda;
         v1_beta1_F <= lambda[(LAMBDA_NBITS*12)-1:(LAMBDA_NBITS*11)];
         v1_beta2_F <= lambda[(LAMBDA_NBITS*12)-1:(LAMBDA_NBITS*11)];
         v2_beta1_F <= lambda[(LAMBDA_NBITS*11)-1:(LAMBDA_NBITS*10)];
         v2_beta2_F <= lambda[(LAMBDA_NBITS*11)-1:(LAMBDA_NBITS*10)];
         v3_beta1_F <= lambda[(LAMBDA_NBITS*10)-1:(LAMBDA_NBITS*9)];
         v3_beta2_F <= lambda[(LAMBDA_NBITS*10)-1:(LAMBDA_NBITS*9)];
         v4_beta1_F <= lambda[(LAMBDA_NBITS*9)-1:(LAMBDA_NBITS*8)];
         v4_beta2_F <= lambda[(LAMBDA_NBITS*9)-1:(LAMBDA_NBITS*8)];
         v5_beta1_F <= lambda[(LAMBDA_NBITS*8)-1:(LAMBDA_NBITS*7)];
         v5_beta2_F <= lambda[(LAMBDA_NBITS*8)-1:(LAMBDA_NBITS*7)];
         v6_beta1_F <= lambda[(LAMBDA_NBITS*7)-1:(LAMBDA_NBITS*6)];
         v6_beta2_F <= lambda[(LAMBDA_NBITS*7)-1:(LAMBDA_NBITS*6)];
         v7_beta1_F <= lambda[(LAMBDA_NBITS*6)-1:(LAMBDA_NBITS*5)];
         v7_beta2_F <= lambda[(LAMBDA_NBITS*6)-1:(LAMBDA_NBITS*5)];
         v8_beta1_F <= lambda[(LAMBDA_NBITS*5)-1:(LAMBDA_NBITS*4)];
         v8_beta2_F <= lambda[(LAMBDA_NBITS*5)-1:(LAMBDA_NBITS*4)];
         v9_beta1_F <= lambda[(LAMBDA_NBITS*4)-1:(LAMBDA_NBITS*3)];
         v9_beta2_F <= lambda[(LAMBDA_NBITS*4)-1:(LAMBDA_NBITS*3)];
         v10_beta1_F <= lambda[(LAMBDA_NBITS*3)-1:(LAMBDA_NBITS*2)];
         v10_beta2_F <= lambda[(LAMBDA_NBITS*3)-1:(LAMBDA_NBITS*2)];
         v11_beta1_F <= lambda[(LAMBDA_NBITS*2)-1:(LAMBDA_NBITS*1)];
         v11_beta2_F <= lambda[(LAMBDA_NBITS*2)-1:(LAMBDA_NBITS*1)];
         v12_beta1_F <= lambda[(LAMBDA_NBITS*1)-1:(LAMBDA_NBITS*0)];
         v12_beta2_F <= lambda[(LAMBDA_NBITS*1)-1:(LAMBDA_NBITS*0)];
      end

      else begin
         v1_beta1_F <= v1_beta1;
         v1_beta2_F <= v1_beta2;
         v2_beta1_F <= v2_beta1;
         v2_beta2_F <= v2_beta2;
         v3_beta1_F <= v3_beta1;
         v3_beta2_F <= v3_beta2;
         v4_beta1_F <= v4_beta1;
         v4_beta2_F <= v4_beta2;
         v5_beta1_F <= v5_beta1;
         v5_beta2_F <= v5_beta2;
         v6_beta1_F <= v6_beta1;
         v6_beta2_F <= v6_beta2;
         v7_beta1_F <= v7_beta1;
         v7_beta2_F <= v7_beta2;
         v8_beta1_F <= v8_beta1;
         v8_beta2_F <= v8_beta2;
         v9_beta1_F <= v9_beta1;
         v9_beta2_F <= v9_beta2;
         v10_beta1_F <= v10_beta1;
         v10_beta2_F <= v10_beta2;
         v11_beta1_F <= v11_beta1;
         v11_beta2_F <= v11_beta2;
         v12_beta1_F <= v12_beta1;
         v12_beta2_F <= v12_beta2;
      end

   end

   /****************************************************************************
    * Variable Nodes
    ***************************************************************************/

   variable_node v12 (
      .lambda (lambda_F[(LAMBDA_NBITS*1)-1:(LAMBDA_NBITS*0)]),
      .alpha1 (c4_alpha4),
      .alpha2 (c5_alpha4),
      .beta1  (v12_beta1),
      .beta2  (v12_beta2),
      .z      (z[(Z_NBITS*1)-1:(Z_NBITS*0)])
   );

   variable_node v11 (
      .lambda (lambda_F[(LAMBDA_NBITS*2)-1:(LAMBDA_NBITS*1)]),
      .alpha1 (c2_alpha4),
      .alpha2 (c3_alpha4),
      .beta1  (v11_beta1),
      .beta2  (v11_beta2),
      .z      (z[(Z_NBITS*2)-1:(Z_NBITS*1)])
   );

   variable_node v10 (
      .lambda (lambda_F[(LAMBDA_NBITS*3)-1:(LAMBDA_NBITS*2)]),
      .alpha1 (c1_alpha4),
      .alpha2 (c6_alpha4),
      .beta1  (v10_beta1),
      .beta2  (v10_beta2),
      .z      (z[(Z_NBITS*3)-1:(Z_NBITS*2)])
   );

   variable_node v9 (
      .lambda (lambda_F[(LAMBDA_NBITS*4)-1:(LAMBDA_NBITS*3)]),
      .alpha1 (c2_alpha3),
      .alpha2 (c6_alpha3),
      .beta1  (v9_beta1),
      .beta2  (v9_beta2),
      .z      (z[(Z_NBITS*4)-1:(Z_NBITS*3)])
   );

   variable_node v8 (
      .lambda (lambda_F[(LAMBDA_NBITS*5)-1:(LAMBDA_NBITS*4)]),
      .alpha1 (c1_alpha3),
      .alpha2 (c5_alpha3),
      .beta1  (v8_beta1),
      .beta2  (v8_beta2),
      .z      (z[(Z_NBITS*5)-1:(Z_NBITS*4)])
   );

   variable_node v7 (
      .lambda (lambda_F[(LAMBDA_NBITS*6)-1:(LAMBDA_NBITS*5)]),
      .alpha1 (c3_alpha3),
      .alpha2 (c4_alpha3),
      .beta1  (v7_beta1),
      .beta2  (v7_beta2),
      .z      (z[(Z_NBITS*6)-1:(Z_NBITS*5)])
   );

   variable_node v6 (
      .lambda (lambda_F[(LAMBDA_NBITS*7)-1:(LAMBDA_NBITS*6)]),
      .alpha1 (c3_alpha2),
      .alpha2 (c5_alpha2),
      .beta1  (v6_beta1),
      .beta2  (v6_beta2),
      .z      (z[(Z_NBITS*7)-1:(Z_NBITS*6)])
   );

   variable_node v5 (
      .lambda (lambda_F[(LAMBDA_NBITS*8)-1:(LAMBDA_NBITS*7)]),
      .alpha1 (c2_alpha2),
      .alpha2 (c4_alpha2),
      .beta1  (v5_beta1),
      .beta2  (v5_beta2),
      .z      (z[(Z_NBITS*8)-1:(Z_NBITS*7)])
   );

   variable_node v4 (
      .lambda (lambda_F[(LAMBDA_NBITS*9)-1:(LAMBDA_NBITS*8)]),
      .alpha1 (c1_alpha2),
      .alpha2 (c6_alpha2),
      .beta1  (v4_beta1),
      .beta2  (v4_beta2),
      .z      (z[(Z_NBITS*9)-1:(Z_NBITS*8)])
   );

   variable_node v3 (
      .lambda (lambda_F[(LAMBDA_NBITS*10)-1:(LAMBDA_NBITS*9)]),
      .alpha1 (c1_alpha1),
      .alpha2 (c4_alpha1),
      .beta1  (v3_beta1),
      .beta2  (v3_beta2),
      .z      (z[(Z_NBITS*10)-1:(Z_NBITS*9)])
   );

   variable_node v2 (
      .lambda (lambda_F[(LAMBDA_NBITS*11)-1:(LAMBDA_NBITS*10)]),
      .alpha1 (c3_alpha1),
      .alpha2 (c6_alpha1),
      .beta1  (v2_beta1),
      .beta2  (v2_beta2),
      .z      (z[(Z_NBITS*11)-1:(Z_NBITS*10)])
   );

   variable_node v1 (
      .lambda (lambda_F[(LAMBDA_NBITS*12)-1:(LAMBDA_NBITS*11)]),
      .alpha1 (c2_alpha1),
      .alpha2 (c5_alpha1),
      .beta1  (v1_beta1),
      .beta2  (v1_beta2),
      .z      (z[(Z_NBITS*12)-1:(Z_NBITS*11)])
   );

   /****************************************************************************
    * Check Nodes
    ***************************************************************************/

   check_node c6 (
      .beta1  (v2_beta2_F),
      .beta2  (v4_beta2_F),
      .beta3  (v9_beta2_F),
      .beta4  (v10_beta2_F),
      .alpha1 (c6_alpha1),
      .alpha2 (c6_alpha2),
      .alpha3 (c6_alpha3),
      .alpha4 (c6_alpha4)
   );

   check_node c5 (
      .beta1  (v1_beta2_F),
      .beta2  (v6_beta2_F),
      .beta3  (v8_beta2_F),
      .beta4  (v12_beta2_F),
      .alpha1 (c5_alpha1),
      .alpha2 (c5_alpha2),
      .alpha3 (c5_alpha3),
      .alpha4 (c5_alpha4)
   );

   check_node c4 (
      .beta1  (v3_beta2_F),
      .beta2  (v5_beta2_F),
      .beta3  (v7_beta2_F),
      .beta4  (v12_beta1_F),
      .alpha1 (c4_alpha1),
      .alpha2 (c4_alpha2),
      .alpha3 (c4_alpha3),
      .alpha4 (c4_alpha4)
   );

   check_node c3 (
      .beta1  (v2_beta1_F),
      .beta2  (v6_beta1_F),
      .beta3  (v7_beta1_F),
      .beta4  (v11_beta2_F),
      .alpha1 (c3_alpha1),
      .alpha2 (c3_alpha2),
      .alpha3 (c3_alpha3),
      .alpha4 (c3_alpha4)
   );

   check_node c2 (
      .beta1  (v1_beta1_F),
      .beta2  (v5_beta1_F),
      .beta3  (v9_beta1_F),
      .beta4  (v11_beta1_F),
      .alpha1 (c2_alpha1),
      .alpha2 (c2_alpha2),
      .alpha3 (c2_alpha3),
      .alpha4 (c2_alpha4)
   );

   check_node c1 (
      .beta1  (v3_beta1_F),
      .beta2  (v4_beta1_F),
      .beta3  (v8_beta1_F),
      .beta4  (v10_beta1_F),
      .alpha1 (c1_alpha1),
      .alpha2 (c1_alpha2),
      .alpha3 (c1_alpha3),
      .alpha4 (c1_alpha4)
   );

   /****************************************************************************
    * Code Estimator
    ***************************************************************************/

   code_estimator e (
      .z (z),
      .v_hat (v_hat)
   );

   /****************************************************************************
    * Syndrome Checker
    ***************************************************************************/

   syndrome_check s (
      .v_hat (v_hat),
      .syndrome (syndrome),
      .done (done)
   );

endmodule
