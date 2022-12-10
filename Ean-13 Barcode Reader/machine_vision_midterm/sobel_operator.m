
close all;
clear;
clc;
B = image_browser();

S=size(B);
I=S(1,1);
J=S(1,2);

BY=zeros(I,J);
for j=2:J-1
    for i=2:I-1
        BY(i,j)=B(i+1,j-1)+2*B(i+1,j)+B(i+1,j+1)-B(i-1,j-1)-2*B(i-1,j)-B(i-1,j+1);    
    end
end

BX=zeros(I,J);
for j=2:J-1
    for i=2:I-1
        BX(i,j)=B(i-1,j+1)+2*B(i,j+1)+B(i+1,j+1)-B(i-1,j-1)-2*B(i,j-1)-B(i+1,j-1);    
    end
end


BS=BY+BX;
figure(1);
imshow(BS);
title('Sobel operator');

[H,theta,rho] = hough(BS);
peaks = houghpeaks(H,2);
