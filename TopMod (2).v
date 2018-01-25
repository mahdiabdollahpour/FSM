module topmodule(target,clk,reset,vsync,hsync,rgb);
input target;
wire mclk;
input clk;
input reset;

reg[0:31] Xpre;
reg[0:31] Ypre;

reg[0:31] Xnow;
reg[0:31] Ynow;

parameter back = 2'b10;
parameter forward = 2'b01;
parameter noMove = 2'b00;
reg[0:1] left;
reg[0:1] right;
//wire[0:1] lo;
//wire[0:1] ro;
reg[0:31] Xdes;
reg[0:31] Ydes;
reg[0:31] deltaX;
reg[0:31] deltaY;

output[0:9] rgb;
output vsync;
output hsync;
wire[0:31] x ;
wire[0:31] y ;

Given_top gt(.clk(clk),.reset(reset),.x_c(x),.y_c(y),.left(left),.right(right),.clk_out(mclk),.rgb(rgb),.vsync(vsync),.hsync(hsync));
reg [0:1] lDet;
reg [0:1] rDet;

reg signed[0:31] dX;
reg signed[0:31] dY;

reg signed[0:31] dXtD;
reg signed[0:31] dYtD;


always@(negedge mclk)
begin


if(target == 0)
begin
Xdes = 0;
Ydes = 200000000;
end


if(target == 1)
begin
Xdes = 800000000;
Ydes = 700000000;
end


deltaX = Xdes - x ;
deltaY = Ydes - y;



if(reset)
begin
//$display("in reset state");
Xnow = 400000000;
Ynow = 400000000;
Xpre = 400000004;
Ypre = 400000003;
left = noMove;
right = forward;
//start = 1;
end
else
begin

Xpre = Xnow;
Ypre = Ynow;
Xnow = x;
Ynow = y;

//if((left == back) && (right == back))
//begin// detecting direction
//$display("was a back");
//dX = Xpre - Xnow;
//dY = Ypre - Ynow;
//dXtD = Xdes - Xnow;
//dYtD = Ydes - Ynow;
//end
if((left != back) || (right != back))
begin
//$display("was not a back");
dX = Xnow - Xpre;
dY = Ynow - Ypre;

dXtD = Xdes - Xpre;
dYtD = Ydes - Ypre;
end



if((dX >= 0 && dY > 0)||(dX > 0 && dY >= 0))//to robe aval va albate marzesh
begin
if((dXtD > dX) && (dYtD > dY))
begin
lDet = forward;
rDet = forward;
end 
if((dXtD > dX) && (dYtD < dY))
begin
lDet = noMove;
rDet = forward;
end 
if((dXtD < dX) && (dYtD > dY))
begin
lDet = forward;
rDet = noMove;
end 
if((dXtD < dX) && (dYtD < dY))
begin//back
lDet = noMove;
rDet = forward;
end 

end
/////////////////////////
if(dX > 0 && dY < 0)//to robe 4
begin
if((dXtD > dX) && (dYtD < dY))
begin
lDet = forward;
rDet = forward;
end 
if((dXtD > dX) && (dYtD > dY))
begin
lDet = forward;
rDet = noMove;
end 
if((dXtD < dX) && (dYtD < dY))
begin
lDet = noMove;
rDet = forward;
end 
if((dXtD < dX) && (dYtD > dY))
begin//back
lDet = noMove;
rDet = forward;

end 

end


///////////////////
if(((dX <= 0) && (dY < 0))||((dX < 0) && (dY <= 0)))//to robe sevom
begin
if((dXtD < dX) && (dYtD < dY))
begin
lDet = forward;
rDet = forward;
end 
if((dXtD > dX) && (dYtD < dY))
begin
//left - had a fix here
lDet = forward;
rDet = noMove;
end 
if((dXtD < dX) && (dYtD > dY))
begin
//right - had fixes
lDet = noMove;
rDet = right;
end 
if((dXtD > dX) && (dYtD > dY))
begin//back
lDet = noMove;
rDet = forward;

end 
end

//////////////////////////////////

if((dX < 0) && (dY > 0))//to robe 2
begin
if((dXtD < dX) && (dYtD > dY))
begin
lDet = forward;
rDet = forward;
end 
if((dXtD > dX) && (dYtD > dY))
begin
//right
lDet = noMove;
rDet = forward;
end 
if((dXtD < dX) && (dYtD < dY))
begin
//left
lDet = forward;
rDet = noMove;
end 
if((dXtD > dX) && (dYtD < dY))
begin//back
lDet = noMove;
rDet = forward;

end 

end
////////////////////





if( (deltaX * deltaX + deltaY * deltaY <= 100))
begin // we are there //if( x > Xdes - 10 && x < Xdes + 10  && y > Ydes - 10 && y < Ydes + 10) 
//$display("end");
left = noMove;
right = noMove;
end 
else
begin
if( ((left == back && right == back) || (right == forward && left == forward )))
begin
//$display("setting left and right to lo and ro");
left = rDet;
right = lDet;
end
else
begin 
if( ((left == noMove) && (right == forward)) || ((right == noMove) && (left == forward) ))
begin//there was a rotaion or a stop
//$display("had a rotation going forward");
right = forward; 
left = forward; 
end
end
end

end
end

endmodule 

