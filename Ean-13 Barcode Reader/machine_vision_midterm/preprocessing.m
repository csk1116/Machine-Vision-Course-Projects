close all;
clear;
clc;
[B,map]=imread('test16.bmp');
imtool(B);
BB= rgb2gray(B);
BW = edge(BB,'canny');
%imshow(BW);
[H,theta,rho] = hough(BW);
peaks = houghpeaks(H,2);
peaks=(peaks(1,2)+peaks(2,2))/2;
R=0;
if peaks>0 && peaks<90
    R=peaks;
elseif peaks>90 && peaks<180
      R=-(180-peaks);
end
  
B = imrotate(BB,R);
imtool(B);

BC = locate_barcode(B);
BCM = mean_filter(BC);
BCS = image_sharpening(BCM);
BC = sharpening_level(BCS,BC);
SR = barcode_binary_processing(BC);
[LR,RLE] = read_barcode(SR);
[LHG,LH,~,FST,FSTC,CG,RH,~,RHG,RLE,PPD] = barcode_decoding(LR,RLE);
[ANS,FST,FSTC,LHG,LHC,CG,RHC,RHG,Error,RHE,LHE]=check_sum_digit(LHG,LH,FST,FSTC,CG,RH,RHG);
fprintf('The Barcode number is showing below\n');
disp('________________________')
fprintf('%d',ANS);


