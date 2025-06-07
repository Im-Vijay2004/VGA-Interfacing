module SCORE(clk,score,stop_temp,reset);
input clk,reset,stop_temp;
output [15:0] score;
reg clk_div;
integer i;
integer div;
reg [13:0] bin=0;
always @(posedge clk)
begin
    if(i==div)
    begin
        clk_div<=~clk_div;
        i<=0;
    end
    else
        i<=i+1;
end
always @(posedge clk)
begin
    if(bin <15)
        div<=49999999;
    else if( bin>=15 && bin <=30)
        div<=25999999;
    else if( bin>30 && bin <=50)
        div<=12599999;
    else if( bin>50 && bin <=100)
        div<=10000000;
    else if( bin>100 && bin <=1000)
        div<=4999999;
    else if( bin>1000 && bin <10000)
        div<=2599999;
    else
        div<=div;
end
always @(posedge clk_div, posedge reset)
begin
    if(reset)
        bin<=0;
    else if(stop_temp)
        bin<=bin;
    else
        bin<=bin+1;
end
BIN_BCD Binary_BCD(clk,bin,score);
endmodule