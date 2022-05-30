`timescale 1ns / 1ps
module fetch_tb;
  reg [63:0] PC;
  
  wire [3:0] icode;
  wire [3:0] ifun;
  wire [3:0] rA;
  wire [3:0] rB; 
  wire [63:0] valC;
  wire [63:0] valP;

  fetch fetch(
    .PC(PC),
    .icode(icode),
    .ifun(ifun),
    .rA(rA),
    .rB(rB),
    .valC(valC),
    .valP(valP)
  );
  
  initial begin 
    PC=64'd0;
   
  end 
  
  initial 
		$monitor(" PC=%d icode=%b ifun=%b rA=%b rB=%b,valC=%d,valP=%d\n",PC,icode,ifun,rA,rB,valC,valP);
endmodule

