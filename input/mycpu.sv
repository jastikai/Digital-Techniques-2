`include "mycpu.svh"

import mycpu_pkg::*;

module mycpu
  (
   input logic 	       clk,
   input logic 	       rst_n,
   output logic [15:0] a_out, 
   input logic [15:0]  d_in,
   output logic [15:0] d_out,
   input logic [15:0]  io_in,
   output logic        wen_out,
   output logic        iom_out
   );

  logic [1:0]          ps; //program counter mode select
  logic                il; //instruction register load enable
  logic                mm; //MUXM select
  logic [1:0]          md; //MUXD select
  logic                mb; //MUXB select
  logic                rw; //register bank write enable
  logic [11:0]         rs; //register bank register select addresses
  logic [3:0]          fs; //function unit function select
  logic [15:0]         pca; //program counter memory address
  logic [15:0]         ins; //instruction register contents
  logic [15:0]         ia; //instruction register immediate branch address
  logic [15:0]         iv; //instruction register immediate value
  logic [15:0]         abus; //A bus: A output of register bank
  logic [15:0]         bdat; //B output of register bank
  logic [15:0]         bbus; //B bus: output of MUXB
  logic [15:0]         dbus; //D bus: output of MUXD and data input of register bank
  logic [15:0]         fbus; //F bus: function unit output data
  logic                z; //zero flag
  logic                n; //negative flag

  

  // instantiate blocks


  // control unit
  cu CU (.clk(clk),
         .rst_n(rst_n),
         .z_in(z),
         .n_in(n),
         .ins_in(ins),
         .wen_out(wen_out),
         .iom_out(iom_out),
         .ps_out(ps),
         .il_out(il),
         .mm_out(mm),
         .md_out(md),
         .mb_out(mb),
         .rw_out(rw),
         .rs_out(rs),
         .fs_out(fs)
        );

  // instruction register
  ir IR (.clk(clk),
         .rst_n(rst_n),
         .il_in(il),
         .ins_in(d_in),
         .ia_out(ia),
         .ins_out(ins),
         .iv_out(iv)
        );


  // program counter
  pc PC (.clk(clk),
         .rst_n(rst_n),
         .ps_in(ps),
         .ia_in(ia),
         .ra_in(abus),
         .pc_out(pca)
        );

  // function unit
  fu FU (.a_in(abus),
         .b_in(bbus),
         .fs_in(fs),
         .f_out(fbus),
         .z_out(z),
         .n_out(n)
        );

  // register bank
  rb RB (.clk(clk),
         .rst_n(rst_n),
         .d_in(dbus),
         .rw_in(rw),
         .rs_in(rs),
         .a_out(abus),
         .b_out(bdat)
        );

  // MUXM
  mux_2x16 MUXM (.sel_in(mm),
                 .d0_in(abus),
                 .d1_in(pca),
                 .m_out(a_out)
                );

  //MUXB
  mux_2x16 MUXB (.sel_in(mb),
                 .d0_in(bdat),
                 .d1_in(iv),
                 .m_out(bbus)
                );

  //MUXD
  mux_3x16 MUXD (.sel_in(md),
                 .d0_in(fbus),
                 .d1_in(d_in),
                 .d2_in(io_in),
                 .m_out(dbus)
                );
  
  assign d_out = bbus;
   

endmodule 
