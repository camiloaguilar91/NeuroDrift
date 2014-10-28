
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


function PlotFreq(trialChannelPower, freq, WINDOWLENGTH,EPOCHLENGTH)
    Fs = 128;
    NumWindows = EPOCHLENGTH/WINDOWLENGTH;      
    [NumFFTPoints, NWindows] = size(trialChannelPower);
    assert(NWindows == NumWindows, 'Resulting Frequency Vector does not have expected number of Windos')
    FreqBinsLength = (Fs/2)/NumFFTPoints;
    
    trialChannelPower = trialChannelPower(1:NumFFTPoints/2,:);
    tVec = linspace(-EPOCHLENGTH/2, EPOCHLENGTH/2, NumWindows);
    fVec = linspace(0,Fs/2, NumFFTPoints/2);
    
    PlotVector = zeros(NumWindows);
    if (FreqBinsLength ==1)
        for window = 1:NumWindows
         PlotVector(window) = trialChannelPower(freq, window);          
         %[trialChannelPower(freq,1) trialChannelPower(freq,2) trialChannelPower(frequency,3)
         %    trialChannelPower(frequency,4) trialChannelPower(frequency,5) trialChannelPower(frequency,6)];
         %subplot(3,2,frequency-7); plot(tVec, PlotVector(frequency-7,:));
         %text = ['Power vs Time: ', num2str(frequency) ,'Hz'];
         %title(text); 
         %xlabel('Time (s)');
         %ylabel('Power |FFT(W)|');
        end
        
    elseif(FreqBinsLength > 1)
        fIndex= floor(freq/FreqBinsLength)+1;
        for window = 1:NumWindows
            PlotVector(window) = trialChannelPower(fIndex,window);
        end
        
    end 
        figure
        plot(tVec,PlotVector);        
        text = ['Power vs Time: ', num2str(freq) ,'Hz'];
        title(text); 
        xlabel('Time (s)');
        ylabel('Power |FFT(W)|');

        figure
        imagesc(fVec, tVec, trialChannelPower'); colorbar
        set(gca,'YDir','normal')
        
        figure
        surf(tVec,fVec, trialChannelPower);
        
%tVec = linspace(-EPOCHLENGTH/2, EPOCHLENGTH/2,NumWindows);

%     
% %     for windows = 1:NumWindows
% %         newVector(windows) = trialChannelPower(8,windows);
% %     end
% 
%     figure
%     plotVector = squeeze(mean(newVector,1));
%     plot(tVec,plotVector);
    %text = ['Power vs Time: 8:13Hz'];
    
end