%find angle using hough transform

close all;
clear;
clc;
[B,map]=imread('test17.bmp');
BB= rgb2gray(B);
BW = edge(BB,'canny');
imshow(BW);
[H,theta,rho] = hough(BW);
peaks = houghpeaks(H,2);



