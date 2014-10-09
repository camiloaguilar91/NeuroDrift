%% loading data and setting data capture variables 
close all; clear;
data = load('camilo_rest_data_2_old.mat');   % loads a sample set of data
data = data.temp;           
Fs= 128;                        % sampling Frequency
tElapsed= 1/Fs;                 % time elapsed per sample 
N = length(data);               % number of samples 
t_vector = (0:N-1)*tElapsed;           % time vector (in sec)
fVec = linspace(0,Fs/2,N/2+1);  % frequency vector resolved by fft
channels = 14;

%% test signal (for debugging only)
% f1 = 60; f2 = 30; f3 = 15;      %sample sine wav freqs
% data = sin(2*pi*t*f1)+sin(2*pi*t*f2)+sin(2*pi*t*f3);
% data = data';                   %transposing to original convention

%% creating and implementing low pass filter to exclude 60 Hz noise
n = 200;             % filter order
% f = [0   .02 .06 .76 .80  1];  % frequency (as fraction of Nyquist freq, i.e. 1=Nyquist f)
% a = [.1   0   1   1   0  0]; % band pass filter (5-50Hz)
f = [0 .76 .80  1]; % frequency (as fraction of Nyquist freq, i.e. 1=Nyquist f)
a = [1   1   0  0]; % low pass filter (50 Hz)
b = firls(n,f,a);   % creating filter

% Computing filtered result 
dataFilt = NaN(size(data));
for channel = 1:size(data,2)
    dataFilt(:,channel) = filtfilt(b,a,data(:,channel));
end    

%% plotting frequency response of the filter (if wanted)
%[h,w] = freqz(b,1,n,2);
% Plot filter kernel + frequency response of actual and ideal filter
%figure; subplot(1,2,1); plot(b); title('Filter kernel')
%subplot(1,2,2); plot(w,abs(h))
%hold on; plot(f,a,'r.-'); title('Frequency response of filter')
%legend('Actual', 'Ideal')


%% Segmenting the data
epoch_lenght = 0.25;                %0.25 s
totaltime = floor(tElapsed*N);
num_divisions = totaltime/epoch_lenght;    %total time/epoch_lenght
epoch_samples = floor(epoch_lenght/tElapsed);
segdata = zeros( epoch_samples , channels, num_divisions); 
minifVec = linspace(0, Fs/2, epoch_samples/2 + 1);

for div = 1:num_divisions
        segdata(:,:,div) = detrend(data(1+((div-1)*epoch_samples):div*epoch_samples,:));
end

figure
for div = 1:num_divisions
   temp_fft = abs((fft(segdata(:,:,div))));
   temp_fft = temp_fft(1:length(minifVec));
   plot(minifVec, temp_fft);
   hold on;
end

% %% computing signal mean over relevant data channels 
% sigMean = squeeze(mean(data,2));        % averaging over channels        
% %sigMeanFilt = dataFilt(:,1);
% sigMean = detrend(sigMean,'linear');    % detrending (dc offset/drift)
% sigMeanFilt = squeeze(mean(dataFilt,2));
% sigMeanFilt = detrend(sigMeanFilt,'linear');
% 
% %% taking fft of filtered and non-filtered signals for spectral analysis
% % NFFT = nextPow2(N);
% % fftMean= fft(signal,NFFT)/N;
% 
% fftMean = abs(fft(sigMean,length(sigMean)));
% fftMean = fftMean(1:length(fVec),:);
% fftMeanFilt = abs(fft(sigMeanFilt,length(sigMeanFilt)));
% fftMeanFilt = fftMeanFilt(1:length(fVec),1);
% 
% %% Plotting test signal and filtered results
% %figure; 
% %inds = 5000:(5000+Fs*30);    %data indices for time selection
% %subplot(211); plot(t(inds),data(inds,:));     title('Raw Data');
% %subplot(212); plot(t(inds),dataFilt(inds,:)); title('Low Pass'); 
% 
% %% Plotting power spectrum
% figure;
% subplot(211); plot(fVec,fftMean);     title('Raw power spectrum');
% subplot(212); plot(fVec,fftMeanFilt); title('Filtered spectrum');
% figure
% semilogy(fVec,fftMeanFilt); title('Filtered spectrum');
% grid on
% 
% figure
% plot(fVec,fftMeanFilt); title('Filtered spectrum');
% grid on
