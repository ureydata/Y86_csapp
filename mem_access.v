module mem_access(
    clk    ,
    rst_n  ,
    icode   ,
    valE   ,
    valA   ,
    valP   ,
    valM   ,
    dmem_error
    );

    //输入信号定义
    input               clk    ;
    input               rst_n  ;
    input   wire[3:0]   icode  ;
    input   wire[63:0]  valE   ;
    input   wire[63:0]  valA   ;
    input   wire[63:0]  valP   ;

    //输出信号定义
    output   reg[63:0]  valM   ;
    output   wire       dmem_error   ;

    //中间信号定义
    reg         mem_read        ;
    reg         mem_write       ;
    reg   [63:0]mem_data        ;
    reg   [63:0]mem_addr        ;    

    //组合逻辑写法
    always@(*)begin
        case(icode)
            4'h4:begin
                mem_read = 1'b0;
                mem_write = 1'b1;
                mem_data  = valA;
                mem_addr  = valE;
            end
            4'h5:begin
                mem_read = 1'b1;
                mem_write = 1'b0;
                mem_data = 64'h0;
                mem_addr = valE;
            end
            4'h8:begin
                mem_read = 1'b0;
                mem_write =1'b1;
                mem_data = valP;
                mem_addr = valE;
            end
            4'h9:begin
                mem_read = 1'b1;
                mem_write = 1'b0;
                mem_data = 64'h0;
                mem_addr = valA;                
            end
            4'hA:begin
                mem_read = 1'b0;
                mem_write =1'b1;
                mem_data = valA;
                mem_addr = valE;
            end
            4'hB:begin
                mem_read = 1'b1;
                mem_write = 1'b0;
                mem_data = 64'h0;
                mem_addr = valA;
            end
            default:begin
                mem_read = 1'b0;
                mem_write = 1'b0;
                mem_data = 64'h0;
                mem_addr = 64'h0;
            end


        endcase

    end

//数据内存读取数据

data_mem u_data_mem(
    .clk(clk)    ,
    .rst_n(rst_n)  ,
    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_addr(mem_addr),
    .mem_data(mem_data),
    .valM(valM),
    .dmem_error(dm_error)
    );

    endmodule

