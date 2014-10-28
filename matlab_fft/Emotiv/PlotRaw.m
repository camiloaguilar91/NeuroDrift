%%                                             %%
% PlotRaw.m : Plot a portion of the time series %
%   for the raw data                            %                                  %
%                                               %
% Author: Omar Shanta                           %
%                                               %
% Modification History:                         %
% 10/28/14 OS Initial Version                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function []= PlotRaw(Emotivfile,WINDOWLENGTH, EPOCHLENGTH)
    %%
    %%
    % loading data and setting data capture variables
    % Input requirements: csv data, EPOCHLENGTH

    cd ../Data/Data_Action
    rawdata = importdata(Emotivfile);
    cd ../../Emotiv
    
    %Define Constants
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
    
    %Plots raw data and markers on same graph
    figure
    subplot(3,1,1);plot(newdata(1:6000,1));
    xlabel('time (s)');
    ylabel('Channel 1');
    subplot(3,1,2);plot(newdata(1:6000,2));
    xlabel('time (s)');
    ylabel('Channel 2');
    subplot(3,1,3);plot(newdata(1:6000,15));
    axis([0 3500 0 60]);
    xlabel('time (s)');
    ylabel('Markers');
    
    %%
    %Only considers data within +/- Epoch_L/2 seconds of marker
    %Formats in 3D array as specified in description
    %Emotive's output file column #15 has the markers
    
    markers = find(newdata(:,15) == MARKER_CODE);
    trials = length(markers);

    %take care for first case if it does not have enough samples
    %it will ignor that trial
    if((markers(1) - (epoch_samples/2) <= 0))
        markers(1) = [];
        trials = trials - 1;
    end
    
    %take care for last case if it does not have enough samples
    %it will ignor that trial
    if((markers(trials) + (epoch_samples/2)) > size(newdata,1))
        markers(trials) = [];
        trials = trials - 1;
    end
    
    for current_trial = 1:trials
        center = markers(current_trial);
        lowpoint = center - (epoch_samples/2);
        highpoint = lowpoint + epoch_samples;
        hold on
        plot([lowpoint,lowpoint],[0,60],'Color',[1 0 0]);
        plot([lowpoint + epoch_samples,lowpoint + epoch_samples],[0,60],'Color',[0 1 1]);
    end
    clear lowpoint center i j epoch epoch_sample highpoint;
end