%%                                             %%
% Read_Emotiv_Raw_Data.m : Takes csv output     %
%    file from Emotiv EPOC testbench software   %
%    and formats it into a 65x14xMarker array.  %
%    It also makes sure that the data in this   %
%    array is within .25 seconds of the action  %
%    potential to make .5 second epochs.        %
%                                               %
% Author: Omar Shanta                           %
%                                               %
% Modification History:                         %
% 10/10/14 OS Initial Version                   %
% 10/13/14 CA Read data in another directory    %
%          OS Combine Two Output Files          %
%          COSA STFT Implementation             %
% 10/14/14 OS Finish Segmentation               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%
function[ReturnData] = SegmentData(Emotivfile,WINDOWLENGTH, EPOCHLENGTH)
    %%
    % loading data and setting data capture variables
    % Input requirements: csv data, EPOCHLENGTH

    cd ../Data/Data_Action
    rawdata = importdata(Emotivfile);
    cd ../../Emotiv

    newdata = rawdata.data;
    Fs = 128;
    channels = 14;
    MARKER_CODE = 49;
    epoch_samples = (Fs*EPOCHLENGTH);

    %%
    %When a column is asigned = [], all the array is squeezed left
    %To take out first two columns of useless data
    for i=1:2
        newdata(:,1) = [];
    end
    
    %To take out last 18 columns of useless data
    for i = 15:33
        newdata(:,15) = [];
    end
    
    %%
    %Only considers data within +/- 1.5 seconds of marker
    %Formats in 3D array as specified in description
    %Emotive's output file column #15 has the markers

    markers = find(newdata(:,15) == MARKER_CODE);
    trials = length(markers);
    processdata = zeros(epoch_samples+1, channels, trials); 

    
    %take care for first case if it does not have enough samples
    %it will ignora that trial
    if((markers(1) - (epoch_samples/2) <= 0))
        markers(1) = [];
        trials = trials - 1;
    end 
    
    for current_trial = 1:trials
        center = markers(current_trial);
        lowpoint = center - (epoch_samples/2);
        for epoch_sample = 1:(epoch_samples+1)
            for channel = 1:channels
                processdata(epoch_sample,channel,current_trial) = newdata(lowpoint + epoch_sample-1,channel);
            end
        end
    end
    clear lowpoint center i j epoch epoch_sample;
    %%
    %Segments data from samples x channels x trials to
    % samples x channels x trials x windows with window length 1/6 of
    % EPOCHLENGTH. Eg. trial length of 3s gives window of .5s
    % Input requirements: windowlength
    windows = EPOCHLENGTH/WINDOWLENGTH;
    window_samples = floor(epoch_samples/windows);
    segmented_data = zeros(window_samples, channels, trials, windows);

    for current_trial = 1:trials
        for current_window = 1:windows
            for epoch_sample = 1:floor((epoch_samples+1)/windows)
                for channel = 1:14
                    segmented_data(epoch_sample,channel,current_trial,current_window) = processdata(epoch_sample+((current_window-1)*window_samples),channel,current_trial);
                end
            end
        end
    end
    clear center i j epoch index;    ReturnData = segmented_data;
end