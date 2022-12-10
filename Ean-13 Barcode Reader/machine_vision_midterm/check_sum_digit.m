% [B,map]=imread('test3.bmp');
% BC = locate_barcode(B);
% BCM = mean_filter(BC);
% BCS = image_sharpening(BCM);
% BC = sharpening_level(BCS,BC);
% SR = barcode_binary_processing(BC);
% [LR,RLE] = read_barcode(SR);
% [LHG,LH,~,FST,FSTC,CG,RH,~,RHG,RLE] = barcode_decoding(LR,RLE);

function[ANS,FST,FSTC,LHG,LHC,CG,RHC,RHG,Error,RHE,LHE]=check_sum_digit(LHG,LH,FST,FSTC,CG,RH,RHG)
% # of errors
LHE=zeros(1,1);
k=1;
for i=1:6
    if LH(i,3)==1
        LHE(k,1)=i;
        k=k+1;
    else
        continue
    end
end

k=1;
RHE=zeros(1,1);
for i=1:6
    if RH(i,2)==1
        RHE(k,1)=i;
        k=k+1;
    else
        continue
    end
end

Q=0;
W=0;
S1=size(LHE);
I1=S1(1,1);
for i=1:I1
    if LHE(i,1)~=0
        Q=Q+1;
    else
        Q=0;
    end
end

S2=size(RHE);
I2=S2(1,1);
for i=1:I2
    if RHE(i,1)~=0
        W=W+1;
    else
        W=0;
    end
end
Error=Q+W;

%fix the FST error
if FST==10 && Q==1
   for i=0:1
    LH(LHE,2)=i;
    if LH(1,2)==1 && LH(2,2)==1 && LH(3,2)==1 && LH(4,2)==1 && LH(5,2)==1 && LH(6,2)==1
    FST=0;
    FSTC=char('first digit is good');
    break
  elseif LH(1,2)==1 && LH(2,2)==1 && LH(3,2)==0 && LH(4,2)==1 && LH(5,2)==0 && LH(6,2)==0
    FST=1;
    FSTC=char('first digit is good');
    break
  elseif LH(1,2)==1 && LH(2,2)==1 && LH(3,2)==0 && LH(4,2)==0 && LH(5,2)==1 && LH(6,2)==0
    FST=2;
    FSTC=char('first digit is good');
    break
  elseif LH(1,2)==1 && LH(2,2)==1 && LH(3,2)==0 && LH(4,2)==0 && LH(5,2)==0 && LH(6,2)==1
    FST=3;
    FSTC=char('first digit is good');
    break
  elseif LH(1,2)==1 && LH(2,2)==0 && LH(3,2)==1 && LH(4,2)==1 && LH(5,2)==0 && LH(6,2)==0
    FST=4;
    FSTC=char('first digit is good');
    break
  elseif LH(1,2)==1 && LH(2,2)==0 && LH(3,2)==0 && LH(4,2)==1 && LH(5,2)==1 && LH(6,2)==0
    FST=5;
    FSTC=char('first digit is good');
    break
  elseif LH(1,2)==1 && LH(2,2)==0 && LH(3,2)==0 && LH(4,2)==0 && LH(5,2)==1 && LH(6,2)==1
    FST=6;
    FSTC=char('first digit is good');
    break
  elseif LH(1,2)==1 && LH(2,2)==0 && LH(3,2)==1 && LH(4,2)==0 && LH(5,2)==1 && LH(6,2)==0
    FST=7;
    FSTC=char('first digit is good');
    break
  elseif LH(1,2)==1 && LH(2,2)==0 && LH(3,2)==1 && LH(4,2)==0 && LH(5,2)==0 && LH(6,2)==1
    FST=8;
    FSTC=char('first digit is good');
    break
  elseif LH(1,2)==1 && LH(2,2)==0 && LH(3,2)==0 && LH(4,2)==1 && LH(5,2)==0 && LH(6,2)==1
    FST=9;
    FSTC=char('first digit is good');
    break
    else
      continue
    end
   end
elseif FST==10 && Q>1
    FSTC=char('first digit is error'); 
else
    FSTC=char('first digit is good');
end



%use the checksum digit rule to fix the error
switch W
    case 1
      CSD=RH(6,1)+FST+LH(2,1)+LH(4,1)+LH(6,1)+RH(2,1)+RH(4,1)+3*(LH(1,1)+LH(3,1)+LH(5,1)+RH(1,1)+RH(3,1)+RH(5,1));
      CSD1=10*ceil(CSD/10);
      RH(RHE,1)=CSD1-CSD;
      RHC=char('right hand digits are checked');
      
    case 0
      RHC=char('right hand digits are checked');
      
    otherwise
      RHC=char('right hand digits are wrong'); 
end

switch Q
    case 1
      CSD=RH(6,1)+FST+LH(2,1)+LH(4,1)+LH(6,1)+RH(2,1)+RH(4,1)+3*(LH(1,1)+LH(3,1)+LH(5,1)+RH(1,1)+RH(3,1)+RH(5,1));
      CSD1=10*ceil(CSD/10);
      LH(LHE,1)=CSD1-CSD;
      LHC=char('left hand digits are checked');
      
    case 0
      LHC=char('left hand digits are checked');
      
    otherwise
      LHC=char('left hand digits are wrong'); 
end


    






        




% barcode digits
ANS=[FST LH(1,1) LH(2,1) LH(3,1) LH(4,1) LH(5,1) LH(6,1) RH(1,1) RH(2,1) RH(3,1) RH(4,1) RH(5,1) RH(6,1)];



