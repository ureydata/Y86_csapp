//=======================================================================
// Company            : 
// Filename           : .v
// Author             : Urey
// Created On         : 2022-05-26 12:27
// Last Modified      : 2022-05-26 13:45
// Description        : 
//                      
//                      
//=======================================================================

module INSTR_MEM
(
    //Input
    input       wire    [63:0]                  PC_i             ,     //
    //Output
    output      reg     [79:0]                  instr          ,     //
    output      wire                            imem_error
);
    reg [7:0] data [255:0]                           ;
    initial $readmemh("inst_test.txt", data)                   ;

    assign imem_error = (PC_i > 256)                             ;
    integer i                                                  ;

    always@(*)begin
        for(i = 0;i < 10;i = i + 1)         //ͨ�����ѭ�����Ͱ�instr[79:0] ��ȡ�����ˣ� fetch��ʱ��Ҫ��.
            instr[80-8*i-1-:8] = data[PC_i + i];//"-:8", ��˼��ǰ�������һֱ��1���ܹ�ȡ8 bits; ����i = 0, instr[79:72] = data[PC];i = 1, isntr[71:64] = data[PC + 1]...instr[7:0] = data[PC + 9]
    end

endmodule
