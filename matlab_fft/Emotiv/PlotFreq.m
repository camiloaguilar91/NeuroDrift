
%%                                             %%
% PlotFreq.m : Plot the Power vs. Time,         %
%   Power vs. time vs. frequency,               %
%   and Power vs. time vs. frequency 3D Plot    %
%                                               %
% Author: Camilo Aguilar                        %
%                                               %
% Modification History:                         %
% 10/19/14 CA Initial Version                   % 
% 10/28/14 OS Adjusted scale on frequency plots %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function PlotFreq(trialChannelPower,UpperStandardDeviation,LowerStandardDeviation, freq, WINDOWLENGTH,EPOCHLENGTH)
    Fs = 128;
    NumWindows = EPOCHLENGTH/WINDOWLENGTH;      
    [NumFFTPoints, NWindows] = size(trialChannelPower);
    assert(NWindows == NumWindows, 'Resulting Frequency Vector does not have expected number of Windos')
    FreqBinsLength = (Fs/2)/NumFFTPoints;
    %Omar_pilot_run_II_5s_epoch_0p25s_window_11Hz_PvT
    output_image = ['Thuong_pilotII_%' num2str(EPOCHLENGTH) 's_epoch_0p' num2str(WINDOWLENGTH*100) '_'  num2str(freq) '_Hz_.png'];

    
    tVec = linspace(-EPOCHLENGTH/2, EPOCHLENGTH/2, NumWindows);
    fVec = linspace(0,Fs/2, NumFFTPoints);
    
    %This comment is to remind Omar why we have these two if statements and
    %for lops
    %They are meant to plot only a specific frequency across time
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
    
    baseline = mean(PlotVector(1: NumWindows/2-1));
    PlotVector = (PlotVector - baseline)./baseline * 100;
    figure
    plot(tVec,PlotVector); 
    %hold on 
    %plot(tVec,PlotUpperStandardDeviation,'Color',[1 0 0]); 
    %plot(tVec,PlotLowerStandardDeviation,'Color',[1 0 0]);
    %hold off
    text = ['Power vs Time: ', num2str(freq) ,'Hz'];
    title(text); 
    xlabel('Time (s)');
    ylabel('Power |FFT(W)|');

    %Save single freq vs time image to a png image
    print('-dpng','-r72', output_image);
    
    figure
    imagesc(tVec,fVec, trialChannelPower); colorbar
    set(gca,'YDir','normal')
    text = 'Power vs Freq vs Time';
    title(text); 
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');

    %figure
    %surf(tVec,fVec, trialChannelPower);
end