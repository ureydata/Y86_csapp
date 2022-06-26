`include "define.v"
module fetch(
    PC_i,
    icode_o,
    ifun_o,
    rA_o,
    rB_o,
    valC_o,
    valP_o,
    instr_valid_o,
    imem_error_o
);


    //input signal
    input  wire [63:0]      PC_i;

    //output signal
    output reg [3:0]        icode_o;
    output reg [3:0]        ifun_o;
    output reg [3:0]        rA_o;
    output reg [3:0]        rB_o;
    output reg [63:0]       valC_o;
    output wire[63:0]       valP_o;
    output wire             instr_valid_o;
    output wire             imem_error_o;


    //intermediate signal
    reg    [7:0]            instr_mem[0:1023];
    reg    [79:0]           instr;
    wire                    need_regids;
    wire                    need_valC;


    //pick up 10 bytes from instruction memory
    assign imem_error_o = (PC_i > 1023);

    always@(*)begin

        instr={instr_mem[PC_i + 0],
               instr_mem[PC_i + 1],
               instr_mem[PC_i + 2],
               instr_mem[PC_i + 3],
               instr_mem[PC_i + 4],
               instr_mem[PC_i + 5],
               instr_mem[PC_i + 6],
               instr_mem[PC_i + 7],
               instr_mem[PC_i + 8],
               instr_mem[PC_i + 9]};
    end

    //instruction Split
    always@(*) begin
        icode_o = instr[79:76];
        ifun_o  = instr[75:72];
    end

    assign instr_valid_o = (icode_o < 4'hC);

    //instruction Align
    assign need_regidis  = (icode_o == `ICMOVQ)  || (icode_o == `IIRMOVQ) ||
                           (icode_o == `IRMMOVQ) || (icode_o == `IMRMOVQ) ||
                           (icode_o == `IOPQ)    || (icode_o == `IPUSHQ)  ||
                           (icode_o == `IPOPQ);

    assign need_valC =  (icode_o == `IIRMOVQ) || (icode_o == `IRMMOVQ) ||
                        (icode_o == `IMRMOVQ) || (icode_o == `IJXX)    || 
                        (icode_o == `ICALL); 

    always@(*) begin
        if(need_regidis)begin

            rA_o   = instr[71:68];
            rB_o   = instr[67:64];

            //Little Endian
            valC_o = {instr[`BYTE9], instr[`BYTE8],
                      instr[`BYTE7], instr[`BYTE6],
                      instr[`BYTE5], instr[`BYTE4],
                      instr[`BYTE3], instr[`BYTE2]};                         
        end

        else begin

            rA_o   = `RNONE;
            rB_o   = `RNONE;
            valC_o = {instr[`BYTE8], instr[`BYTE7],
                      instr[`BYTE6], instr[`BYTE5],
                      instr[`BYTE4], instr[`BYTE3],
                      instr[`BYTE2], instr[`BYTE1]};
        end
    end

    //PC increment
    assign valP_o = PC_i + 64'h1 + (need_regidis ? 64'h1:64'h0) + (need_valC ? 64'h8:64'h0);


    //Instruction memory
    initial  $readmemh ("D:/00_IC design/2_csapp/y86/Y86_rtl/code_f17.txt",instr_mem);
    

endmodule
