clc; clear all; close all;

%% load data
x = double(imread('lena.bmp'));
p = 6; % 6-point case, input = 6

figure(1);
imshow(uint8(x))
title('original image')

%% wavedbc6
tic
[x1L , x1H1 , x1H2 , x1H3] = wavedbc6(x , p);
y = uint8([x1L/sqrt(2) x1H1*5; x1H2*5 x1H3*10]);
toc

figure(2);
imshow(y)
title('Daubechies wavelet transform')

%% iwavedbc6
tic
x_result = iwavedbc6(x1L , x1H1 , x1H2 , x1H3 , p);
toc

figure(3);
imshow(uint8(x_result))
title('inverse Daubechies wavelet transform')