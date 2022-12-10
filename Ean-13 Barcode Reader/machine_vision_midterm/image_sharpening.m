% sharpen the image using a Laplacian operator

function BCS = image_sharpening(BCM)
  %[B,map]=imread('test1.bmp');
   %BC = locate_barcode(B);
   %BCM = mean_filter(BC);
%BCMD = median_filter(BC);
%figure(4);
%imtool(BC);
% title('original image');
% figure(5);
% imshow(BCM);
% title('mean filter');
%BCM=int16(BCM);
S=size(BCM);
I=S(1,1);
J=S(1,2);
E=-1;
E1=-4;
E2=20;
BCS=zeros(I,J);
for j=2:J-1
    for i=2:I-1
        BCS(i,j)=E*(BCM(i-1,j-1)+BCM(i-1,j+1)+BCM(i+1,j-1)+BCM(i+1,j+1))+E1*(BCM(i-1,j)+BCM(i,j-1)+BCM(i,j+1)+BCM(i+1,j))+E2*BCM(i,j);      
    end
end

% for i=1:I
%     for j=1:J
%         if BCS(i,j)<0
%             BCS(i,j)=0;
%         else
%             continue
%         end
%     end
% end
% C=0;
% T=0;
% for i=1+2:I-2
%     for j=1+2:J-2
%         if BCS(i,j)~=0
%          T=T+BCS(i,j);
%          C=C+1;
%         else
%             continue
%         end
%     end
% end
% T=T/C;




%BCS=uint8(BCS);
% BCS=BCS-min(min(BCS));
% BCS=double(BCS);

% 
% figure(4);
% imtool(BC);
%  imtool(BCS);
%  BC=BC+BCS;
%  imtool(BC);
% title('laplacian operator');
