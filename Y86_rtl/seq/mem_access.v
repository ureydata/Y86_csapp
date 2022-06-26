`include "define.v"
module mem_access(
    icode_i,
    valE_i,
    valA_i,
    valP_i,
    instr_valid_i,
    imem_error_i,
    clk_i,
    valM_o,
    Stat_o
);

    //input
    input   wire[3:0]   icode_i;
    input   wire[63:0]  valE_i;
    input   wire[63:0]  valA_i;
    input   wire[63:0]  valP_i;
    input   wire        instr_valid_i;
    input   wire        imem_error_i;
    input               clk_i;

    //output signal
    output  reg[63:0]   valM_o;
    output  wire[3:0]   Stat_o;

    //intermediate signal
    wire                dmem_error;
    reg                 mem_read;
    reg                 mem_write;
    reg     [63:0]      mem_data;
    reg     [63:0]      mem_addr;
    //data memory array
    reg     [7:0]	    data[0:1023];   

    //control logic for write or read
    always@(*)begin
        case(icode_i)
            `IRMMOVQ:     begin
                mem_read  = `DISABLE;
                mem_write = `ENABLE;
                mem_data  = valA_i;
                mem_addr  = valE_i;
            end
            `IMRMOVQ:     begin
                mem_read  = `ENABLE;
                mem_write = `DISABLE;
                mem_addr  = valE_i;
            end
            `ICALL:       begin
                mem_read  = `DISABLE;
                mem_write = `ENABLE;
                mem_data  = valP_i;
                mem_addr  = valE_i;
            end
            `IRET:        begin
                mem_read  = `ENABLE;
                mem_write = `DISABLE;
                mem_addr  = valA_i;                
            end
            `IPUSHQ:      begin
                mem_read  = `DISABLE;
                mem_write = `ENABLE;
                mem_data  = valA_i;
                mem_addr  = valE_i;
            end
            `IPOPQ:       begin
                mem_read  = `ENABLE;
                mem_write = `DISABLE;
                mem_addr  = valA_i;
            end
            default:begin
                mem_read  = `DISABLE;
                mem_write = `DISABLE;
                mem_data  = 64'h0;
                mem_addr  = 64'h0;
            end
        endcase

    end

    //To detect an illegal data memory address
    assign dmem_error = (mem_addr > 1023);

    //data memory write
    integer i;

    initial begin
        for(i = 0;i < 1024; i = i + 1)
                data[i] <= 0;
    end

    always@(posedge clk_i)

        if(mem_write)begin
                     {data[mem_addr + 7],data[mem_addr + 6],
                      data[mem_addr + 5],data[mem_addr + 4],
                      data[mem_addr + 3],data[mem_addr + 2],
                      data[mem_addr + 1],data[mem_addr + 0]} <= mem_data;
        end
         
    //data memory read
    always@(*)begin

        if(mem_read)begin
		    valM_o = {data[mem_addr + 7],data[mem_addr + 6],
                      data[mem_addr + 5],data[mem_addr + 4],
                      data[mem_addr + 3],data[mem_addr + 2],
                      data[mem_addr + 1],data[mem_addr + 0]};
        end

        else begin
            valM_o = 64'h0;
        end

    end

    //Statues logic
    assign Stat_o = (imem_error_i|dmem_error) ?
                     `SADR : (~instr_valid_i) ?
                     `SINS : (icode_i == `IHALT) ?
                     `SHLT : 
                     `SAOK;

    endmodule

