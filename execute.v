module execute(
    clk    ,
    rst_n  ,
    icode  ,
    ifun   ,
    valA   ,
    valB   ,
    valC   ,
    valE   ,
    Cnd
    );
    //�����źŶ���
    input               clk    ;
    input               rst_n  ;
    input   wire[3:0]   icode  ;
    input   wire[3:0]   ifun   ;
    input   wire signed [63:0] valA;
    input   wire signed [63:0] valB;
    input   wire signed [63:0] valC;

    //����źŶ���
    output   reg signed [63:0] valE;
    output   reg                Cnd;


    //�м��źŶ���
    reg     [63:0]      alu_A  ;
    reg     [63:0]      alu_B  ;
    reg     [3:0]       alu_fun  ;
    reg     [2:0]       cc;
    reg                 of;
    reg                 zf;
    reg                 sf;
    wire                set_cc ;

assign set_cc = (icode == 4'h6);

    //ALU A�� ALU B���߼�
    always@(*)begin
        case(icode)
            4'h2: begin
                alu_A = valA;
                alu_B = 0;
            end
            4'h3:begin
                alu_A = valC;
                alu_B = 0;
            end
            4'h4:begin
                alu_A = valC;
                alu_B = valB;
            end
            4'h5:begin
                alu_A = valC;
                alu_B = valB;
            end
            4'h6:begin
                alu_A = valA;
                alu_B = valB;  
            end          
            4'h8:begin
                alu_A = -8;
                alu_B = valB;
            end            
            4'h9:begin
                alu_A = 8;
                alu_B = valB;
            end
            4'hA:begin
                alu_A = -8;
                alu_B = valB;
            end
            4'hB:begin
                alu_A = 8;
                alu_B = valB;
            end            
            default:begin
                alu_A = 0;
                alu_A = 0;
            end
        endcase            
    end
   
    //ȷ��alu��������ͣ�alu_fun
    always  @(*)begin
        if(icode == 4'h6)
            alu_fun = ifun;
        else
            alu_fun = 4'h0;
    end


    always  @(*)begin
        case(ifun)
            4'h0:
                valE = alu_B + alu_A;
            4'h1:
                valE = alu_B - alu_A;                
            4'h2:
                valE = alu_B & alu_A;
            4'h3:
                valE = alu_B ^ alu_A;
        endcase            
    end

    //������Ĵ���CC,����of,zf, sfλ////???����ط��������������Ĵ��������ú͸���
    always @ (*) begin
        if(set_cc)begin
            case ( ifun )
                4'h0:  
                    of = (alu_A[63] == alu_B[63]) & (alu_B[63] != valE[63]);              //����e = b+a��a,bͬ�ţ���e��֮��ţ����ʾ�����
                4'h1:  
                    of =(~alu_A[63] == alu_B[63]) & (alu_B[63] != valE[63]);              //e = b-a = b + (~a + 1),Ȼ��Ϳ���������ķ�����
                4'h2: 
                    of = 0;
                4'h3:  
                    of  = 0;
            endcase
            zf      <=  (valE == 0) ;
            sf      <=   valE[63] ;
        end
    end

    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            cc[2] <= 0;
            cc[1] <= 0;
            cc[0] <= 0;
        end
        else begin
            cc[2] <= sf;
            cc[1] <= zf;
            cc[0] <= of;            
        end
    end



    
    //�����ж��ź�Cnd����ifun��������Ĵ������sf,of��zfƥ���Ӧ���ң�ֻ��icode = 4'h2��4'h7���漰�������жϡ�
    always  @(*)begin
        case(icode)
            4'h2:begin
                case(ifun)
                    4'h0:
                        Cnd =1;
                    4'h1:
                        Cnd = (cc[2]^cc[0])|cc[1];
                    4'h2:
                        Cnd = cc[2]^cc[0];
                    4'h3:
                        Cnd = cc[1];
                    4'h4:
                        Cnd = ~cc[1];
                    4'h5:
                        Cnd = ~(cc[2]^cc[0]);
                    4'h6:
                        Cnd = ~(cc[2]^cc[0])&(~cc[1]);
                endcase
            end

            4'h7: begin
                case(ifun)
                    4'h0:
                        Cnd =1;
                    4'h1:
                        Cnd = (cc[2]^cc[0])|cc[1];
                    4'h2:
                        Cnd = cc[2]^cc[0];
                    4'h3:
                        Cnd = cc[1];
                    4'h4:
                        Cnd = ~cc[1];
                    4'h5:
                        Cnd = ~(cc[2]^cc[0]);
                    4'h6:
                        Cnd = ~(cc[2]^cc[0])&(~cc[1]);
                endcase
            end
            default:
                Cnd = 0;
        endcase
    end


    
    endmodule

