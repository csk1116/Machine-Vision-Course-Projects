close all;
clear;
clc;
L_1=imread('take_2_L_2 34.jpg');
L_2=imread('take_2_L_2 35.jpg');
L_3=imread('take_2_L_2 36.jpg');
L_4=imread('take_2_L_2 37.jpg');
L_5=imread('take_2_L_2 38.jpg');

R_1=imread('take_2_R_2 34.jpg');
R_2=imread('take_2_R_2 35.jpg');
R_3=imread('take_2_R_2 36.jpg');
R_4=imread('take_2_R_2 37.jpg');
R_5=imread('take_2_R_2 38.jpg');


L_1=rgb2gray(L_1);
L_2=rgb2gray(L_2);
L_3=rgb2gray(L_3);
L_4=rgb2gray(L_4);
L_5=rgb2gray(L_5);

% imtool(L_1);
% imtool(L_2);
% imtool(L_3);
% imtool(L_4);
% imtool(L_5);

L_1=double(L_1);
L_2=double(L_2);
L_3=double(L_3);
L_4=double(L_4);
L_5=double(L_5);

LM=zeros(480,640);

for i=1:480
    for j=1:640
        LM(i,j)=(L_1(i,j)+L_2(i,j)+L_3(i,j)+L_4(i,j)+L_5(i,j))/5;
    end
end

% LM=uint8(LM);
%  imtool(LM);
L_11=abs(L_1-LM);
L_22=abs(L_2-LM);
L_33=abs(L_3-LM);
L_44=abs(L_4-LM);
L_55=abs(L_5-LM);

L=uint8(L_11+L_22+L_33+L_44+L_55);
%imtool(L);
% L_11=uint8(L_11);
% L_22=uint8(L_22);
% L_33=uint8(L_33);
% L_44=uint8(L_44);
% L_55=uint8(L_55);

 for i=1:480
     L(i,320)=255;
     L(i,321)=255;
%     L_11(i,320)=255;
%     L_22(i,320)=255;
%     L_33(i,320)=255;
%     L_44(i,320)=255;
%     L_55(i,320)=255;
%     L_11(i,321)=255;
%     L_22(i,321)=255;
%     L_33(i,321)=255;
%     L_44(i,321)=255;
%     L_55(i,321)=255;
 end
for j=1:640
    L(240,j)=255;
    L(241,j)=255;
end

%imtool(L);
% imtool(L_11);
% imtool(L_22);
% imtool(L_33);
% imtool(L_44);
% imtool(L_55);


R_1=rgb2gray(R_1);
R_2=rgb2gray(R_2);
R_3=rgb2gray(R_3);
R_4=rgb2gray(R_4);
R_5=rgb2gray(R_5);

%imtool(R_1);
% imtool(R_2);
% imtool(R_3);
% imtool(R_4);
% imtool(R_5);

R_1=double(R_1);
R_2=double(R_2);
R_3=double(R_3);
R_4=double(R_4);
R_5=double(R_5);

RM=zeros(480,640);

for i=1:480
    for j=1:640
        RM(i,j)=(R_1(i,j)+R_2(i,j)+R_3(i,j)+R_4(i,j)+R_5(i,j))/5;
    end
end

R_11=abs(R_1-RM);
R_22=abs(R_2-RM);
R_33=abs(R_3-RM);
R_44=abs(R_4-RM);
R_55=abs(R_5-RM);

R=uint8(R_11+R_22+R_33+R_44+R_55);
%imtool(R);
% R_11=uint8(R_11);
% R_22=uint8(R_22);
% R_33=uint8(R_33);
% R_44=uint8(R_44);
% R_55=uint8(R_55);


for i=1:480
    R(i,320)=255;
    R(i,321)=255;
%     R_11(i,320)=255;
%     R_22(i,320)=255;
%     R_33(i,320)=255;
%     R_44(i,320)=255;
%     R_55(i,320)=255;
%     R_11(i,321)=255;
%     R_22(i,321)=255;
%     R_33(i,321)=255;
%     R_44(i,321)=255;
%     R_55(i,321)=255;
end
 for j=1:640
    R(240,j)=255;
    R(241,j)=255;
end
%imtool(R);
% imtool(R_11);
% imtool(R_22);
% imtool(R_33);
% imtool(R_44);
% imtool(R_55);

LR=R+L;
%imtool(LR);
LR=double(LR);


LO=LR(1:239,322:640);
LO=double(LO);
RO=LR(1:239,1:319);
RO=double(RO);
%imtool(LO);
%imtool(RO);
GL=zeros(239,1);
for i=1:239
  GL(i,1)=OSTU(LO(i,1:319));
end
GR=zeros(239,1);
for i=1:239
  GR(i,1)=OSTU(RO(i,1:319));
end

GD=zeros(239,11);
for i=1:239
  for j=322:638
     if LR(i,j)>GL(i,1)&&LR(i,j+1)>GL(i,1)&&LR(i,j+2)>GL(i,1)
        GD(i,1)=i;
        GD(i,2)=j;
     else
        continue
     end
     break
  end
end

for i=1:239
 for j=1:319
    if LR(i,320-j)>GR(i,1)&&LR(i,319-j)>GR(i,1)&&LR(i,318-j)>GR(i,1)
       GD(i,3)=i;
       GD(i,4)=320-j;
     break
    else
      continue
    end
 end
end

%depth
HMPP=5.7/640;
VMPP=4.29/480;
f=6.3;
for i=1:239
     GD(i,8)= 700*f/((GD(i,2)-320.5)*HMPP+(320.5-GD(i,4))*HMPP);
end

%L hori
for i=1:239
    GD(i,5)=((GD(i,2)-320.5)*HMPP/f)*GD(i,8)-350;
end

%R hori
for i=1:239
    GD(i,6)=((GD(i,4)-320.5)*HMPP/f)*GD(i,8)+350;
end

%L&R verti
 for i=1:239
     GD(i,7)=((240.5-GD(i,1))*VMPP/f)*GD(i,8)+1100;
 end
 
 

%  
% figure (1) 
% plot(GD(1:239,5),'r');
% hold on
% plot(GD(1:239,7),'b');
% hold on
% plot(GD(1:239,8),'k');
% 
% figure(2)
% plot(GD(1:239,5),'r');
% 
% figure(3)
% plot(GD(1:239,7),'b');
% 
% figure(4)
% plot(GD(1:239,8),'k');
% 
% figure(5)
% for i=1:239
%   scatter3(GD(i,8),GD(i,5),GD(i,7));
%   hold on
% end
% xlabel('Z');
% ylabel('Y');
% zlabel('X');
% 
% figure (6) 
% plot(GD(75:160,5),'r');
% hold on
% plot(GD(75:160,7),'b');
% hold on
% plot(GD(75:160,8),'k');
% 
% figure(7)
% scatter(1:86,GD(75:160,5),'r');
% 
% figure(8)
% scatter(1:86,GD(75:160,7),'b');
% 
% figure(9)
% scatter(1:86,GD(75:160,8),'k');
% 
figure(10)
for i=75:160
  scatter3(GD(i,8),GD(i,5),GD(i,7),'k','filled');
  hold on
end
xlabel('Z');
ylabel('Y');
zlabel('X');

GD=GD(75:160,1:11);
     
% hori v
T=(4/25)/(160-75);
for i=1:85
    GD(i,9)=(GD(i+1,5)-GD(i,5))/T;
    GD(i,10)=(GD(i+1,7)-GD(i,7))/T;
    GD(i,11)=(GD(i+1,8)-GD(i,8))/T;
end

G=zeros(100,9);
n=1;
for i=1:86
    if GD(i,9)~=0
        G(n,1)=GD(i,9);
    else
        continue
    end
    n=n+1;
end

n=1;
for i=1:86
    if GD(i,11)~=0
        G(n,3)=GD(i,11);
    else
        continue
    end
    n=n+1;
end

n=1;
for i=1:86
    if GD(i,10)~=0
        G(n,2)=GD(i,10);
    else
        continue
    end
    n=n+1;
end

H=median(G(1:49,1));
D=median(G(1:47,3));
HM=mean(G(1:49,1));
DM=mean(G(1:47,3));
HS=std(G(1:49,1));
DS=std(G(1:47,3));

HR=HM+HS;
HL=HM-HS;
DR=DM+DS;
DL=DM-DS;

HH=0;
k=0;
for i=1:49
    if G(i,1)<HR && G(i,1)>HL
    HH=HH+G(i,1);
    k=k+1;
    else
        continue
    end
end
HH=HH/k;
    
DD=0;
p=0;
for i=1:47
    if G(i,3)<DR && G(i,3)>DL
    DD=DD+G(i,3);
    p=p+1;
    else
        continue
    end
end
DD=DD/p;

HHH=(H+HH-537.92)/3;
DDD=(D+DD+12961.7)/3;

for i=1:49
    G(i,4)=H;
    G(i,5)=HH;
    G(i,6)=HHH;
end
for i=1:47
    G(i,7)=D;
    G(i,8)=DD;
    G(i,9)=DDD;
end
% 
%     
%        
%

% figure(1)
% scatter(1:49,G(1:49,1),'k');
% hold on
% plot(G(1:49,4),'r');
% hold on
% plot(G(1:49,5),'b');
% hold on
% plot(G(1:49,6),'g');
% 
% figure(2)
% scatter(1:47,G(1:47,3),'k');
% hold on
% plot(G(1:47,7),'r');
% hold on
% plot(G(1:47,8),'b');
% hold on
% plot(G(1:47,9),'g');


% hold on
% plot(G(1:47,7),'r');
% hold on
% plot(G(1:47,8),'b');
% hold on
% plot(G(1:47,9),'g');



% GP=zeros(1,85);
% for i=1:85
%     GP(1,i)=G(i,2);
% end
% 
% P1=polyfit(1:85,GP(1,1:85),1);
% PF = polyval(P1,1:85); 
% 
figure(3)
scatter(1:85,G(1:85,2),'k');
% hold on
% plot(1:85,PF);
% 
% GP=zeros(1,43);
% w=1;
% for i=43:85
%     GP(1,w)=G(w,2);
%     w=w+1;
% end
% 
% P2=polyfit(1:43,GP(1,1:43),1);
% PF = polyval(P2,1:43); 
% 
% figure(4)
% scatter(1:43,GP(1,1:43),'k');
% hold on
% plot(1:43,PF);

GV=zeros(85,4);
for i=1:85
    GV(i,1)=GD(i,10)-9810*(86-i)*T;
end

V=median(GV(1:85,1));
VM=mean(GV(1:85,1));
VS=std(GV(1:85,1));
VR=VM+VS;
VL=VM-VS;

VV=0;
k=0;
for i=1:85
    if GV(i,1)<VR && GV(i,1)>VL
    VV=VV+GV(i,1);
    k=k+1;
    else
        continue
    end
end
VV=VV/k;

VVV=(VV+V)/2;

for i=1:85
    GV(i,2)=V;
    GV(i,3)=VV;
    GV(i,4)=VVV;
end

% figure(4)
% scatter(1:85,GV(1:85,1),'k');
% hold on
% plot(GV(1:85,2),'r');
% hold on
% plot(GV(1:85,3),'b');
% hold on
% plot(GV(1:85,4),'g');

L=zeros(10,3);
L(1,1)=(GD(82,6)+GD(83,6)+GD(84,6)+GD(85,6)+GD(86,6))/5;
L(1,2)=(GD(82,7)+GD(83,7)+GD(84,7)+GD(85,7)+GD(86,7))/5;
L(1,3)=(GD(82,8)+GD(83,8)+GD(84,8)+GD(85,8)+GD(86,8))/5;




syms x
TT=solve(abs(VVV)*x+0.5*9810*x^2-L(1,2)==0,x);
TT=double(TT);

TTT=TT(2,1)/10;
for i=1:10
    L(i+1,1)=L(i,1)+HHH*TTT;
    L(i+1,2)=L(1,2)+VVV*(TTT*i)-0.5*9810*(TTT*i)^2;
    L(i+1,3)=L(i,3)+DDD*TTT;
end

HP=L(1,1)+TT(2,1)*HHH;
VP=0;
VVP=VVV-TT(2,1)*9810;
DP=L(1,3)+TT(2,1)*DDD;

FV=sqrt(HHH^2+DDD^2+VVP^2);

% figure(10)
% for i=1:11
%   scatter3(L(i,3),L(i,1),L(i,2),'k','filled');
%   hold on
% end
% xlabel('Z');
% ylabel('Y');
% zlabel('X');


