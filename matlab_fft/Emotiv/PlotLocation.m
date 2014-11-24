
load channels_loc;
EPOCHLENGTH = el;
WINDOWLENGTH = wl;

Fs = 128;
[NumFFTPoints, NWindows] = size(trialChannelPower);
FreqBinsLength = (Fs/2)/NumFFTPoints;
tVec = linspace(-EPOCHLENGTH/2, EPOCHLENGTH/2, NWindows+1);

SUFIX_NAME = file(1:(find(file == '.')-1));
output_image = [SUFIX_NAME '_' num2str(EPOCHLENGTH) 's_epoch_0p' num2str(WINDOWLENGTH*100) '_location'];

if (FreqBinsLength ==1)
    fIndex = freq;
%In case window length is different than 1s, so frequency bins need to be
%scaled (1 separation = scale* Hz)
elseif( FreqBinsLength > 1)
    fIndex= floor(freq/FreqBinsLength)+1;
end

maximun_value = max(max((trialPower(fIndex,:,:))));   
    
for t=1:NWindows
    
    subplot(4,5,t)
    tmpVector = (trialPower(fIndex,:,t));
    tmpVector = tmpVector ./ maximun_value;
    eegplot(tmpVector',ch,0,1,'cubic',[]);
    title(['freq = ' num2str(freq) ', t = ' num2str(tVec(t)) ' s ']);
    
    
end


cd(['Plots/' SUFIX_NAME]);
    cd([num2str(EPOCHLENGTH) 's_epoch_0p' num2str(WINDOWLENGTH*100) '_window']);
    
dir = exist('space_power');
    if(~dir)
        mkdir('space_power');
    end
    cd space_power ;
    print('-dpng','-r72', [output_image '.png']);
    
    %close all
    cd ../../../../

clear Fs dir tmpVector maximun_value  fIndex SUFIX_NAME output_image EPOCHLENGTH WINDOWLENGTH NumFFTPoints NWindows FreqBinsLength tVec 
 