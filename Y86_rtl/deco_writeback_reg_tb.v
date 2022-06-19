`timescale 1ns/1ps
`include "define.v"
module deco_writeback_reg_tb;
    reg clk;
    reg Cnd;
    reg [3:0] icode;
    reg [3:0] rA, rB;
    reg [63:0] valE, valM;
    wire [63:0] valA, valB;


    deco_writeback_reg m1(
    .icode_i(icode),
    .rA_i(rA),
    .rB_i(rB),
    .valA_o(valA),
    .valB_o(valB),
    .clk_i(clk),
    .valE_i(valE),
    .valM_i(valM),
    .Cnd_i(Cnd)
);


    initial begin
// 30f20100000000000000     irmovq $1, %rdx  1 -->%rdx
        clk = 1; #10;
        clk = ~clk; #10;
        icode = 4'h3;
        rA  = 4'hf;
        rB  = 4'h2;
        valE  = 64'h1;
        valM = 0;
        Cnd  = 0;
        clk = 1; #10;
        clk = ~clk; #10; 
        $display("%d\t%d\n", valA, valB); 



// 30f30200000000000000     irmovq $2, %rbx 2 -->%rbx

        icode = 4'h3;
        rA  = 4'hf;
        rB  = 4'h3;
        valE  = 64'h2;
        valM = 0;
        Cnd  = 0;
        clk = 1; #10;
        clk = ~clk; #10;
        $display("%d\t%d\n", valA, valB); 

// 6023                     addq %rdx, %rbx 3 -->%rbx

        icode = 4'h6;
        rA  = 4'h2;
        rB  = 4'h3;
        valE  = 64'h3;
        valM = 0;
        Cnd  = 0;
        clk = 1; #10;
        clk = ~clk; #10;        
        $display("%d\t%d\n", valA, valB); 
// 2160                      cmovle %rsi,%rax, Cnd = 1
        
        icode = 4'h2;
        rA  = 4'h6;
        rB  = 4'h0;
        valE  = 64'h4;
        valM = 0;
        Cnd  = 1;
        clk = 1; #10;
        clk = ~clk; #10;
        clk = 1; #10;
        clk = ~clk; #10;        
        $display("%d\t%d\n", valA, valB);         
// 2170                      cmovle %rdi,%rax, Cnd = 0

        icode = 4'h2;
        rA  = 4'h7;
        rB  = 4'h0;
        valE  = 64'h5;
        valM = 0;
        Cnd  = 0;
        clk = 1; #10;
        clk = ~clk; #10;        
        $display("%d\t%d\n", valA, valB); 
// 2004                      rrmovq %r8, %rsp

        icode = 4'h2;
        rA  = 4'h8;
        rB  = 4'h4;
        valE  = 64'h123;
        valM = 0;
        Cnd  = 1;
        clk = 1; #10;
        clk = ~clk; #10;        
        $display("%d\t%d\n", valA, valB); 
// 2034                      rrmovq %r9, %rsp

        icode = 4'h2;
        rA  = 4'h9;
        rB  = 4'h4;
        valE  = 64'h456;
        valM = 0;
        Cnd  = 1;
        clk = 1; #10;
        clk = ~clk; #10;        
        $display("%d\t%d\n", valA, valB); 
    end
          

endmodule
