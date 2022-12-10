%reduce noice by using a mean filter
%3x3 mask with each element=1/9

function BCM = mean_filter(BC)
%BC = locate_barcode(B);
%imtool(BC);
BC=int16(BC);
S=size(BC);
I=S(1,1);
J=S(1,2);
E=1/9;
BCM=zeros(I,J);
for j=2:J-1
    for i=2:I-1
        BCM(i,j)=E*(BC(i-1,j-1)+BC(i-1,j)+BC(i-1,j+1)+BC(i,j-1)+BC(i,j)+BC(i,j+1)+BC(i+1,j-1)+BC(i+1,j)+BC(i+1,j+1));
    end
end
%BCM=uint8(BCM);
%imtool(BCM);