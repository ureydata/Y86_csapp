`timescale 1ns/1ps
`include "define.v"
module mem_access_tb;

    reg         clk;
    reg         instr_valid;
    reg         imem_error;
    reg  [3:0]  icode;
    reg  [63:0] valA, valE, valP;
    wire [63:0] valM;
    wire [3:0]  Stat;

    mem_access m1(
    .icode_i(icode),
    .valE_i(valE),
    .valA_i(valA),
    .valP_i(valP),
    .instr_valid_i(instr_valid),
    .imem_error_i(imem_error),
    .clk_i(clk),
    .valM_o(valM),
    .Stat_o(Stat)
);

    initial begin
// "40_43_64_00000000000000" rmmovq %rsp, 100(%rbx)     128(64'h80) -->M8[112]  
        icode = 4'h4;
        valE  = 112;
        valA  = 64'h80;
        valP  = 64'h2a;
        instr_valid = 1;
        imem_error  = 0;
        clk = 1; #10;
        clk = ~clk; #10;


// "50_43_64_00000000000000" mrmovq %rdx,100(%rbx)  M8[112] >--  128(64'h80)
        icode = 4'h5;
        valE  = 112;
        valA  = 0;
        valP  = 0;
        instr_valid = 1;
        imem_error  = 0;
        clk = 1; #10;
        clk = ~clk; #10;

// "80_41_00000000000000" call 0x041     64(64'h40) -->M8[120]  
        icode = 4'h8;
        valE  = 120;
        valA  = 0;
        valP  = 64'h40;
        instr_valid = 1;
        imem_error  = 0;
        clk = 1; #10;
        clk = ~clk; #10;

// "90"       ret     M8[120] >-- 64(64'h40)  Stat = 1
        icode = 4'h9;
        valE  = 128;
        valA  = 120;
        valP  = 64'h42;
        instr_valid = 1;
        imem_error  = 0;
        clk = 1; #10;
        clk = ~clk; #10;

// "00"                   halt,  Stat = 2
        icode = 4'h0;
        valE  = 0;
        valA  = 0;
        valP  = 64'h0;
        instr_valid = 1;
        imem_error  = 0;
        clk = 1; #10;
        clk = ~clk; #10;

// "90"       ret     M8[1024] >-- XXXXXX  data memory error, Stat = 3
        icode = 4'h9;
        valE  = 128;
        valA  = 1024;
        valP  = 64'h42;
        instr_valid = 1;
        imem_error  = 0;
        clk = 1; #10;
        clk = ~clk; #10;

// "90"       ret     M8[120] >-- 64(64'h40) instr memory error , Stat = 3
        icode = 4'h9;
        valE  = 128;
        valA  = 120;
        valP  = 64'h42;
        instr_valid = 1;
        imem_error  = 1;
        clk = 1; #10;
        clk = ~clk; #10;

// "c0"                   invalid instr,    Stat = 4  
        icode = 4'hc;
        valE  = 0;
        valA  = 0;
        valP  = 0;
        instr_valid = 0;
        imem_error  = 0;
        clk = 1; #10;
        clk = ~clk; #10;

    end
          
    initial
        $monitor("%d \t %d\n", valM, Stat);    
                    


endmodule
