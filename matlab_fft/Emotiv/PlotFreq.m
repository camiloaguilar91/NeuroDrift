
%%                                             %%
% PlotFreq.m : Plot the Power vs. Time,         %
%   Power vs. time vs. frequency,               %
%   and Power vs. time vs. frequency 3D Plot    %
%                                               %
% Author: Camilo Aguilar                        %
% inputs: trialChannelPower                     %
%                                               %
% Modification History:                         %
% 10/19/14 CA Initial Version                   % 
% 10/28/14 OS Adjusted scale on frequency plots %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function PlotFreq(trialChannelPower,UpperStandardDeviation,LowerStandardDeviation, ...
    trialPower, UpperStandardDeviationChannel, LowerStandardDeviationChannel, freq, WINDOWLENGTH,EPOCHLENGTH,file)
    Fs = 128;
    NumWindows = EPOCHLENGTH/WINDOWLENGTH;      
    [NumFFTPoints, NWindows] = size(trialChannelPower);
    assert(NWindows == NumWindows, 'Resulting Frequency Vector does not have expected number of Windos')
    FreqBinsLength = (Fs/2)/NumFFTPoints;
    %Omar_pilot_run_II_5s_epoch_0p25s_window_11Hz_PvT
    SUFIX_NAME = file(1:(find(file == '.')-1));
    output_image = [SUFIX_NAME '_' num2str(EPOCHLENGTH) 's_epoch_0p' num2str(WINDOWLENGTH*100) '_'  num2str(freq) '_Hz_.png'];

    
    tVec = linspace(-EPOCHLENGTH/2, EPOCHLENGTH/2, NumWindows);
    fVec = linspace(0,Fs/2, NumFFTPoints);
    
    %This comment is to remind Omar why we have these two if statements and
    %for lops.They are meant to plot only a specific frequency across time
    %Thank you Omar
    %Omar's voice: Youre welcome
    
    PlotVector = zeros(NumWindows);
    %For the case where frequency bins do not need to be scaled. (Window
    %Length = 1 s ONLY (1 separation = 1 Hz)
    if (FreqBinsLength ==1)
        for window = 1:NumWindows
         PlotVector(window) = trialChannelPower(freq, window);          
         PlotUpperStandardDeviation(window) = UpperStandardDeviation(freq,window);
         PlotLowerStandardDeviation(window) = LowerStandardDeviation(freq,window);
        end
    %In case window length is different than 1s, so frequency bins need to be 
    %scaled (1 separation = scale* Hz)
    elseif( FreqBinsLength > 1)
        fIndex= floor(freq/FreqBinsLength)+1;
        for window = 1:NumWindows
            PlotVector(window) = trialChannelPower(fIndex,window);
            PlotUpperStandardDeviation(window) = UpperStandardDeviation(fIndex,window);
            PlotLowerStandardDeviation(window) = LowerStandardDeviation(fIndex,window);
        end
    end
    
    %%
    %============================================
    %Sam as last section except for multi channel
    %============================================
    PlotVectorChannel = zeros(size(trialPower,2),NumWindows);
    %For the case where frequency bins do not need to be scaled. (Window
    %Length = 1 s ONLY (1 separation = 1 Hz)
    if (FreqBinsLength ==1)
        for channel = 1:size(trialPower,2)
            for window = 1:NumWindows
                PlotVectorChannel(channel,window) = trialPower(freq, channel,window);          
                PlotUpperStandardDeviationChannel(channel,window) = UpperStandardDeviationChannel(freq,channel,window);
                PlotLowerStandardDeviationChannel(channel,window) = LowerStandardDeviationChannel(freq,channel,window);
            end
        end
    %In case window length is different than 1s, so frequency bins need to be 
    %scaled (1 separation = scale* Hz)
    elseif( FreqBinsLength > 1)
        fIndex= floor(freq/FreqBinsLength)+1;
        for channel = 1:size(trialPower,2)
            for window = 1:NumWindows
                PlotVectorChannel(channel,window) = trialPower(fIndex, channel,window);          
                PlotUpperStandardDeviationChannel(channel,window) = UpperStandardDeviationChannel(fIndex,channel,window);
                PlotLowerStandardDeviationChannel(channel,window) = LowerStandardDeviationChannel(fIndex,channel,window);
            end
        end
    end

    
    PlotVector = PlotVector(:,1);

    %PlotUpperStandardDeviation = PlotUpperStandardDeviation(:,1);
    %PlotLowerStandardDeviation = PlotLowerStandardDeviation(:,1);

    %%
    %=============================================
    %Calculate Baseline 
    %============================================= 
    baseline = mean(PlotVector(1: NumWindows/2-1));
    PlotVector = (PlotVector - baseline)./baseline * 100;
    PlotUpperStandardDeviation = (PlotUpperStandardDeviation - baseline)./baseline * 100;
    PlotLowerStandardDeviation = (PlotLowerStandardDeviation - baseline)./baseline * 100;
    
    for channel = 1:size(PlotVectorChannel,1)
        baselineChannel(channel) = mean(PlotVectorChannel(1: NumWindows/2-1,channel));
        PlotVectorChannel(channel,:) = (PlotVectorChannel(channel,:) - baselineChannel(channel))./baselineChannel(channel) * 100;
        PlotUpperStandardDeviationChannel(channel,:) = (PlotUpperStandardDeviationChannel(channel,:) - baselineChannel(channel))./baselineChannel(channel) * 100;
        PlotLowerStandardDeviationChannel(channel,:) = (PlotLowerStandardDeviationChannel(channel,:) - baselineChannel(channel))./baselineChannel(channel) * 100;
    end
    
    %%
    %=============================================
    %Plot
    %=============================================
    
    figure
    plot(tVec,PlotVector); 
    hold on 
    plot(tVec,PlotUpperStandardDeviation,'Color',[1 0 0]); 
    plot(tVec,PlotLowerStandardDeviation,'Color',[1 0 0]);
    hold off
    text = [SUFIX_NAME ': Power vs Time: ', num2str(freq) ,'Hz'];
    title(text); xlabel('Time (s)');ylabel('Power |FFT(W)|');
    axis([min(tVec) max(tVec) -100 100]);
    
    %%
    %==============================================
    %Plot all Channels
    %==============================================
    for channel = 1:size(PlotVectorChannel,1)
        figure(channel)
        plot(tVec,PlotVectorChannel(channel,:)); 
        hold on 
        plot(tVec,PlotUpperStandardDeviationChannel(channel,:),'Color',[1 0 0]); 
        plot(tVec,PlotLowerStandardDeviationChannel(channel,:),'Color',[1 0 0]);
        hold off
        text = [SUFIX_NAME ': Channel ',num2str(channel),' Power vs Time: ', num2str(freq) ,'Hz'];
        title(text); xlabel('Time (s)');ylabel('Power |FFT(W)|');
        %Channel 12
        %axis([min(tVec) max(tVec) -100 10000]);
        %Channel 14
        %axis([min(tVec) max(tVec) -100 5000]);
        %Others
        axis([min(tVec) max(tVec) -100 300]);
    end
    
    %%
    %========================================
    %Save Current Plots in a Directory 
    %========================================
   
%     dir = exist(['Plots/' SUFIX_NAME]);
%     if(~dir)
%         mkdir(['Plots/' SUFIX_NAME]);
%     end
%     cd(['Plots/' SUFIX_NAME]);
%         dir = exist([num2str(EPOCHLENGTH) 's_epoch_0p' num2str(WINDOWLENGTH*100) '_window']);
%         if(~dir)
%             mkdir([num2str(EPOCHLENGTH) 's_epoch_0p' num2str(WINDOWLENGTH*100) '_window']);
%         end
%         cd([num2str(EPOCHLENGTH) 's_epoch_0p' num2str(WINDOWLENGTH*100) '_window']);
%         
%         
%     %Save single freq vs time image to a png image
%     print('-dpng','-r72', output_image);
%     cd ../../../
%     if(freq < 17)
%         PlotFreq(trialChannelPower,UpperStandardDeviation,LowerStandardDeviation, trialPower, UpperStandardDeviationChannel, LowerStandardDeviationChannel, freq+1, WINDOWLENGTH,EPOCHLENGTH,file)
% %         close all
%     end
    %%
    %%======================================================================
    %%Plot 2D IMAGE OF POWER  
    %%======================================================================
    if(freq == 8)
%         cd(['Plots/' SUFIX_NAME])
%         cd([num2str(EPOCHLENGTH) 's_epoch_0p' num2str(WINDOWLENGTH*100) '_window']);
        figure
        imagesc(tVec,fVec, trialChannelPower); colorbar
        set(gca,'YDir','normal')
        text = 'Power vs Freq vs Time';
        title(text); 
        xlabel('Time (s)');
        ylabel('Frequency (Hz)');
        output_image2 = [SUFIX_NAME '_' num2str(EPOCHLENGTH) 's_epoch_0p' num2str(WINDOWLENGTH*100) '.png'];
        print('-dpng','-r72', output_image2);

%          cd ../../../
    end
    %%
    %======================================================================
    %Plot 3D IMAGE OF POWER  
    %======================================================================
    
    %figure
    %surf(tVec,fVec, trialChannelPower);
end