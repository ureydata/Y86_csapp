module cpu_top(
  input  wire  clk,
  input  wire  rst_n
);

wire  imem_error; //ָ���ַ����
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
wire  Cnd; //����ת����Ч�ź�




fetch U_fetch(
    .PC(PC)    ,
    .icode(icode)  ,
    .ifun(ifun)   ,
    .rA(rA)     ,
    .rB(rB)     ,
    .valC(valC)   ,
    .valP(valP)   ,
    .instr_valid(instr_valid),
    .imem_error(imem_error)
    );



decode_reg U_decode_reg(
    .clk(clk)    ,
    .rst_n(rst_n)  ,
    .Cnd(Cnd)    ,
    .icode(icode)  ,
    .rA(rA)     ,
    .rB(rB)     ,
    .valA(valA)   ,
    .valB(valB)   ,
    .valE(valE)   ,
    .valM(valM)
    );    

execute U_execute(
    .clk(clk)    ,
    .rst_n(rst_n)  ,
    .icode(icode)  ,
    .ifun(ifun)   ,
    .valA(valA)   ,
    .valB(valB)   ,
    .valC(valC)   ,
    .valE(valE)   ,
    .Cnd(Cnd)
    );

mem_access U_mem_access(
    .clk(clk)    ,
    .rst_n(rst_n)  ,
    .icode(icode)   ,
    .valE(valE)   ,
    .valA(valA)   ,
    .valP(valP)   ,
    .valM(valM)   ,
    .dmem_error(dmem_error)
    );



new_pc U_new_pc(
    .clk(clk)    ,
    .rst_n(rst_n)  ,
    .icode(icode)  ,
    .Cnd(Cnd)    ,
    .valC(valC)   ,
    .valM(valM)   ,
    .valP(valP)   ,
    .PC(PC)
    );

endmodule
