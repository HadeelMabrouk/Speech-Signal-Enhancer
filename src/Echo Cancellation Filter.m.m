%Hadeel Mabrouk
%900163213
%DSP Project | Question 3 - Echo Cancellation

%CODE
clc
clear
close all

[signalRead,sampleRate] = audioread("ILoveDSPecho.wav");
signalRead = signalRead';
[~,signalReadL] = size(signalRead);

%plot autocorrelation
subplot(2,1,1)
z = xcorr(signalRead,signalRead);
[~,len] = size(z);
n1 = [-(len-1)/2:(len-1)/2];
plot(n1, z); title("Input AutoCorrelation");

D = 22050;
alpha = 7396/15190;
b = [1,zeros(1,D),alpha]; % Filter parameters
w = filter(1,b,signalRead);
b1 = [1,zeros(1,2*D),2543/11960]; % Filter parameters
w = filter(1,b1,w);
b2 = [1,zeros(1,44100),384.1/11340]; % Filter parameters
w = filter(1,b2,w);
w = lowpass(w,1200,sampleRate);
[~,outputLength] = size(w); 
outputRate = sampleRate*1.01;
%plot autocorrelation after enhancement
subplot(2,1,2)
z = xcorr(w,w);
[~,len] = size(z);
n1 = [-(len-1)/2:(len-1)/2];
plot(n1, z); title("Output AutoCorrelation");

%frequency plots
%before enhancement
figure
subplot(2,1,1);
f = sampleRate*(0:(signalReadL-1))/signalReadL;
plot(f,real(fft(signalRead)));
title("Echo Input Signal in Frequency Domain");
%after enhancement
subplot(2,1,2);
f = outputRate*(0:(outputLength-1))/outputLength;
plot(f,real(fft(w)));
title("Echo Enhanced Signal in Frequency Domain");

sound(w,outputRate);
audiowrite("EchoOut.wav",w,outputRate);

