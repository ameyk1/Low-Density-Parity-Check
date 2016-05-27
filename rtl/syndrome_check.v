//////////////////////////////////////////////////////////////////////////////////
// Engineer: Amey Kulkarni
// Design Name:  LDPC syndrome checker
// Module Name:  syndrome_check
// Project Name: Low Density Parity Check
//////////////////////////////////////////////////////////////////////////////////

module syndrome_check (
   input wire [11:0] v_hat,
   output reg [5:0] syndrome,
   output reg done
);

   reg [0:11] v_hat_rev;

   always @(*) begin

      v_hat_rev = v_hat;

      syndrome[0] = v_hat_rev[2] ^ v_hat_rev[3] ^ v_hat_rev[7] ^ v_hat_rev[9];
      syndrome[1] = v_hat_rev[0] ^ v_hat_rev[4] ^ v_hat_rev[8] ^ v_hat_rev[10];
      syndrome[2] = v_hat_rev[1] ^ v_hat_rev[5] ^ v_hat_rev[6] ^ v_hat_rev[10];
      syndrome[3] = v_hat_rev[2] ^ v_hat_rev[4] ^ v_hat_rev[6] ^ v_hat_rev[11];
      syndrome[4] = v_hat_rev[0] ^ v_hat_rev[5] ^ v_hat_rev[7] ^ v_hat_rev[11];
      syndrome[5] = v_hat_rev[1] ^ v_hat_rev[3] ^ v_hat_rev[8] ^ v_hat_rev[9];

      done = ~|syndrome;

   end

endmodule
