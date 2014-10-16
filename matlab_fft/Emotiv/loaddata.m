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

%function [] = loaddata();

%%
% loading data and setting data capture variables
% Input requirements: csv data, epochlength

close all; clear;
cd ../Data/Data_Action
rawdata = importdata('camilo_eeg_action_partI.csv');
cd ../../Emotiv

newdata = rawdata.data;
count = 0;
Fs = 128;
channels = 14;
epochlength = 3;

epoch_samples = (Fs*epochlength);

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
markers = find(newdata(:,15) == 49);
trials = length(markers);
processdata = zeros(epoch_samples+1, channels, trials); 
for i = 1:trials
    center = markers(i);
    lowpoint = center - (epoch_samples/2);
    highpoint = center + (epoch_samples/2);
    for epoch = 1:(epoch_samples+1)
        for j = 1:14
            processdata(epoch,j,i) = newdata(lowpoint+epoch-1,j);
        end
    end
end
clear highpoint lowpoint center i j epoch;

%%
%Segments data from samples x channels x trials to
% samples x channels x trials x windows with window length 1/6 of
% epochlength. Eg. trial length of 3s gives window of .5s
% Input requirements: windowlength
windowlength = .5;
windows = epochlength/windowlength;
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

%%
%Same thing except for a different file
% loading data and setting data capture variables
cd ../Data/Data_Action
rawdata1 = importdata('camilo_eeg_action_partII.csv');
cd ../../Emotiv

newdata1 = rawdata1.data;
count = 0;

%To take out useless data from Emotiv output
for i=1:2
    newdata1(:,i-count) = [];
    count = count + 1;
end
count = 0;
for i = 15:33
    newdata1(:,i-count) = [];
    count = count + 1;
end

clear count;

%Only considers data within +/- .25 seconds of marker
%Formats in 3D array as specified in description
markers1 = find(newdata1(:,15) == 49);
processdata1 = zeros(65 , channels, length(markers1)); 
for i = 1:length(markers1)
    center = markers1(i);
    lowpoint = center - 32;
    highpoint = center + 32;
    for epoch1 = 1:65
        for j = 1:14
            processdata1(epoch1,j,i) = newdata1(lowpoint+epoch1-1,j);
        end
    end
end
clear highpoint lowpoint center i j;

%%
%Combine the two files
%output_file = cat(3,processdata,processdata1);

%%
%STFT Implementation
