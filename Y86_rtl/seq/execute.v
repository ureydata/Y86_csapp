`include "define.v"
module execute(
    clk_i,
    rst_n_i,
    icode_i,
    ifun_i,
    valA_i,
    valB_i,
    valC_i,
    valE_o,
    Cnd_o
    );
    //input signal
    input               clk_i;
    input               rst_n_i;
    input   wire[3:0]   icode_i;
    input   wire[3:0]   ifun_i;
    input   wire signed [63:0] valA_i;
    input   wire signed [63:0] valB_i;
    input   wire signed [63:0] valC_i;

    //output signal
    output   reg signed [63:0] valE_o;
    output   wire              Cnd_o;


    //intermediate signal
    reg     [63:0]      aluA;
    reg     [63:0]      aluB;
    reg     [3:0]       alu_fun;
    reg     [2:0]       new_cc;
    reg     [2:0]       cc;

    wire zf = cc[2];
    wire sf = cc[1];
    wire of = cc[0];

    //logic control unit of aluA, aluB, alu Fun
    //aluA
    always @ (*) begin
        case (icode_i)
            `ICMOVQ:   begin
                aluA    = valA_i;
            end
            `IIRMOVQ:   begin
                aluA    = valC_i;
            end
            `IRMMOVQ:   begin
                aluA    = valC_i;
            end
            `IMRMOVQ:   begin
                aluA    = valC_i;
            end
            `IOPQ:      begin
                aluA    = valA_i;
            end
            `ICALL:     begin
                aluA    = -8;
            end

            `IRET:      begin
                aluA    = 8;
            end

            `IPUSHQ:    begin
                aluA    = -8;
            end

            `IPOPQ:     begin
                aluA    = 8;
            end
            default :begin
                aluA    = 0;
            end
        endcase
    end

    //aluB
    always @ (*) begin
        case ( icode_i )
           `ICMOVQ:   begin
                aluB    =  0;
            end
            `IIRMOVQ:   begin
                aluB    =  0;
            end
            `IRMMOVQ:   begin
                aluB    =  valB_i;
            end
            `IMRMOVQ:   begin
                aluB    =  valB_i;
            end
            `IOPQ:      begin
                aluB    =  valB_i;
            end
            `ICALL:     begin
                aluB    =  valB_i;
            end
            `IRET:      begin
                aluB    =  valB_i;
            end
            `IPUSHQ:    begin
                aluB    =  valB_i;
            end
            `IPOPQ:     begin
                aluB    =  valB_i;
            end
            default :begin
                aluB    =  0;
            end
        endcase
    end

    //alu Fun   
    always  @(*)begin
        if(icode_i == `IOPQ)
            alu_fun = ifun_i;
        else
            alu_fun = `ALUADD;
    end

    always  @(*)begin
        case(ifun_i)
            `ALUADD:    begin
                valE_o  = aluB + aluA;
            end
            `ALUSUB:    begin
                valE_o  = aluB - aluA;
            end                
            `ALUAND:    begin
                valE_o  = aluB & aluA;
            end
            `ALUXOR:    begin
                valE_o  = aluB ^ aluA;
            end
            default:    begin
                valE_o  = aluB + aluA;
            end            
        endcase            
    end

    //Set new_cc, new_cc[0] = of, new_cc[1] = sf, new_cc[2] = zf;
    always @ (*) begin
        if(~rst_n_i) begin
            new_cc[2] = 1;
            new_cc[1] = 0;
            new_cc[0] = 0;
        end
        else if(icode_i == `IOPQ)begin
            new_cc[2] = (valE_o == 0);
            new_cc[1] = valE_o[63];
            new_cc[0] = 
            alu_fun == `FADDL ?
                 (aluA[63] == aluB[63]) & (aluA[63] != valE_o[63]) :
            alu_fun == `FSUBL ?
                 (~aluA[63] == aluB[63]) & (aluB[63] != valE_o[63]) :
            0;

      end
    end 
    // Condition code register update
    always@(posedge clk_i)begin
        if (~rst_n_i)
            cc <= 3'b100;
        else
            cc <= new_cc;
    end

    // branch condition logic 
    assign Cnd_o =
           (ifun_i == `C_YES) |
           (ifun_i == `C_LE & ((sf ^ of)|zf)) |     // <=
           (ifun_i == `C_L & (sf ^ of)) |           // <
           (ifun_i == `C_E & zf) |                // ==
           (ifun_i == `C_NE & ~zf) |              // !=
           (ifun_i == `C_GE & ~(sf ^ of)) |         // >=
           (ifun_i == `C_G & (~(sf ^ of) & ~zf));   // >
    


    
endmodule

