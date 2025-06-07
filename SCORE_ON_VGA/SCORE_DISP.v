`timescale 1ns / 1ps
module SCORE_DISP(sys_clk,hsync,vsync,red,green,blue,reset);
input sys_clk,reset;
output hsync,vsync;
output [3:0] red,green,blue;
wire clk_25M;
wire [4:0] score_adrs;
wire [0:19] score1,score2,score3,score4;
wire [3:0] bcd3,bcd2,bcd1,bcd0;
wire [15:0] bcd;
wire [9:0]hcount,vcount;
wire [0:99] score_t;
assign bcd3=bcd[15:12];
assign bcd2=bcd[11:8];
assign bcd1=bcd[7:4];
assign bcd0=bcd[3:0];
assign stop_temp=0;
SCORE Score_counter(sys_clk,bcd,stop_temp,reset);
SCORE_DATA Score1(clk_25M,bcd0,score1,score_adrs,score_t);
SCORE_DATA Score2(clk_25M,bcd1,score2,score_adrs);
SCORE_DATA Score3(clk_25M,bcd2,score3,score_adrs);
SCORE_DATA Score4(clk_25M,bcd3,score4,score_adrs);

CLK_25MHz Clk_div25M(sys_clk,clk_25M);
CLK_100Hz Clk_div100(sys_clk,clk_100);
DISP_COUNT Access(clk_25M,hcount,vcount,hsync,vsync);
DISP_WRITE(clk_25M,hcount,vcount,score1,score2,score3,score4,score_t,score_adrs,stop_temp,red,green,blue);
endmodule

module DISP_WRITE(clk_25M,hcount,vcount,score1,score2,score3,score4,score_t,score_adrs,stop_temp,red,green,blue);
input clk_25M,stop_temp;
input [9:0] hcount,vcount;
input [0:19] score1;
input [0:19] score2;
input [0:19] score3;
input [0:19] score4;
input [0:99] score_t;
output reg [4:0] score_adrs;
output reg [3:0] red,green,blue;
always @(posedge clk_25M)
begin
    if((hcount>=144 && hcount<=784) && (vcount>=35 && vcount<=521))
        begin
            score_adrs<=vcount-40;
            if((hcount>=750 && hcount<=770) && (vcount>=40 && vcount<=72)&&(score1[hcount-750]==1))
            begin
                {red,green,blue}<={4'b0000,4'b0000,4'b1111};
            end
            else if((hcount>=730 && hcount<=750) && (vcount>=40 && vcount<=72)&&(score2[hcount-730]==1))
            begin
                {red,green,blue}<={4'b0000,4'b0000,4'b1111};
            end
            else if((hcount>=710 && hcount<=730) && (vcount>=40 && vcount<=72)&&(score3[hcount-710]==1))
            begin
                {red,green,blue}<={4'b0000,4'b0000,4'b1111};
            end
            else if((hcount>=690 && hcount<=710) && (vcount>=40 && vcount<=72)&&(score4[hcount-690]==1))
            begin
                {red,green,blue}<={4'b0000,4'b0000,4'b1111};
            end
            else if((hcount>=590 && hcount<=689) && (vcount>=40 && vcount<=72)&&(score_t[hcount-590]==1))
            begin
                {red,green,blue}<={4'b0000,4'b0000,4'b1111};
            end
            else
                {red,green,blue}<={4'b1111,4'b1111,4'b1111}; 
        end
    else
        begin
            {red,green,blue}<={4'b0000,4'b0000,4'b0000};   
        end
end
endmodule

// Clock Division for 25MHz
module CLK_25MHz(clk_in,clk_out);
input clk_in;
output reg clk_out=0;
integer i;
always @(posedge clk_in)
begin
    if(i==1)
    begin
        clk_out<=~clk_out;
        i<=0;
    end
    else
        i<=i+1;
end
endmodule

// Clock Division for 100Hz
module CLK_100Hz(clk_in,clk_out);
input clk_in;
output reg clk_out=0;
integer i;
always @(posedge clk_in)
begin
    if(i==499999)
    begin
        clk_out<=~clk_out;
        i<=0;
    end
    else
        i<=i+1;
end
endmodule

// Access the display
module DISP_COUNT(clk,hcount,vcount,hsync,vsync);
input clk;
output hsync,vsync;
output reg [9:0] hcount=0;
output reg [9:0] vcount=0;
always @(posedge clk)
begin
    if(vcount<521)
    begin
        if(hcount<799)
            hcount<=hcount+1;
        else
        begin
            hcount<=0;
            vcount<=vcount+1;
        end
    end
    else
        vcount<=0;
end
assign vsync=(vcount<=1)?1:0; 
assign hsync=(hcount<=95)?1:0;
endmodule
