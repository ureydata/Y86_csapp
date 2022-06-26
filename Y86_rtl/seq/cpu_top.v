`include "define.v"
module cpu_top(
  clk,
  rst_n
);

input  wire  clk;
input  wire  rst_n;

wire  imem_error; 
wire  instr_valid; //ָ����Ч
wire  dmem_error; //���ݵ�ַ����
wire  [3:0]icode; //ָ��code ���ֽ�
wire  [3:0]ifun;  //����code ���ֽ�
wire  [3:0]rA;    //�Ĵ������˿�A��ַ ���ֽ�
wire  [3:0]rB;    //�Ĵ������˿�B��ַ ���ֽ�
wire  [63:0]valC;  //���� 8�ֽ�
wire  [63:0]valP;  //��һ�׶�PC���ܼ���ֵ
wire  [63:0]PC;    //��ǰPC����

wire  [63:0]valA;  //�Ĵ������˿�A���� 8�ֽ�
wire  [63:0]valB;  //�Ĵ������˿�B���� 8�ֽ�
wire        stat;  //CPU ״̬�ź�
wire  [63:0]valE;  //ALUִ���������
wire  [63:0]valM;  //���ݴ洢��������  8�ֽ�
wire  [3:0]Stat;
wire  Cnd; //����ת����Ч�ź�



fetch f1(
    .PC_i(PC),
    .icode_o(icode),
    .ifun_o(ifun),
    .rA_o(rA),
    .rB_o(rB),
    .valC_o(valC),
    .valP_o(valP),
    .instr_valid_o(instr_valid),
    .imem_error_o(imem_error)
);
deco_writeback_reg d1(
    .icode_i(icode),
    .rA_i(rA),
    .rB_i(rB),
    .valA_o(valA),
    .valB_o(valB),
    .clk_i(clk),
    .rst_n_i(rst_n),
    .valE_i(valE),
    .valM_i(valM),
    .Cnd_i(Cnd)
);

execute e1(
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

new_pc np1(
    .clk_i(clk),
    .rst_n_i(rst_n),
    .icode_i(icode),
    .Cnd_i(Cnd),
    .valC_i(valC),
    .valM_i(valM),
    .valP_i(valP),
    .PC_o(PC)
);
endmodule
