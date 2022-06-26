`include "define.v"
module cpu_top(
  clk,
  rst_n
);

input  wire  clk;
input  wire  rst_n;

wire  imem_error; 
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
wire  [3:0]Stat;
wire  Cnd; //条件转移有效信号



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
