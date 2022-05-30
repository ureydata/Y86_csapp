module new_pc(
    clk    ,
    rst_n  ,
    icode  ,
    Cnd    ,
    valC   ,
    valM   ,
    valP   ,
    PC
    );


    //输入信号定义
    input                   clk    ;
    input                   rst_n  ;
    input   wire[3:0]       icode  ;
    input   wire            Cnd    ;
    input   wire[63:0]      valC   ;
    input   wire[63:0]      valM   ;
    input   wire[63:0]      valP   ;


    //输出信号定义
    output  reg[63:0]       PC   ;
    wire                    stat;

    //PC的更新
    always@(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)
            PC <= 0;

        else if(stat == 1'h1) begin
            if (icode == 0)
                PC <= PC;
            else if(icode == 4'h7)
                PC <= Cnd? valC : valP;
            else if(icode == 4'h8)
                PC<= valC;
            else if(icode == 4'h9)
                PC<= valM;
            else
                PC <= valP;
        end

    end

    endmodule

