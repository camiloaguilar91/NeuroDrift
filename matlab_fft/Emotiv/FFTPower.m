%%                                             %%
% FFTPower.m :                                  %
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


function[trialChannelPower] = FFTPower(SegmentedData, WINDOWLENGTH, EPOCHLENGTH)
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
    trialChannelPower = squeeze(mean(trialPower,2));
end