module data_mem(
    clk    ,
    rst_n  ,
    mem_read,
    mem_write,
    mem_addr,
    mem_data,
    valM,
    dmem_error
    );

    //输入信号定义
    input               clk    ;
    input               rst_n  ;
    input   wire        mem_read;    
    input   wire        mem_write;    
    input   wire[63:0]  mem_addr;
    input   wire[63:0]  mem_data;
    //输出信号定义
    output reg[63:0]  valM   ;
    output wire       dmem_error   ;
    //中间信号定义
    reg   [7:0]  data[0:256]   ;

    assign dmem_error = (mem_addr > 256);

    //读数据内存
    always@(*)begin
        if(mem_read)
            valM = {data[mem_addr+7],data[mem_addr+6],data[mem_addr+5],data[mem_addr+4],data[mem_addr+3],data[mem_addr+2],data[mem_addr+1],data[mem_addr]};//小端法，字节逆序
    end

    //写数据内存
    integer i;
    always@(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            for(i = 0; i < 256;i=i+1)
                data[i] <= 0;
        end
        else if(mem_write)begin
           {data[mem_addr+7],data[mem_addr+6],data[mem_addr+5],data[mem_addr+4],data[mem_addr+3],data[mem_addr+2],data[mem_addr+1],data[mem_addr]} <=  mem_data;//小端法，字节逆序
        end
    end

    endmodule

