`timescale 1 ns / 1 ps
`include "define.v" 
module cpu_top_tb;

reg  sys_clk,rst_n;

initial begin
    sys_clk    = 1;
    rst_n      = 0;
    #1 rst_n = 1;
    #839 rst_n = 0;
    #1 rst_n = 1;
end

always   #30 sys_clk = ~sys_clk;

cpu_top cpu
(
  .clk(sys_clk),
  .rst_n(rst_n)
);


endmodule
