
% [B,map]=imread('test17.bmp');
% BC = locate_barcode(B);
% BCM = mean_filter(BC);
% BCS = image_sharpening(BCM);
% BC = sharpening_level(BCS,BC);
% SR = barcode_binary_processing(BC);
% [LR,RLE] = read_barcode(SR);

function [LHG,LH,LHC,FST,FSTC,CG,RH,RHC,RHG,RLE,PPD] = barcode_decoding(LR,RLE) 
% calculate how many pixels represent a digit
R=LR(1,2);
L=LR(1,1);
PPD=(R-L+1)/95;
S=size(RLE);
I=S(1,1);
for i=1:I
    RLE(i,4)=round(RLE(i,2)/PPD);
end

LI=0;
RI=0;
for i=1:I
    if RLE(i,1)==L
        LI=i;
    elseif RLE(i,1)==R
        RI=i;
        break
    else
        continue
    end
end

%compensate some errors
for i=LI:RI
    if RLE(i,4)<1
        RLE(i,4)=1;
    elseif RLE(i,4)>4
        RLE(i,4)=4;
    else
        continue
    end
end

%from left-hand guard to right-hand guard (should be 59 rows)
RLE=RLE(LI:RI,:);

%decoding

LH=zeros(6,3);
RH=zeros(6,2);

%left hand guard
if RLE(1,4)==1 && RLE(2,4)==1 && RLE(3,4)==1
     LHG=char('left-hand guard is checked!');
else
     LHG=char('error!');
end

%LH(7 digits)
C1=1;
for i=4:4:24
    if RLE(i,4)==3 && RLE(i+1,4)==2 && RLE(i+2,4)==1 && RLE(i+3,4)==1
        LH(C1,1)=0;
        LH(C1,2)=1;
    elseif  RLE(i,4)==2 && RLE(i+1,4)==2 && RLE(i+2,4)==2 && RLE(i+3,4)==1
        LH(C1,1)=1;
        LH(C1,2)=1;
    elseif  RLE(i,4)==2 && RLE(i+1,4)==1 && RLE(i+2,4)==2 && RLE(i+3,4)==2
        LH(C1,1)=2;
        LH(C1,2)=1;
    elseif  RLE(i,4)==1 && RLE(i+1,4)==4 && RLE(i+2,4)==1 && RLE(i+3,4)==1
        LH(C1,1)=3;
        LH(C1,2)=1;
    elseif  RLE(i,4)==1 && RLE(i+1,4)==1 && RLE(i+2,4)==3 && RLE(i+3,4)==2
        LH(C1,1)=4;
        LH(C1,2)=1;
    elseif  RLE(i,4)==1 && RLE(i+1,4)==2 && RLE(i+2,4)==3 && RLE(i+3,4)==1
        LH(C1,1)=5;
        LH(C1,2)=1;
    elseif  RLE(i,4)==1 && RLE(i+1,4)==1 && RLE(i+2,4)==1 && RLE(i+3,4)==4
        LH(C1,1)=6;
        LH(C1,2)=1;
    elseif  RLE(i,4)==1 && RLE(i+1,4)==3 && RLE(i+2,4)==1 && RLE(i+3,4)==2
        LH(C1,1)=7;
        LH(C1,2)=1;
    elseif  RLE(i,4)==1 && RLE(i+1,4)==2 && RLE(i+2,4)==1 && RLE(i+3,4)==3
        LH(C1,1)=8;
        LH(C1,2)=1;
    elseif  RLE(i,4)==3 && RLE(i+1,4)==1 && RLE(i+2,4)==1 && RLE(i+3,4)==2
        LH(C1,1)=9;
        LH(C1,2)=1;
    elseif RLE(i,4)==1 && RLE(i+1,4)==1 && RLE(i+2,4)==2 && RLE(i+3,4)==3
        LH(C1,1)=0;
    elseif  RLE(i,4)==1 && RLE(i+1,4)==2 && RLE(i+2,4)==2 && RLE(i+3,4)==2
        LH(C1,1)=1;
    elseif  RLE(i,4)==2 && RLE(i+1,4)==2 && RLE(i+2,4)==1 && RLE(i+3,4)==2
        LH(C1,1)=2;
    elseif  RLE(i,4)==1 && RLE(i+1,4)==1 && RLE(i+2,4)==4 && RLE(i+3,4)==1
        LH(C1,1)=3;
    elseif  RLE(i,4)==2 && RLE(i+1,4)==3 && RLE(i+2,4)==1 && RLE(i+3,4)==1
        LH(C1,1)=4;
    elseif  RLE(i,4)==1 && RLE(i+1,4)==3 && RLE(i+2,4)==2 && RLE(i+3,4)==1
        LH(C1,1)=5;
    elseif  RLE(i,4)==4 && RLE(i+1,4)==1 && RLE(i+2,4)==1 && RLE(i+3,4)==1
        LH(C1,1)=6;
    elseif  RLE(i,4)==2 && RLE(i+1,4)==1 && RLE(i+2,4)==3 && RLE(i+3,4)==1
        LH(C1,1)=7;
    elseif  RLE(i,4)==3 && RLE(i+1,4)==1 && RLE(i+2,4)==2 && RLE(i+3,4)==1
        LH(C1,1)=8;
    elseif  RLE(i,4)==2 && RLE(i+1,4)==1 && RLE(i+2,4)==1 && RLE(i+3,4)==3
        LH(C1,1)=9;
    else
        LH(C1,3)=1;
        LH(C1,2)=10;
    end
    C1=C1+1;
end

for i=1:6
    if LH(i,3)==1
        LHC=char('go to check sum digit');
        break
    else
        LHC=char('left hand digits are checked');
        continue
    end
end

%1st digit

for i=1:6
    if LH(i,3)==1
        FSTC=char('go to check sum digit');
        break
    else
        FSTC=char('first digit is good');
        continue
    end
end

if LH(1,2)==1 && LH(2,2)==1 && LH(3,2)==1 && LH(4,2)==1 && LH(5,2)==1 && LH(6,2)==1
    FST=0;
elseif LH(1,2)==1 && LH(2,2)==1 && LH(3,2)==0 && LH(4,2)==1 && LH(5,2)==0 && LH(6,2)==0
    FST=1;
elseif LH(1,2)==1 && LH(2,2)==1 && LH(3,2)==0 && LH(4,2)==0 && LH(5,2)==1 && LH(6,2)==0
    FST=2;
elseif LH(1,2)==1 && LH(2,2)==1 && LH(3,2)==0 && LH(4,2)==0 && LH(5,2)==0 && LH(6,2)==1
    FST=3;
elseif LH(1,2)==1 && LH(2,2)==0 && LH(3,2)==1 && LH(4,2)==1 && LH(5,2)==0 && LH(6,2)==0
    FST=4;    
elseif LH(1,2)==1 && LH(2,2)==0 && LH(3,2)==0 && LH(4,2)==1 && LH(5,2)==1 && LH(6,2)==0
    FST=5;    
elseif LH(1,2)==1 && LH(2,2)==0 && LH(3,2)==0 && LH(4,2)==0 && LH(5,2)==1 && LH(6,2)==1
    FST=6;
elseif LH(1,2)==1 && LH(2,2)==0 && LH(3,2)==1 && LH(4,2)==0 && LH(5,2)==1 && LH(6,2)==0
    FST=7;
elseif LH(1,2)==1 && LH(2,2)==0 && LH(3,2)==1 && LH(4,2)==0 && LH(5,2)==0 && LH(6,2)==1
    FST=8;
elseif LH(1,2)==1 && LH(2,2)==0 && LH(3,2)==0 && LH(4,2)==1 && LH(5,2)==0 && LH(6,2)==1
    FST=9;    
else
    FSTC=char('go to check sum digit');
    FST=10;
end
    
    
%center guard
if RLE(28,4)==1 && RLE(29,4)==1 && RLE(30,4)==1 && RLE(31,4)==1 && RLE(32,4)==1 
     CG=char('center guard is checked!');
else
     CG=char('error!');
end

%RH(7 digits)
C2=1;
for i=33:4:53
    if RLE(i,4)==3 && RLE(i+1,4)==2 && RLE(i+2,4)==1 && RLE(i+3,4)==1
        RH(C2,1)=0;
    elseif  RLE(i,4)==2 && RLE(i+1,4)==2 && RLE(i+2,4)==2 && RLE(i+3,4)==1
        RH(C2,1)=1;
    elseif  RLE(i,4)==2 && RLE(i+1,4)==1 && RLE(i+2,4)==2 && RLE(i+3,4)==2
        RH(C2,1)=2;
    elseif  RLE(i,4)==1 && RLE(i+1,4)==4 && RLE(i+2,4)==1 && RLE(i+3,4)==1
        RH(C2,1)=3;
    elseif  RLE(i,4)==1 && RLE(i+1,4)==1 && RLE(i+2,4)==3 && RLE(i+3,4)==2
        RH(C2,1)=4;     
    elseif  RLE(i,4)==1 && RLE(i+1,4)==2 && RLE(i+2,4)==3 && RLE(i+3,4)==1
        RH(C2,1)=5;     
    elseif  RLE(i,4)==1 && RLE(i+1,4)==1 && RLE(i+2,4)==1 && RLE(i+3,4)==4
        RH(C2,1)=6;
    elseif  RLE(i,4)==1 && RLE(i+1,4)==3 && RLE(i+2,4)==1 && RLE(i+3,4)==2
        RH(C2,1)=7;
    elseif  RLE(i,4)==1 && RLE(i+1,4)==2 && RLE(i+2,4)==1 && RLE(i+3,4)==3
        RH(C2,1)=8;
    elseif  RLE(i,4)==3 && RLE(i+1,4)==1 && RLE(i+2,4)==1 && RLE(i+3,4)==2
        RH(C2,1)=9;    
    else
        RH(C2,2)=1;
    end
    C2=C2+1;
end

for i=1:6
    if RH(i,2)==1
        RHC=char('go to check sum digit');
        break
    else
        RHC=char('right hand digits are checked');
        continue
    end
end

%right hand guard
if RLE(57,4)==1 && RLE(58,4)==1 && RLE(59,4)==1
     RHG=char('right-hand guard is checked!');
else
     RHG=char('error!');
end





        
        




    