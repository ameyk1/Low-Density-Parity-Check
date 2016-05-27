`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Engineer: Amey Kulkarni
// Design Name:  LDPC testbench
// Module Name:  tb
// Project Name: Low Density Parity Check
////////////////////////////////////////////////////////////////////////////////

module tb;

   reg clk;

   reg lambda_valid;
   reg [(12*6)-1:0] lambda;
   wire [11:0] v_hat;
   wire done;

   integer i;

   ldpc_decoder dut (
      .clk (clk),
      .lambda_valid (lambda_valid),
      .lambda (lambda),
      .v_hat (v_hat),
      .done (done)
   );

   initial begin
      clk = 1'b0;
      forever #10 clk = ~clk;
   end

   initial begin

      repeat (1) @(posedge clk);

      lambda = {
         6'b111100,
         6'b010100,
         6'b101001,
         6'b001110,
         6'b111010,
         6'b111111,
         6'b110101,
         6'b001010,
         6'b010000,
         6'b001010,
         6'b101111,
         6'b001100
      };

      lambda_valid = 1'b1;

      repeat (1) @(posedge clk);

      lambda_valid = 1'b0;

      for (i = 0; i < 5; i = i+1) begin
         repeat (1) @(posedge clk);
         $display("v_hat = %0b\n", v_hat);
      end

      $finish;

   end

endmodule
