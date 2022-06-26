`include "define.v"
module new_pc(
    clk_i,
    rst_n_i,
    icode_i,
    Cnd_i,
    valC_i,
    valM_i,
    valP_i,
    PC_o
);


    //input signal
    input                   clk_i    ;
    input                   rst_n_i  ;
    input   wire[3:0]       icode_i  ;
    input   wire            Cnd_i    ;
    input   wire[63:0]      valC_i   ;
    input   wire[63:0]      valM_i   ;
    input   wire[63:0]      valP_i   ;


    //output signal
    output  reg[63:0]       PC_o   ;
    //intermediate signal
    reg[63:0]               PC_new ;

    //PC update
    always@(*)begin
        if(~rst_n_i)begin
            PC_new = 0;
        end
        else begin
            case(icode_i) 
                `IJXX: begin
                        if (Cnd_i == 1)
                            PC_new = valC_i;
                        else 
                            PC_new = valP_i;
                 end
                 `ICALL: 
                          PC_new = valC_i;
                 `IRET:  
                          PC_new = valM_i;           
                 default:
                    PC_new = valP_i;
            endcase
        end
    end
    
    always@(posedge clk_i)begin
        if(~rst_n_i)begin
            PC_o <= 0;
        end
        else begin
            PC_o <= PC_new;
        end
        
    end

endmodule

