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

    %Emotivfile = 'camilo_eeg_action_partI.csv';
    cd ../Data/Data_Action
    rawdata = importdata(Emotivfile);
    cd ../../Emotiv

    newdata = rawdata.data;
    count = 0;
    Fs = 128;
    channels = 14;
    MARKER_CODE = 49;
    epoch_samples = (Fs*EPOCHLENGTH);

    %%
    %To take out useless data from Emotiv output
    for i=1:2
        newdata(:,i-count) = [];
        count = count + 1;
    end
    count = 0;
    for i = 15:33
        newdata(:,i-count) = [];
        count = count + 1;
    end

    clear count;
    %%
    %Only considers data within +/- 1.5 seconds of marker
    %Formats in 3D array as specified in description
    %Emotive's output file column #15 has the markers

    markers = find(newdata(:,15) == 49);
    trials = length(markers);
    processdata = zeros(epoch_samples+1, channels, trials); 
    for i = 1:trials
        center = markers(i);
        lowpoint = center - (epoch_samples/2);  
        for epoch = 1:(epoch_samples+1)
            for j = 1:14
                processdata(epoch,j,i) = newdata(lowpoint+epoch-1,j);
            end
        end
    end
    clear lowpoint center i j epoch;
    %%
    %Segments data from samples x channels x trials to
    % samples x channels x trials x windows with window length 1/6 of
    % EPOCHLENGTH. Eg. trial length of 3s gives window of .5s
    % Input requirements: windowlength
    windows = EPOCHLENGTH/WINDOWLENGTH;
    window_samples = floor(epoch_samples/windows);
    segmented_data = zeros(window_samples, channels, trials, windows);

    for i = 1:trials
        for index = 1:windows
            for epoch = 1:floor((epoch_samples+1)/windows)
                for j = 1:14
                    segmented_data(epoch,j,i,index) = processdata(epoch+(index-1)*window_samples,j,i);
                end
            end
        end
    end
    clear center i j epoch index;    ReturnData = segmented_data;
end