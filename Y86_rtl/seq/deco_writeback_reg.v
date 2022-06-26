`include "define.v"
module deco_writeback_reg(
    icode_i,
    rA_i,
    rB_i,
    valA_o,
    valB_o,
    clk_i,
    rst_n_i,
    valE_i,
    valM_i,
    Cnd_i
);

    //input signal

    input   wire[3:0]   icode_i;
    input   wire[3:0]   rA_i;
    input   wire[3:0]   rB_i;
    input               clk_i;
    input               rst_n_i;
    input   wire[63:0]  valE_i;
    input   wire[63:0]  valM_i;
    input   wire        Cnd_i;

    //output signal
    output  reg [63:0]  valA_o;
    output  reg [63:0]  valB_o;

    //intermediate signal
    reg      [3:0]       srcA;
    reg      [3:0]       srcB;
    reg      [3:0]       dstE;
    reg      [3:0]       dstM;

    //Control logic blocks
    always@(*)begin
        case(icode_i)
            `IHALT:  begin      
                srcA = `RNONE;
                srcB = `RNONE;
                dstE = `RNONE;
                dstM = `RNONE;
            end

            `INOP:   begin       
                srcA = `RNONE;
                srcB = `RNONE;
                dstE = `RNONE;
                dstM = `RNONE;
            end

            //conditional write back to register rB
            `ICMOVQ: begin      
                srcA = rA_i;
                srcB = rB_i;
                dstE = Cnd_i ? rB_i :`RNONE;
                dstM = `RNONE;
            end
            `IIRMOVQ:begin      
                srcA = rA_i;
                srcB = rB_i;
                dstE = rB_i;
                dstM = `RNONE;
            end
            `IRMMOVQ:begin     
                srcA = rA_i;
                srcB = rB_i;
                dstE = `RNONE;
                dstM = `RNONE;
            end
            `IMRMOVQ:begin       
                srcA = rA_i;
                srcB = rB_i;
                dstE = `RNONE;
                dstM = rA_i;
            end
            `IOPQ:   begin     
                srcA = rA_i;
                srcB = rB_i;
                dstE = rB_i;
                dstM = `RNONE;
            end
            `IJXX:   begin       
                srcA = `RNONE;
                srcB = `RNONE;
                dstE = `RNONE;
                dstM = `RNONE;
            end

            //%rsp need to be modified
            `ICALL:  begin       
                srcA = `RNONE;
                srcB = `RESP;           
                dstE = `RESP;
                dstM = `RNONE;
            end

            //%rsp need to be modified
            `IRET:   begin
                srcA = `RESP; 
                srcB = `RESP;
                dstE = `RESP;
                dstM = `RNONE;
            end

            //%rsp need to be modified
            `IPUSHQ: begin
                srcA = rA_i;   
                srcB = `RESP;
                dstE = `RESP;
                dstM = `RNONE;
            end

            //%rsp need to be modified
            `IPOPQ:  begin      
                srcA = `RESP;
                srcB = `RESP;
                dstE = `RESP;
                dstM = rA_i;
            end
            default: begin
                srcA = `RNONE;
                srcB = `RNONE;
                dstE = `RNONE;
                dstM = `RNONE;
            end
        endcase
    end

    //read from register_file
    reg [63:0] regs[0:15];

    always @(*) begin               
        if(srcA != `RNONE )
            valA_o = regs[srcA];
        else
            valA_o = 64'h0;

        if(srcB != `RNONE)
            valB_o = regs[srcB];
        else
            valB_o = 64'h0;
    end


    //write to register_file
    integer i;
    always@(posedge clk_i)begin
        if(~rst_n_i)begin
            for(i = 0; i < 16;i = i + 1)
		       regs[i] <= 0;
        end

        else begin
		    if(dstE != `RNONE) begin
			    regs[dstE] <=  valE_i;
	        end
		    if(dstM != `RNONE) begin
			    regs[dstM] <=  valM_i;
		    end
        end
    end
    
endmodule

