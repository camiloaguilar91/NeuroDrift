%% loading data and setting data capture variables 
close all; clear;
data = load('input_250_hz_1khz_Sample_rate.mat');   % loads a sample set of data
data = data.M;           
Fs= 1000;                        % sampling Frequency
tElapsed= 1/Fs;                 % time elapsed per sample 
N = length(data);               % number of samples 
t = (0:N-1)*tElapsed;           % time vector (in sec)
fVec = linspace(0,Fs/2,N/2+1);  % frequency vector resolved by fft

NFFT = 2^nextpow2(N); % Next power of 2 from length of y
Y = fft(fVec,NFFT)/N;
f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y(1:NFFT/2+1)))
axis([0 500 0 1])
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')