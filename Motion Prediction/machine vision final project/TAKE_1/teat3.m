close all;
clear;
clc;
L_1=imread('take_1_L_2 32.jpg');
R_1=imread('take_1_R_2 32.jpg');
L_1=rgb2gray(L_1);
R_1=rgb2gray(R_1);
disparityMap = disparity(L_1,R_1);
figure 
imshow(disparityMap);
title('Disparity Map');
colormap(gca,jet) 
colorbar
