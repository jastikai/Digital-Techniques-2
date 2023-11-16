`include "mycpu.svh"

import mycpu_pkg::*;

program rb_test
  (
   input logic 		 clk,
   input logic 		 rst_n,
   output logic [15:0] d_in,
   output logic 	 rw_in,
   output logic [11:0] 	 rs_in,
   input logic [15:0]  a_out,
   input logic [15:0]  b_out
   );

   logic [15:0] 	 patterns [16];
   integer               i,j,k;
   
   initial
     begin
	///////////////////////////////////////////////////////////////////////
	$info("T1: Reset Test");
	///////////////////////////////////////////////////////////////////////	
	d_in = '0;
	rw_in = '0;
	rs_in = '0;
	wait (rst_n);

	///////////////////////////////////////////////////////////////////////	
	$info("T2: Read-Write Test");
	///////////////////////////////////////////////////////////////////////

        for (i=0; i<15; i=i+1) begin
          patterns[i] = $urandom;
        end

        for (j=0; j<15; j=j+1) begin
          rs_in[11:8] = j;
          d_in = patterns[j];
          @ (posedge clk);
          rw_in = '1;
          @ (posedge clk);
          rw_in = '0;
        end

        for (k=0; k<15; k=k+1) begin
          rs_in[7:4] = k;
          rs_in[3:0] = k;
          @ (posedge clk);
          rw_in = '1;
          @ (negedge clk);
          assert(a_out == patterns[k]) else $error("T2: a_out value %16b not equal to written value of %16b of chosen register %4b", a_out, patterns[k], rs_in[7:4]);
          assert(b_out == patterns[k]) else $error("T2: b_out value %16b not equal to written value of %16b of chosen register %4b", a_out, patterns[k], rs_in[3:0]);
          @ (posedge clk);
          rw_in = '0;
        end
          
		     
	$finish;
     end
endprogram
