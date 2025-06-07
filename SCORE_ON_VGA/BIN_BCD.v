module BIN_BCD(
input clk,
input [13:0]bin,
output reg [15:0]bcd
);
reg [3:0]count=0;
reg [15:0] bcd_temp=0;
reg reset=0;
always@(posedge clk)
if(reset) begin
    bcd_temp=0;
    count=0;
    reset=0;
end
else if(count<=13)
begin
    if(bcd_temp[3:0]>=5) bcd_temp[3:0]=bcd_temp[3:0]+3;
    if(bcd_temp[7:4]>=5) bcd_temp[7:4]=bcd_temp[7:4]+3;
    if(bcd_temp[11:8]>=5) bcd_temp[11:8]=bcd_temp[11:8]+3;
    if(bcd_temp[15:12]>=5) bcd_temp[15:12]=bcd_temp[15:12]+3;
    bcd_temp={bcd_temp[14:0],bin[13-count]};
    count=count+1;
end
else
begin
    reset=1;
    bcd=bcd_temp;
end
endmodule