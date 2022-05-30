module cpu_top(
  input  wire  clk,
  input  wire  rst_n
);

wire  imem_error; //指令地址超界
wire  instr_valid; //指令无效
wire  dmem_error; //数据地址超界
wire  [3:0]icode; //指令code 半字节
wire  [3:0]ifun;  //功能code 半字节
wire  [3:0]rA;    //寄存器读端口A地址 半字节
wire  [3:0]rB;    //寄存器读端口B地址 半字节
wire  [63:0]valC;  //常数 8字节
wire  [63:0]valP;  //下一阶段PC可能计数值
wire  [63:0]PC;    //当前PC计数

wire  [63:0]valA;  //寄存器读端口A数据 8字节
wire  [63:0]valB;  //寄存器读端口B数据 8字节
wire        stat;  //CPU 状态信号
wire  [63:0]valE;  //ALU执行输出数据
wire  [63:0]valM;  //数据存储器读数据  8字节
wire  Cnd; //条件转移有效信号




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
