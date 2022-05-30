module fetch(
    PC    ,
    icode  ,
    ifun   ,
    rA     ,
    rB     ,
    valC   ,
    valP   ,
    instr_valid,
    imem_error
    );


    //�����źŶ���
    input  wire [63:0]           PC    ;

    //����źŶ���
    output reg [3:0]           icode   ;
    output reg [3:0]           ifun   ;
    output reg [3:0]           rA   ;
    output reg [3:0]           rB   ;
    output reg [63:0]           valC   ;
    output wire [63:0]          valP   ;
    output wire            instr_valid   ;
    output wire            imem_error   ;
    

    //�м��źŶ���
    wire        [79:0]          instr;
    wire                        need_regids;
    wire                        need_valC;


    //******ָ���ڴ�ȡ10���ֽ�*******
    instr_mem U_instruction_memory
    (
        .PC(PC),
        .instr(instr),
        .imem_error(imem_error)
    );
    
    //*******ָ��Split********
    always@(*) begin
        icode = instr[79:76];
        ifun  = instr[75:72];
    end

    assign instr_valid = (icode < 4'hC);
    
    //*******ָ��Align********
    assign need_regidis = ((icode ==4'h2)||(icode==4'h3)||(icode==4'h3)||(icode==4'h4)||(icode==4'h5)||(icode==4'h6)||(icode==4'hA)||(icode==4'hB));    // cmovxx, irmovq, rmmovq, mrmovq, opq, pushq, poqq
    assign need_valC =  ((icode ==4'h3)||(icode==4'h4)||(icode==4'h5)||(icode==4'h7)||(icode==4'h8));       // irmovq, rmmovq, mrmovq, jxx, call
    always@(*) begin
        if(need_regidis&&need_valC)begin
            rA = instr[71:68];
            rB = instr[67:64];
            valC = {instr[7:0], instr[15:8], instr[23:16], instr[31:24],instr[39:32],instr[47:40], instr[55:48], instr[63:56]};                         //���ֽ�����ȡ��2-9�ֽ�
        end
        else if(!need_regidis&&need_valC)
            valC = {instr[15:8], instr[23:16], instr[31:24],instr[39:32],instr[47:40], instr[55:48], instr[63:56], instr[71:64]};                       //���ֽ�����ȡ��1-8�ֽ�
        else begin
            rA = 4'hF;
            rB = 4'hF;
            valC = 64'h0;
        end

    end
    
    //*******PC����********
    assign valP = PC + 64'h1 + (need_regidis ? 64'h1:64'h0) + (need_valC ? 64'h8:64'h0);



endmodule
