//////////////////////////////////////////////////////////////////////////////////
// Engineer: Amey Kulkarni
// Design Name:  LDPC code computation
// Module Name:  code_estimator
// Project Name: Low Density Parity Check
/////////////////////////////////////////////////////////////////////////////

module code_estimator #(
   parameter BPS = 12,
   parameter Z_IBITS = 4,
   parameter Z_FBITS = 4,
   parameter Z_NBITS = Z_IBITS + Z_FBITS
)(
   input wire [(BPS*Z_NBITS)-1:0] z,
   output reg [BPS-1:0] v_hat
);

   integer i;

   always @(*) begin

      // If the value of z is greater than zero, the corresponding v_hat value
      // is 0; if the value of z is less than zero, the corresponding v_hat
      // value is 1. Therefore, the value of v_hat is simply the sign bit
      // of the corresponding z value.

      for (i = 0; i < BPS; i = i+1) begin
         v_hat[i] = z[(Z_NBITS * (i+1)) - 1];
      end

   end

endmodule
