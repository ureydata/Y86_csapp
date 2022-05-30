//�Ĵ�����д�ز��ּ�decode_regfile.v������ֻ��Ҫ�ж�������
module stat(
    icode  ,
    instr_valid  ,
    imem_error,
    dmem_error,
    stat
    );

    //�����źŶ���
    input    wire[3:0]       icode    ;
    input    wire       instr_valid  ;
    input    wire       imem_error  ;
    input    wire       dmem_error  ;
    //����źŶ���
    output  reg       stat   ;

    always  @(*)begin
        if(imem_error|dmem_error)
            stat = 1'h2;
        else if(!instr_valid)
            stat = 1'h3;
        else if(icode == 4'h0)
            stat = 1'h4;
        else
            stat = 1'h1;
    end

    endmodule

