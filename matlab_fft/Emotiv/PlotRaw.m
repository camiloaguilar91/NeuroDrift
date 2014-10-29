%%                                             %%
% PlotRaw.m : Plot a portion of the time series %
%   for the raw data                            %                                  %
%                                               %
% Author: Omar Shanta                           %
%                                               %
% Modification History:                         %
% 10/28/14 OS Initial Version                   %
% 10/28/14 CA Improve effiency and plot all     %
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
%     figure
%     for i=1:channels 
%         subplot(channels,1,i);plot(newdata(1:6000,i),'positio);
%         xlabel('time (s)');
%         text = ['Channel ' i];
%         ylabel(text);
%     end
        sampleSpan = 1:2000;
        for i = 1:6
        subplot(7,1,i);plot(newdata(sampleSpan,i));
        xlabel('sample');
        ylabel(strcat('Channel ',num2str(i)));
        end
        subplot(7,1,7);plot(newdata(sampleSpan,15));
        %axis([0 3500 0 60]);
        xlabel('sample');
        ylabel('Markers');
end