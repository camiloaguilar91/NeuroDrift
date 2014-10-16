
function[Power] = FFTPower(SegmentedData, WINDOWLENGTH, EPOCHLENGTH)  
    %%
    %FFT on each window to change to frequency domain
    %samples x channels x trials x windows to
    %f_buckets x channels x trials x windows
    trials = size(SegmentedData);
    trials = trials(3);
    count = 0;
    Fs = 128;
    channels = 14;
    epoch_samples = (Fs*EPOCHLENGTH);
    windows = EPOCHLENGTH/WINDOWLENGTH;
    window_samples = floor(epoch_samples/windows);

    
    f_buckets = window_samples;  %number of frequency buckets = number of samples per window
    fft_data = zeros(f_buckets, channels, trials, windows);
    for i = 1:trials
        for index = 1:windows
            for epoch = 1:f_buckets
                for j = 1:14
                    SegmentedData(:,j,i,index) = detrend(SegmentedData(:,j,i,index));
                    fft_data(epoch,j,i,index) = fft(SegmentedData(epoch,j,i,index));
                end
            end
        end
    end
    clear highpoint lowpoint center i j epoch index;

    %%
    %Take power of signal
    %Input: f_buckets x channels x trials x windows
    %Ouput: p_buckets x channels x trials x windows
    Power = abs(fft_data);                %taking magnitude of complex (power)
    
end