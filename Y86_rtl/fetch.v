`include "define.v"
module fetch(
    PC_i,
    icode_o,
    ifun_o,
    rA_o,
    rB_o,
    valC_o,
    valP_o,
    instr_valid_o,
    imem_error_o
);


    //input signal
    input  wire [63:0]      PC_i;

    //output signal
    output reg [3:0]        icode_o;
    output reg [3:0]        ifun_o;
    output reg [3:0]        rA_o;
    output reg [3:0]        rB_o;
    output reg [63:0]       valC_o;
    output wire[63:0]       valP_o;
    output wire             instr_valid_o;
    output wire             imem_error_o;
    

    //intermediate signal
    reg    [7:0]            instr_mem[0:255];
    reg    [79:0]           instr;
    wire                    need_regids;
    wire                    need_valC;


    //pick up 10 bytes from instruction memory
    assign imem_error_o = (PC_i > 255);

    always@(*)begin

        instr={instr_mem[PC_i + 0],
               instr_mem[PC_i + 1],
               instr_mem[PC_i + 2],
               instr_mem[PC_i + 3],
               instr_mem[PC_i + 4],
               instr_mem[PC_i + 5],
               instr_mem[PC_i + 6],
               instr_mem[PC_i + 7],
               instr_mem[PC_i + 8],
               instr_mem[PC_i + 9]};
    end
    
    //instruction Split
    always@(*) begin
        icode_o = instr[79:76];
        ifun_o  = instr[75:72];
    end

    assign instr_valid_o = (icode_o < 4'hC);
    
    //instruction Align
    assign need_regidis  = (icode_o == `ICMOVQ)  || (icode_o == `IIRMOVQ) ||
                           (icode_o == `IRMMOVQ) || (icode_o == `IMRMOVQ) ||
                           (icode_o == `IOPQ)    || (icode_o == `IPUSHQ)  ||
                           (icode_o == `IPOPQ);

    assign need_valC =  (icode_o == `IIRMOVQ) || (icode_o == `IRMMOVQ) ||
                        (icode_o == `IMRMOVQ) || (icode_o == `IJXX)    || 
                        (icode_o == `ICALL); 

    always@(*) begin
        if(need_regidis)begin

            rA_o   = instr[71:68];
            rB_o   = instr[67:64];

            //Little Endian
            valC_o = {instr[`BYTE9], instr[`BYTE8],
                      instr[`BYTE7], instr[`BYTE6],
                      instr[`BYTE5], instr[`BYTE4],
                      instr[`BYTE3], instr[`BYTE2]};                         
        end

        else begin

            rA_o   = `RNONE;
            rB_o   = `RNONE;
            valC_o = {instr[`BYTE8], instr[`BYTE7],
                      instr[`BYTE6], instr[`BYTE5],
                      instr[`BYTE4], instr[`BYTE3],
                      instr[`BYTE2], instr[`BYTE1]};
        end
    end
    
    //PC increment
    assign valP_o = PC_i + 64'h1 + (need_regidis ? 64'h1:64'h0) + (need_valC ? 64'h8:64'h0);


    //Instruction memory
    initial begin

        //irmovq $0x9, %rdx
        instr_mem[0]=8'h30; //3 0
        instr_mem[1]=8'hf2; //F rB=2
        instr_mem[2]=8'h09;           
        instr_mem[3]=8'h00;           
        instr_mem[4]=8'h00;           
        instr_mem[5]=8'h00;           
        instr_mem[6]=8'h00;           
        instr_mem[7]=8'h00;           
        instr_mem[8]=8'h00;          
        instr_mem[9]=8'h00; //V=9

        //irmovq $0x21, %rbx
        instr_mem[10]=8'h30; //3 0
        instr_mem[11]=8'hf3; //F rB=3
        instr_mem[12]=8'h15;           
        instr_mem[13]=8'h00;           
        instr_mem[14]=8'h00;           
        instr_mem[15]=8'h00;           
        instr_mem[16]=8'h00;           
        instr_mem[17]=8'h00;           
        instr_mem[18]=8'h00;          
        instr_mem[19]=8'h00; //V=21

        //sub %rdx, %rbx
        instr_mem[20]=8'h61; //6 1
        instr_mem[21]=8'h23; // rB=2 rB=3

        //irmovq $128, %rsp
        instr_mem[22]=8'h30;           
        instr_mem[23]=8'hF4;           
        instr_mem[24]=8'h80;           
        instr_mem[25]=8'h00;           
        instr_mem[26]=8'h00;          
        instr_mem[27]=8'h00;           
        instr_mem[28]=8'h00;
        instr_mem[29]=8'h00;           
        instr_mem[30]=8'h00;                   
        instr_mem[31]=8'h00; //V=128

        //rmmovq %rsp, 100(%rbx)
        instr_mem[32]=8'h40; //4 0
        instr_mem[33]=8'h43; // rA=4 rB=3
        instr_mem[34]=8'h64; 
        instr_mem[35]=8'h00;           
        instr_mem[36]=8'h00;          
        instr_mem[37]=8'h00;           
        instr_mem[38]=8'h00;
        instr_mem[39]=8'h00;           
        instr_mem[40]=8'h00;                   
        instr_mem[41]=8'h00; //V=100 

        // push %rdx 
        instr_mem[42]=8'ha0; //a 0
        instr_mem[43]=8'h2f; //rA=2 rB=f

        // push %rdx 
        instr_mem[44]=8'hb0; //b 0
        instr_mem[45]=8'h0f; //rA=0 rB=f

        // je done 
        instr_mem[46]=8'h73; //7 3
        instr_mem[47]=8'h40;           
        instr_mem[48]=8'h00;          
        instr_mem[49]=8'h00;           
        instr_mem[50]=8'h00;
        instr_mem[51]=8'h00;           
        instr_mem[52]=8'h00;                   
        instr_mem[53]=8'h00;   
        instr_mem[54]=8'h00; //V=64 

        // call proc 
        instr_mem[55]=8'h80; //8 0
        instr_mem[56]=8'h41;           
        instr_mem[57]=8'h00;          
        instr_mem[58]=8'h00;           
        instr_mem[59]=8'h00;
        instr_mem[60]=8'h00;           
        instr_mem[61]=8'h00;                   
        instr_mem[62]=8'h00;   
        instr_mem[63]=8'h00; //V=65

        // done: halt
        instr_mem[64]=8'h00; //0 0 

        // done: halt
        instr_mem[65]=8'h90; //9 0
         // check:instr_error
        instr_mem[66]=8'hc0; //c 0       
    end

    



endmodule
