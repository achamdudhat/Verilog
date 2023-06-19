`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Engineer: Achyut Dudhat
// 
// Create Date: 03/21/2023 11:16:07 AM
// Design Name: RISC
// Module Name: Lab3design
// Project Name: 32 Bit Pipelined CPU 
// Device Family: Zynq-7000
// Device: XC7Z010- -1CLG400C
// Description: 5 staged pipelined architecture: fetch, decode, execute, memory access and write
// 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module program_Counter(
    input [31:0] new_pc,
    input clk,
    output reg [31:0] pc);
    
    initial
    begin
        pc = 0;
    end
    always @ (posedge clk)
    begin
        pc <= new_pc;
    end
endmodule


module pcAdder(
    input [31:0] pc,
    output reg [31:0] pc_4);
    
    always @ (*)
    begin
        pc_4 <= pc + 32'd4;
    end
endmodule


/*module pcadd4(input clk,output reg [31:0] pc);
initial begin
pc=0;
end
always @( posedge clk)
begin
    pc<=pc+32'd4;
end
endmodule
*/
module multipexer(input [31:0] pc_4, input [1:0] pcsrc,
input [31:0] plus_out,input [31:0]qa,input[27:0]shifted_add, 
output reg [31:0] mux_out);

always @(*) begin
    if(pcsrc==2'b00) begin    
    mux_out<=pc_4;    
    end

    if(pcsrc==2'b01) begin
    mux_out<=plus_out;
    end
    
    if(pcsrc==2'b10) begin
    mux_out<=qa;
    end
    
    if(pcsrc==2'b11) begin
    mux_out<={pc_4[31:28],shifted_add};
    end
end
endmodule


module control_unit (op, func, z, m2reg, pcsrc, wmem, aluc,shift,aluimm,wreg,regrt,jal, sext);
    input [5:0] op;
    input [5:0] func;
    input z;
    //pcscr 2 bits
    //add jr
    output reg m2reg;
    output reg [1:0] pcsrc;
    output reg wmem;
    output reg [3:0] aluc;
    output reg shift;    
    output reg aluimm;
    output reg wreg;
    output reg regrt;
    output reg jal;
    output reg sext;
    
    always @(*) begin
       
        if (op == 6'b000000) begin
            if (func == 6'b100000) begin
                //add
 
                wreg = 1;
                regrt=0;
                jal=0;
                m2reg=0;
                shift = 0;
                aluimm=0;            
                sext=1'bx;
                aluc = 4'bx000; //x000
                wmem=0;       
                pcsrc = 2'b00;
            end
            if (func == 6'b100010) begin
                //subtract
                shift = 0; 
                wreg = 1;
                m2reg=0;
                wmem=0;
                aluimm=0; 
                pcsrc = 2'b00; 
                aluc = 4'b0100;//x100
            end
            if (func == 6'b100100) begin
                //AND
                shift = 0; 
                wreg = 1; 
                m2reg=0;
                wmem=0;
                aluimm=0;
                pcsrc = 2'b00;
                aluc = 4'b0001;//x001
            end
            if (func == 6'b100101) begin
                //OR
                shift = 0; 
                wreg = 1; 
                m2reg=0;
                wmem=0;
                aluimm=0;
                pcsrc = 2'b00;
                aluc = 4'b0101; //x101                
            end//for sll and srl shift=1
            if (func == 6'b100110) begin
                //XOR
                shift = 0; 
                wreg = 1; 
                pcsrc = 2'b00;
                aluc = 4'b0010; //x010
            end            
            if (func == 6'b000000) begin
                //sll
                shift = 1; 
                wreg = 1; 
                pcsrc = 2'b00;
                aluc = 4'b0011;//0011            
                end
            if (func == 6'b000010) begin
                //srl
                shift = 1; 
                wreg = 1; 
                pcsrc = 2'b00;
                aluc = 4'b0111; //0111
            end
            if (func == 6'b000011) begin
                //sra
                shift = 1; 
                wreg = 1; 
                pcsrc = 2'b00;
                aluc = 4'b1111;//1111   
            end
            if (func == 6'b001000) begin
            end
        end
   //addi     
        if(op==6'b001000) begin
                wreg = 1;
                regrt=1;
                jal=0;
                m2reg=0;
                shift = 0;
                aluimm=1;            
                sext=1'b1;
                aluc = 4'bx000; //x000
                wmem=0;       
                pcsrc = 2'b00;        
        end
        //andi
        if(op==6'b001100) begin
                wreg = 1;
                regrt=1;
                jal=0;
                m2reg=0;
                shift = 0;
                aluimm=1;            
                sext=1'b0;
                aluc = 4'bx001; //x000
                wmem=0;       
                pcsrc = 2'b00;        
        end
        //ori
        if(op==6'b001101) begin
                wreg = 1;
                regrt=1;
                jal=0;
                m2reg=0;
                shift = 0;
                aluimm=1;            
                sext=1'b0;
                aluc = 4'bx101; //x000
                wmem=0;       
                pcsrc = 2'b00;        
        end
        //xori
        if(op==6'b001110) begin
                wreg = 1;
                regrt=1;
                jal=0;
                m2reg=0;
                shift = 0;
                aluimm=1;            
                sext=1'b0;
                aluc = 4'bx010; //x000
                wmem=0;       
                pcsrc = 2'b00;        
        end
        
        //lw
        if(op==6'b100011) begin
                wreg = 1;
                regrt=1;
                jal=0;
                m2reg=1;
                shift = 0;
                aluimm=1;            
                sext=1'b1;
                aluc = 4'bx000; //x000
                wmem=0;       
                pcsrc = 2'b00;        
        end
             
        //sw
        if(op==6'b101011) begin
                wreg = 0;
                regrt=1'bx;
                jal=1'bx;
                m2reg=1'bx;
                shift = 0;
                aluimm=1;            
                sext=1'b1;
                aluc = 4'bx000; //x000
                wmem=1;       
                pcsrc = 2'b00;        
        end
        
        //beq
        if(op==6'b000100) begin
            //beq
            if(z==0) begin
        
                wreg = 0;
                regrt=1'bx;
                jal=1'bx;
                m2reg=1'bx;
                shift = 0;
                aluimm=0;            
                sext=1'b1;
                aluc = 4'bx010; //x000
                wmem=0;       
                pcsrc = 2'b00;        
            end
            if(z==1) begin
        
                wreg = 0;
                regrt=1'bx;
                jal=1'bx;
                m2reg=1'bx;
                shift = 0;
                aluimm=0;            
                sext=1'b1;
                aluc = 4'bx010; //x000
                wmem=0;       
                pcsrc = 2'b01;        
            end
                        
        end
        //bne
        if(op==6'b000101) begin
            
                if(z==0) begin
        
                wreg = 0;
                regrt=1'bx;
                jal=1'bx;
                m2reg=1'bx;
                shift = 0;
                aluimm=0;            
                sext=1'b1;
                aluc = 4'bx010; //x000
                wmem=0;       
                pcsrc = 2'b01;        
            end
            if(z==1) begin
        
                wreg = 0;
                regrt=1'bx;
                jal=1'bx;
                m2reg=1'bx;
                shift = 0;
                aluimm=0;            
                sext=1'b1;
                aluc = 4'bx010; //x000
                wmem=0;       
                pcsrc = 2'b00;        
            end
                        
        end
         //lui
        if(op==6'b001111) begin
                wreg = 1;
                regrt=1'b1;
                jal=1'b0;
                m2reg=1'b0;
                shift = 1'bx;
                aluimm=1;            
                sext=1'bx;
                aluc = 4'bx110; //x000
                wmem=0;       
                pcsrc = 2'b00;        
        end
    
         //j
        if(op==6'b000010) begin
                wreg = 0;
                regrt=1'bx;
                jal=1'bx;
                m2reg=1'bx;
                shift = 1'bx;
                aluimm=1'bx;            
                sext=1'b1;
                aluc = 4'bxxxx; //x000
                wmem=0;       
                pcsrc = 2'b11;        
        end
             
         //jal    
        if(op==6'b000011) begin
                wreg = 1;
                regrt=1'bx;
                jal=1;
                m2reg=1'bx;
                shift =1'bx;
                aluimm=1'bx;            
                sext=1'bx;
                aluc = 4'bxxxx; //x000
                wmem=0;       
                pcsrc = 2'b11;        
        end
        //jr
        if(op==6'b000000) begin
                if(func==6'b001000)begin
                wreg = 0;
                regrt=1'bx;
                jal=1'bx;
                m2reg=1'bx;
                shift =1'bx;
                aluimm=1'bx;            
                sext=1'bx;
                aluc = 4'bxxxx; //x000
                wmem=0;       
                pcsrc = 2'b10; 
                end       
        end
        
        
  end
endmodule







module instruction_mem(
    output wire [31:0] pc,
    output reg[31:0] inst_out);

    //Make an array and initiliaze to
    reg [31:0] array[0:63];
    
     initial begin
/*array[0]=32'h3C010000; //sub $t0, $t1, $a0
array[1]=32'h34240050;//or $a2, $t2, $t1
array[2]=32'h20050004; //sll $t0, $a1, 15
array[3]=32'h00004020;
array[4]=32'hAC820000;
array[5]=32'h8C890000;
array[6]=32'h01244022;
array[7]=32'h20050003;
array[8]=32'h20A5FFFF;
array[9]=32'h34A8FFFF;
array[10]=32'h39085555;
array[11]=32'h2009FFFF;
array[12]=32'h312AFFFF;
array[13]=32'h01493025;
array[14]=32'h01494026;
array[15]=32'h01463824;
array[16]=32'h10A00001;
array[17]=32'h08000008;
array[18]=32'h2005FFFF;*/  
array[0]= 32'h0C000002; 
//0000 1100=3
//0001 0100 1010 00000 0000
// 1    4     10
array[1]=32'h14A00000;
//0000 0011=3 1110=14 0000 0000 0000 0000 1000
array[2]=32'h03E00008;
    end
    always @ (*) begin
        inst_out <= array[pc/4];//        instOut <= array[pcnext/4];
    end
endmodule

module instruction_mux(rd, rt, regrt, wn_reg);
    input [4:0] rd;
    input [4:0] rt;
    input regrt;
    output reg [4:0] wn_reg;
    
    always@(*) begin
        if (regrt == 1) begin
            wn_reg <= rt;
        end
        else begin
            wn_reg <= rd;
        end
    end
endmodule


module mux_wn(jal,wn_reg,wn_out);
input jal;
input [4:0] wn_reg;
output reg [4:0] wn_out;
always@(*) begin
if (jal==1) begin
wn_out<=5'd31;
end
if (jal==0) begin
wn_out<=wn_reg;
end
end
endmodule


module mux_d(d,pc_4,jal,d_out);
input[31:0] d; 
input [31:0] pc_4;
input jal;
output reg [31:0] d_out;

always@(*) begin
if(jal==1) begin
d_out<=pc_4;
end

if(jal==0) begin
d_out<=d;
end
end
endmodule

module register_file (clk, rna, rnb,wn,wreg,d, qa, qb);
    input clk;
    input [4:0] rna;
    input [4:0] rnb;
    input[31:0] d;
    input wreg;
    input [4:0] wn;
    //rs rd inputs
    reg [31:0] array[0:31];
    output reg [31:0] qa;
    output reg [31:0] qb;
//initizalize the first 10 words of register file
initial begin
array[0]=32'h00000000;
array[1]=32'hA00000AA;
array[2]=32'h10000011;
array[3]=32'h20000022;
array[4]=32'h30000033;
array[5]=32'h40000044;
array[6]=32'h50000055;
array[7]=32'h60000066;
array[8]=32'h70000077;
array[9]=32'h80000088;
array[10]=32'h90000099;

end

    always @(*) begin
        qa <= array[rna];
        qb <= array[rnb];
        
        if(wreg==1) begin
            array[wn]=d; 
        end
            end
    
endmodule



module selector(
input shift,
input [31:0] qa,
input [31:0] sa,//when wiring remmeber to put additional zeros to make  it 32 bits as sa is 5 bits
output reg [31:0] a);
    always@(*) begin
if (shift==1) begin
    a<=sa;
    end
    else begin
    a<=qa;
    end
    
  end 
    
endmodule 

module extender_16to_32 (sext,imm, imm_32);
    input sext;
    input [15:0] imm;
    output reg [31:0] imm_32;
    
    
    always @(*) begin
    if(sext==1) begin
    imm_32 = {{16{imm[15]}}, imm[15:0]};
    end
    if(sext==0) begin
    imm_32 = {16'b0, imm[15:0]};
    end
    end
    endmodule
    
    
    
module selector_for_b(qb, imm_32, aluimm, b);
        input [31:0] qb;
        input [31:0] imm_32;
        input aluimm;
        output reg [31:0] b;
        
        always@(*) begin
            if (aluimm == 1) begin
                b <= imm_32;
            end
            else if (aluimm == 0) begin
                b <= qb;
            end
        end
endmodule



//adder for lower plus
module shiftaddr_plus( imm_32, plus_out );
input [31:0] imm_32;
output reg [31:0] plus_out;

    always@(*) begin
 plus_out=imm_32<<2;
    end

endmodule



module shiftaddr(addr,shifted_add);
    input [25:0] addr;
    output reg [27:0] shifted_add;
    
    always@(*) begin
    shifted_add=addr<<2;
    end   
endmodule

module alu_unit(
    input [31:0] a,      // first input register
    input [31:0] b,      // second input register
    input [3:0]  aluc,   // ALU control signal
    output reg [31:0] d,
    output reg [31:0] out,
    output reg z // output result
);
//only for beq and bne for z
always @(a,b,aluc) begin
//x
        if(a==b) begin
            z=1;
        end
        if(a!=b) begin
            z=0;
        end
if(aluc==4'bx000) begin
    out =a+b;
    end
if(aluc==4'bx000) begin
    out =a+b;
    end
if(aluc==4'bx001) begin
    out =a-b;
    end
if(aluc==4'bx010) begin
    out =a&b;
    end
if(aluc==4'b0011) begin
    out =a|b;
    end
if(aluc==4'b0100) begin
    out =a^b;
    end
if(aluc==4'b0101) begin
    out =b<<a;
    end
if(aluc==4'b0110) begin
    out =a>>b;
    end
if(aluc==4'b1111) begin
    out =a;// SRA
    end
    
    d=out;
end
endmodule

//DATA MEMORY   //out of mux, qb
module data_mem (out,qb, wmem, do);
    input [31:0] out;
    input [31:0] qb;
    input wmem;
    reg [31:0] memory [128:0];
    output reg [31:0] do;
    

    always @(*) begin
        if (wmem == 0) begin
            do = memory[out/4];
        end
       // mdo = memory[mr];
        if (wmem == 1) begin
            memory[out/4]<=qb;
        end
    end
endmodule


module mux_after_data(m2reg,out,do, final);
input m2reg;
input[31:0] out;
input [31:0] do;
output reg [31:0]final;

always@(*) begin
if(m2reg==0) begin
final=out;
end
if(m2reg==1) begin
final =do;
end
end

endmodule


module datapath(clk, pc, new_pc, inst_out,qa,qb,out,m2reg, pcsrc,wmem,aluc,shift,aluimm,wreg,regrt,jal,sext,
plus_out,shifted_add,do,final,z,wn_out,d_out);
 input clk;
    output wire [31:0] pc;
    output wire [31:0] new_pc;
    output wire [31:0] inst_out;
    output wire [31:0] qa;
    output wire [31:0] qb;
    output wire [31:0] out;
    output wire m2reg;
    output wire [1:0] pcsrc;
    output wire wmem;
    output wire [3:0] aluc;
    output wire shift;    
    output wire aluimm;
    output wire wreg;
    output wire [4:0] regrt;
    output wire jal;
    output wire sext;
    output wire [31:0] plus_out;
    output wire [27:0] shifted_add;
    output wire [31:0] do;
    output wire [31:0] final;
    output wire z;
    output wire [4:0] wn_out;
    output wire [31:0] d_out;
    wire [31:0] d=final[31:0];
    wire [5:0] op = inst_out[31:26];
    wire [4:0] rs = inst_out[25:21];
    wire [4:0] rt = inst_out[20:16];
    wire [4:0] rd = inst_out[15:11];
    wire [4:0] sa = inst_out[10:6];
    wire [5:0] func = inst_out[5:0];
    wire [15:0] imm = inst_out[15:0];
    wire [25:0] addr = inst_out[25:0];
    wire [31:0] a = qa[31:0];
    wire [31:0] b = qb[31:0];
    wire [31:0] imm_32;
    wire [4:0]wn_reg;
    
    wire [31:0]pc_4;
program_Counter program_Counter_inst (new_pc,clk,pc);
pcAdder pcAdder_inst (pc, pc_4);
multipexer multipexer_inst( pc_4, pcsrc,plus_out,qa,shifted_add, new_pc);
instruction_mem instruction_mem_inst (pc,inst_out);
control_unit control_unit_inst(op, func, z, m2reg, pcsrc, wmem, aluc,shift,aluimm,wreg,regrt,jal, sext);
instruction_mux instruction_mux_inst(rd, rt, regrt, wn_reg);

mux_wn mux_wn_inst(jal,wn_reg,wn_out);
mux_d mux_d_inst(d,pc_4,jal,d_out);

register_file register_file_inst (clk, rs, rt,wn_out,wreg,d_out, qa, qb);
selector selector_inst (shift,qa,sa,a); 
extender_16to_32 extender_16to_32_inst(sext,imm, imm_32);
selector_for_b selector_for_b_inst(qb, imm_32, aluimm, b);
shiftaddr_plus shiftaddr_plus_inst( imm_32, plus_out );
shiftaddr shiftaddr_inst(addr,shifted_add);
alu_unit alu_unit_inst(a,b,aluc, out,z);    
mux_after_data mux_after_data_inst(m2reg,out,do, final);
data_mem data_mem_inst(out,qb, wmem, do);

endmodule