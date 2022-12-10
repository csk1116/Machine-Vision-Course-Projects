%reduce noice or pepper by using a median filter with 3x3 mask

%[B,map]=imread('test6.bmp');
%BC = locate_barcode(B);
%BCM = mean_filter(BC);
function BCA= median_filter(DB)
%imtool(BC);
DB=double(DB);
S=size(DB);
I=S(1,1);
J=S(1,2);
BCA=zeros(I,J);
for j=2:J-1
    for i=2:I-1
        %M=BC(i-1:i+1,j-1:j+1);
        M=[DB(i-1,j-1) DB(i-1,j) DB(i-1,j+1) DB(i,j-1) DB(i,j) DB(i,j+1) DB(i+1,j-1) DB(i+1,j) DB(i+1,j+1)];
        BCA(i,j)=median(M);
    end
end
BCA=uint8(BCA);
%imtool(DB);
%imtool(BCM);