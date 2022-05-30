module decode_reg(
clk    ,
rst_n  ,
Cnd    ,
icode  ,
rA     ,
rB     ,
valA   ,
valB   ,
valE   ,
valM
);

//输入信号定义
input               clk    ;
input               rst_n  ;
input   wire          Cnd  ;
input   wire[3:0]   icode     ;
input   wire[3:0]   rA     ;
input   wire[3:0]   rB     ;
input   wire [63:0]  valE   ;
input   wire [63:0]  valM   ;


//输出信号定义
output   reg [63:0]  valA   ;
output   reg [63:0]  valB   ;


//中间信号定义
reg      [3:0]       srcA;
reg      [3:0]       srcB;
reg      [3:0]       dstE;
reg      [3:0]       dstM;

//组合逻辑写法
always@(*)begin
    case(icode)
        4'h0:begin                              //halt
            srcA = 4'hF;
            srcB = 4'hF;
            dstE = 4'hF;
            dstM = 4'hF;
        end

        4'h1:begin                               //nop
            srcA = 4'hF;
            srcB = 4'hF;
            dstE = 4'hF;
            dstM = 4'hF;
        end
        4'h2:begin                              //cmovq
            srcA = rA;
            srcB = rB;
            dstE = Cnd?rB:4'hF;
            dstM = 4'hF;
        end
        4'h3:begin                              //irmovq
            srcA = rA;
            srcB = rB;
            dstE = rB;
            dstM = 4'hF;
        end
        4'h4:begin                              //rmmovq
            srcA = rA;
            srcB = rB;
            dstE = 4'hF;
            dstM = 4'hF;
        end
        4'h5:begin                             //mrmovq 
            srcA = rA;
            srcB = rB;
            dstE = 4'hF;
            dstM = rA;
        end
        4'h6:begin                            //opq
            srcA = rA;
            srcB = rB;
            dstE = rB;
            dstM = 4'hF;
        end
        4'h7:begin                              //jxxx
            srcA = 4'hF;
            srcB = 4'hF;
            dstE = 4'hF;
            dstM = 4'hF;
        end
        4'h8:begin                              //ret
            srcA = 4'hF;
            srcB = 4'h4;
            dstE = 4'h4;
            dstM = 4'hF;
        end
        4'h9:begin
            srcA = 4'h4;                        //call
            srcB = 4'h4;
            dstE = 4'h4;
            dstM = 4'hF;
        end
        4'hA:begin
            srcA = rA;                          //pushq
            srcB = 4'h4;
            dstE = 4'h4;
            dstM = 4'hF;
        end
        4'hB:begin                              //popq
            srcA = 4'h4;
            srcB = 4'h4;
            dstE = 4'h4;
            dstM = rA;
        end
        default:begin
            srcA = 4'hF;
            srcB = 4'hF;
            dstE = 4'hF;
            dstM = 4'hF;
        end
    endcase


end

//register_file
reg [63:0] regs[0:15];

always @(*) begin               //读寄存器文件
    if(srcA !=4'hF )
        valA = regs[srcA];
    else
        valA = 64'h0;
    if(srcB != 4'hF)
        valB = regs[srcB];
    else
        valB = 64'h0;
end



integer i;
always@(posedge clk or negedge rst_n)begin          //写寄存器文件
if(rst_n==1'b0)begin
    for(i=0;i<16;i= i+1)
        regs[i] <= 0;
end
else begin
    if(dstE !=4'hF) begin
        regs[dstE] <= valE;
    end
    if(dstM !=4'hF) begin
        regs[dstM] <= valM;
    end
end
end

endmodule

