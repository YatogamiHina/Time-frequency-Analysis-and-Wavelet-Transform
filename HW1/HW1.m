clc; clear all; close all;

%%
Fs = 8000;
a = 220; b = 450; c = 300;
T = 1;
t = [1:Fs*T] / Fs;
f = a * t.^2 + b * t + c;

x = cos(2 * pi * f);
sound(x,Fs);
plot(t, x)

audiowrite("HW1.wav" , x, Fs);