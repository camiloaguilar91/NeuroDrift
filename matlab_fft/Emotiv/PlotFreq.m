function PlotFreq(trialChannelPower, freq)
    Fs= 128;     
    N = size(trialChannelPower);                   % number of samples 
    N = N(1);
    epoch_samples = (Fs*3);
    fVec = linspace(0,Fs/2,64);
    tVec = linspace(-1.5, 1.5, 6);

    newVector = [trialChannelPower(freq,1) trialChannelPower(freq,2) trialChannelPower(freq,3) trialChannelPower(freq,4) trialChannelPower(freq,5) trialChannelPower(freq,6)];
    plot(tVec,newVector);
    
end