%%                                             %%
% FFTPower.m : Calculate the FFT and Power for  %
%   Segmented Data and average across trials    %
%   while choosing a specific channel for       %
%   plotting.                                   %
%                                               %
% Author: Omar Shanta                           %
%                                               %
% Modification History:                         %
% 10/10/14 OS Initial Version                   %
% 10/13/14 CA Read data in another directory    %
%          OS Combine Two Output Files          %
%          COSA STFT Implementation             %
% 10/14/14 OS Finish Segmentation               %
% 10/15/14 OS Finish FFT, Power Calculations    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function[trialChannelPower,UpperStandardDeviation,LowerStandardDeviation, ...
    trialPower,UpperStandardDeviationChannel,LowerStandardDeviationChannel]...
    = FFTPower(SegmentedData, WINDOWLENGTH, EPOCHLENGTH)
    %%
    %FFT on each window to change to frequency domain
    %INPUT:  SegmentedData[Nsamples(per window), Nchannels, Ntrials, Nwindows] 
    %OUTPUT: trialChannelPower[N_f_buckets(per window), Nwindows]
    
    channels = size(SegmentedData,2);
    trials = size(SegmentedData,3);
    windows = size(SegmentedData,4);
    count = 0;
    countp = 1;
    Fs = 128;
    epoch_samples = (Fs*EPOCHLENGTH);

    window_samples = floor(epoch_samples/windows);
    f_buckets = window_samples;  %number of frequency buckets = number of samples per window
    totalOperations = trials*windows* channels;
    
    fft_data = zeros(f_buckets, channels, trials, windows);
    
    for currentTrial = 1:trials
        for currentWindow = 1:windows
                for currrentChannel = 1:channels
                    %For Displaying %Done
                    if ((count/totalOperations * 100) >= countp)    
                        text = [num2str(countp), '% Complete.'];
                        disp(text);
                        countp = countp + 1;
                    end
                    
                    SegmentedData(:,currrentChannel,currentTrial,currentWindow) = detrend(SegmentedData(:,currrentChannel,currentTrial,currentWindow));
%                    SegmentedData(:,currrentChannel,currentTrial,currentWindow) = detrend(SegmentedData(:,currrentChannel,currentTrial,currentWindow), 'constant');
                    fft_data(:,currrentChannel,currentTrial,currentWindow) = fft(SegmentedData(:,currrentChannel,currentTrial,currentWindow));
                    count = count + 1;
                    
                end
        end
    end
   
    %%
    %Take power of signal
    %Input: f_buckets x Nchannels x Ntrials x Nwindows
    %Ouput: p_buckets x Nwindows
    Power = abs(fft_data);                %taking magnitude of complex (power)  
    trialPower = squeeze(mean(Power,3));
    trialStandardDeviation = squeeze(std(Power,0,3));
    %trialChannelPower = squeeze(mean(trialPower,2));
    trialChannelPower = trialPower(:,6,:);
    trialChannelStandardDeviation = squeeze(mean(trialStandardDeviation,2)); 
    %trialChannelPower = squeeze(trialPower(:,4,:));
    %standard_deviation = std(trialPower,0,2);
    %mean_channels = mean(trialPower,2);
    
    %Standard Deviation for Separate Channels
    trialPower = trialPower(1:size(trialPower,1)/2,:,:);
    trialStandardDeviation = trialStandardDeviation(1:size(trialStandardDeviation,1)/2,:,:);
    for k = 1:size(trialPower,2)
        for i = 1:size(trialPower,1)
            for j = 1:size(trialPower,3)
                UpperStandardDeviationChannel(i,k,j) = trialPower(i,k,j) + trialStandardDeviation(i,k,j);
                LowerStandardDeviationChannel(i,k,j) = trialPower(i,k,j) - trialStandardDeviation(i,k,j);
            end 
        end
    end
    
    %Standard Deviation for average across channels
    trialChannelPower = trialChannelPower(1:size(trialChannelPower,1)/2,:);
    trialChannelStandardDeviation = trialChannelStandardDeviation(1:size(trialChannelStandardDeviation,1)/2,:);
    for i = 1:size(trialChannelPower,1)
        for j = 1:size(trialChannelPower,2)
            UpperStandardDeviation(i,j) = trialChannelPower(i,j) + trialChannelStandardDeviation(i,j);
            LowerStandardDeviation(i,j) = trialChannelPower(i,j) - trialChannelStandardDeviation(i,j);
        end 
    end
end