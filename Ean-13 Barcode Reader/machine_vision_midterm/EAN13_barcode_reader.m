close all;
clear;
clc;
B = image_browser();
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






