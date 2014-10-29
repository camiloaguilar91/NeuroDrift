
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
        
    tVec = linspace(-EPOCHLENGTH/2, EPOCHLENGTH/2, NumWindows);
    fVec = linspace(0,Fs/2, NumFFTPoints);
    
    PlotVector = zeros(NumWindows);
    if (FreqBinsLength ==1)
        for window = 1:NumWindows
         PlotVector(window) = trialChannelPower(freq, window);          
        end    
    elseif( FreqBinsLength > 1)
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
    imagesc(tVec,fVec, trialChannelPower); colorbar
    set(gca,'YDir','normal')
    text = 'Power vs Freq vs Time';
    title(text); 
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');

    figure
    surf(tVec,fVec, trialChannelPower);
end