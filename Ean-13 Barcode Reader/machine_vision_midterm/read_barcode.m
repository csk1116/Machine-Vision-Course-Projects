% [B,map]=imread('test17.bmp');
% BC = locate_barcode(B);
% BCM = mean_filter(BC);
% BCS = image_sharpening(BCM);
% BC = sharpening_level(BCS,BC);
% SR = barcode_binary_processing(BC);

function [LR,RLE] = read_barcode(SR)
SRG=SR(1:1,:);
SRD=SR(2:2,:);
    
% figure (3);
% subplot(2,1,1);
% plot(SRG,'b');
% hold on
% plot(150*SRD,'r');
% title('Barcode grayvalue versus 1&0');
% xlabel('columns');
% ylabel('intensity');
% hold off

S=size(SRG);
J=S(1,2);
SRG=int16(SRG);
SRGD=zeros(1,J);
SRGD(1,1)=0;
for j=1:J-1
    SRGD(1,j+1)=SRG(1,j+1)-SRG(1,j);
end

for j=1:J
    if abs(SRGD(1,j))<10
        SRGD(1,j)=0;
    else
        continue
    end
end


% subplot(2,1,2);
% plot(SRGD,'b');
% hold on
% title('The derivative of barcode grayvalue & its peaks');
% xlabel('columns');
% ylabel('intensity');







%find the peak of SRGD
P=zeros(1,3);
m=0;
for j=2:J-1
    if SRGD(1,j-1)<=SRGD(1,j) && SRGD(1,j)>=SRGD(1,j+1) && SRGD(1,j)~=0
        m=m+1;
        P(m,1)=j;
        P(m,2)=0;
    elseif SRGD(1,j-1)>=SRGD(1,j) && SRGD(1,j)<=SRGD(1,j+1) && SRGD(1,j)~=0
        m=m+1;
        P(m,1)=j;
        P(m,2)=1;
    else
        continue
    end
end


% plot(P(:,1),0,'*r');
% hold off



%run length encoding
S=size(SRD);
J=S(1,2);

k=0;
m=1;
RLE=zeros(1,4);
for j=1:J-1
    if SRD(1,j)==1
        k=k+1;
        RLE(m,3)=1;
        RLE(m,1)=j-k+1;
        RLE(m,2)=k;
    else
        k=k+1;
        RLE(m,3)=0;
        RLE(m,1)=j-k+1;
        RLE(m,2)=k;
    end
    if SRD(1,j)~=SRD(1,j+1)
        k=0;
        m=m+1;
    else
        continue
    end
   
end
 
% find the left hand guard and right hand guard
S=size(RLE);
I=S(1,1);

%left hand guard
%find the left 101

T=0;
C=0;
for i=1:I
    if RLE(i,3)==0
       T=T+RLE(i,2);
       C=C+1;
    else
        continue
    end
end
T=T/C;

L=0;
for i=2:I-2
    if RLE(i,3)==1 && RLE(i+1,3)==0 && RLE(i+2,3)==1 
        if abs((RLE(i,2)+RLE(i+1,2)-2*RLE(i+2,2))/3)<=1.34 && abs((RLE(i,2)-2*RLE(i+1,2)+RLE(i+2,2))/3)<=1.34 && abs(((-2)*RLE(i,2)+RLE(i+1,2)+RLE(i+2,2))/3)<=1.34 && RLE(i-1,2)>=RLE(i+1,2) && RLE(i+3,2)<3*T && RLE(i+5,2)<3*T
            L=RLE(i,1);
            break
        else
            continue
        end
     else
        continue
    end
end

%right hand guard
%find the right 101
            
R=0;
for i=2:I-2
    if RLE(I-i+1,3)==1 && RLE(I-i,3)==0 && RLE(I-1-i,3)==1 
        if abs((RLE(I-i+1,2)+RLE(I-i,2)-2*RLE(I-1-i,2))/3)<=1.34 && abs((RLE(I-i+1,2)-2*RLE(I-i,2)+RLE(I-1-i,2))/3)<=1.34 && abs(((-2)*RLE(I-i+1,2)+RLE(I-i,2)+RLE(I-1-i,2))/3)<=1.34 && RLE(I-i+2,2)>=RLE(I-i,2) && RLE(I-2-i,2)<3*T && RLE(I-4-i,2)<3*T
            R=RLE(I-i+1,1);
            break
        else
            continue
        end
     else
        continue
    end
end
LR=[L R];
% 
% A=size(P);
% I=A(1,1);
% for i=1:I-1
%     P(i,3)=P(i+1,1)-P(i,1);
% end
% 
% 
% Q=0;
% W=0;
% for i=1:I
%     if P(i,1)==L
%        Q=i;
%     elseif P(i,1)==R
%        W=i;
%     else
%         continue
%     end
% end
% 
% P=P(Q:W,:);

%     

            
        



     






    