`timescale 1ps/1ps

module execute_tb;

    reg clk;
    reg rst_n;
    reg [3:0] icode;
    reg [3:0] ifun;
    reg signed [63:0] valA;
    reg signed [63:0] valB;
    reg signed [63:0] valC;

    wire signed [63:0] valE;

    wire Cnd; 

    execute exe(
    .clk_i(clk),
    .rst_n_i(rst_n),
    .icode_i(icode),
    .ifun_i(ifun),
    .valA_i(valA),
    .valB_i(valB),
    .valC_i(valC),
    .valE_o(valE),
    .Cnd_o(Cnd)
    );
    initial begin

// "30_f2_00_01_00_00_00_00_00_00" irmovq $0x100,%rbx # %rbx <-- 0x100      
        rst_n = 0; 
        icode = 4'h3;
        ifun  = 0;
        valA  = 10;
        valB  = 20;
        valC  = 100;
        clk = 1; #10;
        clk = ~clk; #10;
        $display("clk=%d rst_n=%d icode=%d ifun=%d valA=%d valB=%d valC=%d valE=%d  Cnd=%d\n",clk,rst_n,icode,ifun,valA,valB,valC,valE,Cnd);
// "a0_2f" pushq %rbx
        rst_n = 1; 
        icode = 4'ha;
        ifun  = 0;
        valA  = 0;
        valB  = 208;
        valC  = 0;
        clk = 1; #10;
        clk = ~clk; #10;
        $display("clk=%d rst_n=%d icode=%d ifun=%d valA=%d valB=%d valC=%d valE=%d  Cnd=%d\n",clk,rst_n,icode,ifun,valA,valB,valC,valE,Cnd);

// "60_23" addq %rdx,%rbx # %rbx <-- 0x300 CC <-- 000 
        rst_n = 1; 
        icode = 6;
        ifun  = 0;
        valA  = 200; 
        valB  = 100;
        valC  = 0;
        clk = 1; #10;
        clk = ~clk; #10;
        $display("clk=%d rst_n=%d icode=%d ifun=%d valA=%d valB=%d valC=%d valE=%d  Cnd=%d\n",clk,rst_n,icode,ifun,valA,valB,valC,valE,Cnd);


//"73_00"je dest # Not taken 
        rst_n = 1; 
        icode = 7;
        ifun  = 3;
        valA  = 0; 
        valB  = 0;
        valC  = 40;
        clk = 1; #10;
        clk = ~clk; #10;
        $display("clk=%d rst_n=%d icode=%d ifun=%d valA=%d valB=%d valC=%d valE=%d  Cnd=%d\n",clk,rst_n,icode,ifun,valA,valB,valC,valE,Cnd);


// "61_23" subq %rdx,%rbx # %rbx <-- 0x0 CC <-- 100 
        rst_n = 1; 
        icode = 6;
        ifun  = 1;
        valA  = 200; 
        valB  = 200;
        valC  = 0;
        clk = 1; #10;
        clk = ~clk; #10;
        $display("clk=%d rst_n=%d icode=%d ifun=%d valA=%d valB=%d valC=%d valE=%d  Cnd=%d\n",clk,rst_n,icode,ifun,valA,valB,valC,valE,Cnd);


//"73_00"je dest #jump   
        rst_n = 1; 
        icode = 7;
        ifun  = 3;
        valA  = 0; 
        valB  = 0;
        valC  = 40;
        clk = 1; #10;
        clk = ~clk; #10;
        $display("clk=%d rst_n=%d icode=%d ifun=%d valA=%d valB=%d valC=%d valE=%d  Cnd=%d\n",clk,rst_n,icode,ifun,valA,valB,valC,valE,Cnd);


//24_12 rrmovq <--  0x60 
        rst_n = 1; 
        icode = 2;
        ifun  = 4;
        valA  = 60; 
        valB  = 50;
        valC  = 0;
        clk = 1; #10;
        clk = ~clk; #10;
        $display("clk=%d rst_n=%d icode=%d ifun=%d valA=%d valB=%d valC=%d valE=%d  Cnd=%d\n",clk,rst_n,icode,ifun,valA,valB,valC,valE,Cnd);

//20_12 cmovne <--  0x20
        rst_n = 1; 
        icode = 2;
        ifun  = 0;
        valA  = 20; 
        valB  = 40;
        valC  = 0;
        clk = 1; #10;
        clk = ~clk; #10;
        $display("clk=%d rst_n=%d icode=%d ifun=%d valA=%d valB=%d valC=%d valE=%d  Cnd=%d\n",clk,rst_n,icode,ifun,valA,valB,valC,valE,Cnd);        

    end

endmodule
