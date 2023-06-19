`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2023 11:16:38 AM
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module testbench();
reg clk;

wire [31:0] pc;
wire [31:0] new_pc;

wire [31:0] inst_out; 
//wire [31:0] d;
//wire wreg;
wire [31:0] qa;
wire [31:0] qb; 
wire [31:0] out;

wire [1:0] pcsrc;
wire m2reg;
wire wmem;
wire aluimm;
wire shift;
wire wreg;
wire regrt;
wire jal;
wire sext;
 
wire [3:0] aluc;
 
wire [31:0]final;
wire z;

wire [31:0]plus_out;

wire [27:0]shifted_add;

wire [31:0]do;

wire [4:0] wn_out;
wire [31:0] d_out;   
datapath datapath_tb(clk, pc, new_pc, inst_out,qa,qb,out,m2reg, pcsrc,
wmem,aluc,shift,aluimm,wreg,regrt,jal,sext,plus_out,shifted_add,do,final,z,wn_out,d_out);
initial begin
clk=0;
end
always begin
#10clk=~clk;
end
endmodule