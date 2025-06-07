module All_Colors(clk,r,g,b,hsync,vsync);
input clk;
output reg [3:0] r,g,b;
output hsync,vsync;
reg clk_25MHz;
reg  [9:0]hcount,vcount;
reg i=0;
initial hcount=0;
initial vcount=0;
always @(posedge clk)
begin
    if(i)
        begin
        clk_25MHz<=~clk_25MHz;
        i<=0;
        end
   else
        i<=i+1;
end
always @(posedge clk_25MHz)
begin
    if(hcount==799)
        begin
            hcount<=0;
            if(vcount==521)
                begin
                    vcount<=0;
                end
            else
                vcount<=vcount+1;
        end
    else
    begin
        hcount<=hcount+1;
    end
end
assign vsync=(vcount<=1)?1:0; 
assign hsync=(hcount<=95)?1:0;
always @(posedge clk_25MHz)
begin
    if((hcount>=144 && hcount<=784) && (vcount>=35 && vcount<=521))
        if(vcount>=35 && vcount<=275)
        begin
            if(hcount>=144 && hcount <235)
                {r,g,b}={4'b0000,4'b0000,4'b0000};
            else if(hcount>=235 && hcount <326)
                {r,g,b}={4'b0000,4'b0000,4'b1111};
            else if(hcount>=326 && hcount <417)
                {r,g,b}={4'b0000,4'b1111,4'b0000};
            else if(hcount>=417 && hcount <508)
                {r,g,b}={4'b0000,4'b1111,4'b1111};
            else if(hcount>=508 && hcount <599)
                {r,g,b}={4'b1111,4'b0000,4'b0000};
            else if(hcount>=599 && hcount <690)
                {r,g,b}={4'b1111,4'b0000,4'b1111};
            else
                {r,g,b}={4'b1111,4'b1111,4'b0000};
        end
        else
            {r,g,b}={4'b1111,4'b1111,4'b1111};
    else
        begin
            {r,g,b}={4'b0000,4'b0000,4'b0000};   
        end
end
endmodule