% use gradience_method to seperate the barcode from background

%[B,map]=imread('test2.bmp');
function BC = locate_barcode(B)
figure (1);
subplot(1,2,1);
imshow(B);
title('Input image');
%calculate the gradience use difference method through i&j direction
S=size(B);
I=S(1,1);
J=S(1,2);
DBJ=zeros(I,J);
for i=1:I
    for j=1:J-1
        DBJ(i,j+1)=abs(B(i,j+1)-B(i,j));
        DBJ(i,1)=0;
    end
end

DBI=zeros(I,J);
for j=1:J
    for i=1:I-1
        DBI(i+1,j)=abs(B(i,j)-B(i+1,j));
        DBI(1,j)=0;
    end
end

%define DB to be DBJ-DBI
DB=DBJ-DBI;
% A=ind2rgb(DB,map);
% figure(1);
% subplot(1,2,1);
%  imshow(DB);
%  title('Gradient method');
%  BCA= median_filter(DB);
%  figure(2);
% % subplot(1,2,2);
% BCA=BCA+30;
%  imshow(BCA);
%  title('Median filter');
 
 
 
 
 
 
%filter
F=0;
C=0;
for i=1:I
    for j=1:J
        if DB(i,j)>0
            F=F+DB(i,j);
            C=C+1;
        else
            continue
        end
    end
end

F=F/C;

for i=1:I
    for j=1:J
        if DB(i,j)<F
           DB(i,j)=0;
        else
            continue
        end
    end
end



%imtool(DB);
%imtool(DB);
% S=size(DB);
% I=S(1,1);
% J=S(1,2);
% 
% BCMD=zeros(I,J);
% for j=2:J-1
%     for i=2:I-1
%         %M=BC(i-1:i+1,j-1:j+1);
%         M=[DB(i-1,j-1) DB(i-1,j) DB(i-1,j+1) DB(i,j-1) DB(i,j) DB(i,j+1) DB(i+1,j-1) DB(i+1,j) DB(i+1,j+1)];
%         BCMD(i,j)=median(M);
%     end
% end
% 
% DB=BCMD;



%find the T by Otsu method


%find the frequency of each greyvalue
S=size(DB);
I=S(1,1);
J=S(1,2);

G=zeros(256,1);

for greyvalue=0:255
               n=0;
    for i=1:I
        for j=1:J
            if DB(i,j)==greyvalue
               n=n+1;
            else
                continue
            end
        end
    end
           G(greyvalue+1,1)=n;
end

%calculate the G1(greyvalue & P(greyvalue) & 1-P(greyvalue) & w1 w2 & u1 u2 & v1 v2)
k=0;
for i=1:256
    if G(i,1)>0
       k=k+1;
    else
        continue
    end
end
%p1 & ut
G1=zeros(k,9);
m=0;
ut=0;
for i=1:256
    if G(i,1)~=0
        m=m+1;
        G1(m,1)=i-1;
        G1(m,2)=G(i,1)/(I*J);
        G1(m,3)=(G(i,1)/(I*J))*(i-1);
        ut=ut+G1(m,3);
    else
        continue
    end
end


%w1 w2
G1(1,4)=G1(1,2);
for i=2:k
    G1(i,4)=G1(i,2)+G1(i-1,4);
end

for i=1:k
    G1(i,5)=1-G1(i,4);
end

%u1 u2

u1=0;
for i=1:k
    u1=u1+G1(i,2)*G1(i,1);
    G1(i,6)=u1/G1(i,4);
end

u2=0;
G1(k,7)=0;
for i=1:k-1
    u2=u2+G1(k+1-i,2)*G1(k+1-i,1);
    G1(k-i,7)=u2/G1(k-i,5);
end

% vb^2

for i=1:k
    G1(i,8)=G1(i,4)*(G1(i,6)-ut)^2 + G1(i,5)*(G1(i,7)-ut)^2;
end

% find max vb^2 
V=zeros(k,1);
for i=1:k
    V(i,1)=G1(i,8);
end
[~,II]=max(V);
P=G1(II,1);

%use it as a threshold

for i=1:I
    for j=1:J
        if DB(i,j)<P
            DB(i,j)=0;
        else
            DB(i,j)=1;
        end
    end
end
%imtool(DB);
%reduce the pepper (four-neighbors)
for i=1+1:I-1
    for j=1+1:J-1
        if  DB(i,j-1)==0 && DB(i-1,j)==0 && DB(i,j+1)==0 && DB(i+1,j)==0
            DB(i,j)=0;
        else
            continue
        end
    end
end

%imtool(DB);


% find a barcode range in i direction
% # of j directional white and black change
NX1=zeros(I,1);
for i=1:I
    for j=1:J-1
        if abs(DB(i,j+1)-DB(i,j))~=0
            NX1(i,1)=NX1(i,1)+10;
        else
            continue
        end
    end
end

% total black # in j direction 
NX2=zeros(I,1);
for i=1:I
    for j=1:J-1
        NX2(i,1)=NX2(i,1)+10*DB(i,j);
    end
end

NX=NX2+NX1;

% find out the max value in NX to serve as a filter
NXM=max(max(NX));
N=0;
while (NXM>1)
    NXM=NXM*0.1;
    N=N+1;
end
NXM=10^(N-1)-10^(N-2);

for i=1:I
    if NX(i,1)<NXM
        NX(i,1)=0;
    else
        NX(i,1)=1;
    end
end

% find the i directional barcode range U & D
RGI=zeros(I,2);
C1=0;
k1=1;
for i=1:I
    if NX(i,1)==1
       C1=C1+1;
    else
       RGI(k1,1)=C1;
       C1=0;
       RGI(k1,2)=i;
       k1=k1+1;
    end    
end
        
 RGII=zeros(I,1);
 for i=1:I
     RGII(i,1)=RGI(i,1);
 end
 
 [~,II]=max(RGII);

 D=RGI(II,2)+3;
 U=RGI(II,2)-RGI(II,1)-1-3;

 
 DBX=DB(U:D,:);       
 



% find the j directional bar code range
 NY=zeros(1,J);
 for j=1:J
     for i=1:D-U+1
         NY(1,j)=NY(1,j)+DBX(i,j);
     end
 end
 
% find out the max value in NY to serve as a filter
% NYM=max(max(NY));
% N=0;
% while (NYM>1)
%     NYM=NYM*0.1;
%     N=N+1;
% end
% NYM=10^(N-1);
% 
% for j=1:600
%     if NY(1,j)<NYM
%         NY(1,j)=0;
%     else
%         NY(1,j)=1;
%     end
% end



%find the j dirctional barcode range L & R
RGJ=zeros(1,2);
k=0;
for j=7:J-6
    k=k+1;
    NUM=(1/13)*(NY(1,j-6)+NY(1,j-5)+NY(1,j-4)+NY(1,j-3)+NY(1,j-2)+NY(1,j-1)+NY(1,j)+NY(1,j+1)+NY(1,j+2)+NY(1,j+3)+NY(1,j+4)+NY(1,j+5)+NY(1,j+6));
    RGJ(k,1)=NUM;
    RGJ(k,2)=j-6;
end

S=size(RGJ);
I=S(1,1);
%J=S(1,2);
C=0;
P=0;
for i=1:I
    if RGJ(i,1)~=0
        C=C+1;
        P=P+RGJ(i,1);
    else
        continue
    end
end
P=P/C;
        
% L

for i=1:I
    if RGJ(i,1)>P
        L=RGJ(i,2);
        break
    else
        continue
    end
end
L=L-round((L-1)/8);

% R

for i=1:I
    if RGJ(I-i+1,1)>P
        R=RGJ(I-i+1,2);
        break
    else
        continue
    end
end

R=R+12;
R=R+round((600-R)/8);

% RGJ=zeros(1,600);
% k=1;
% for j=1:600-1
%     if NY(1,j+1)-NY(1,j)==1
%         RGJ(1,k)=j;
%         k=k+1;
%     elseif NY(1,j+1)-NY(1,j)==-1
%         RGJ(1,k)=j+1;
%         k=k+1;
%     else
%         continue
%     end
% end
% 
% R=0;
% for j=1:100
%     if RGJ(1,101-j)>0
%         R=RGJ(1,101-j);
%         break
%     else
%         continue
%     end
% end
% 
% R=R+round((600-R)/5);   
%     
% L=RGJ(1,1);
% L=L-round((L-1)/5);


 BC=B(U:D,L:R);
 subplot(1,2,2);
 imshow(BC);   
 title('Barcode location')
 
    
    





