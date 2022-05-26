//=======================================================================
// Company            : 
// Filename           : .v
// Author             : Urey
// Created On         : 2022-05-26 11:32
// Last Modified      : 2022-05-26 12:26
// Description        : 
//                      
//                      
//=======================================================================

module FETCH
(
    //Input
    input               wire [63:0]                  PC_i                    ,
    //Output
    output              reg [3:0]                   icode                   , 
    output              reg [3:0]                   ifun                    ,
    output              reg [3:0]                   rA                      , 
    output              reg [3:0]                   rB                      , 
    output              reg [63:0]                  valC                    , 
    output              wire [63:0]                  valP                    , 
    output              wire                      instr_valid             , 
    output              wire                      imem_error               
 
);
    wire                [79:0]                  instr                   ;

    wire                                        need_regidis            ;
    wire                                        need_valC               ;

    //******指令内存取10个字节*******
    INSTR_MEM U_instruction_memory
    (
        .PC_i(PC_i),
        .instr(instr),
        .imem_error(imem_error)
    );
    
    //*******指令Split********
    always@(*) begin
        icode = instr[79:76];
        ifun  = instr[75:72];
    end

    assign instr_valid = (icode < 4'hC);
    
    //*******指令Align********
    assign need_regidis = ((icode ==4'h2)||(icode==4'h3)||(icode==4'h3)||(icode==4'h4)||(icode==4'h5)||(icode==4'h6)||(icode==4'hA)||(icode==4'hB));    // cmovxx, irmovq, rmmovq, mrmovq, opq, pushq, poqq
    assign need_valC =  ((icode ==4'h3)||(icode==4'h4)||(icode==4'h5)||(icode==4'h7)||(icode==4'h8));       // irmovq, rmmovq, mrmovq, jxx, call
    always@(*) begin
        if(need_regidis&&need_valC)begin
            rA = instr[71:68];
            rB = instr[67:64];
            valC = {instr[7:0], instr[15:8], instr[23:16], instr[31:24],instr[39:32],instr[47:40], instr[55:48], instr[63:56]};                         //按字节逆序取第2-9字节
        end
        else if(!need_regidis&&need_valC)
            valC = {instr[15:8], instr[23:16], instr[31:24],instr[39:32],instr[47:40], instr[55:48], instr[63:56], instr[71:64]};                       //按字节逆序取第1-8字节
        else begin
            rA = 4'hF;
            rB = 4'hF;
            valC = 64'h0;
        end

    end
    
    //*******PC增加********
    assign valP = PC_i + 64'h1 + (need_regidis ? 64'h1:64'h0) + (need_valC ? 64'h8:64'h0);



endmodule
