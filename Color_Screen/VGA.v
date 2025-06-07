`timescale 1ns / 1ps
module VGA(sys_clk,hsync,vsync,red,green,blue);
input sys_clk;
output hsync,vsync;
output [3:0] red,green,blue;
wire [9:0] hcount,vcount;
wire clk_25M;
CLK_25MHz div(sys_clk,clk_25M);
DISP_COUNT Access(clk_25M,hcount,vcount,hsync,vsync);
DISP_WRITE Writing(clk_25M,hcount,vcount,red,green,blue);
endmodule
module DISP_WRITE(clk_25M,hcount,vcount,red,green,blue);
input clk_25M;
input [9:0] hcount,vcount;
output reg [3:0] red,green,blue;
always @(posedge clk_25M)
begin
    if((hcount>=0 && hcount<=649) && (vcount>=0 && vcount<=479))
        {red,green,blue}<={4'b1001,4'b0000,4'b0110};
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

// Access the display
module DISP_COUNT(clk,hcount,vcount,hsync,vsync);
input clk;
output hsync,vsync;
output reg [9:0] hcount=0;
output reg [9:0] vcount=0;
always @(posedge clk)
begin
    if(vcount<525)
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
assign vsync=(vcount<=490 && vcount<492)?0:1; 
assign hsync=(hcount<=656 && hcount<752)?0:1;
endmodule