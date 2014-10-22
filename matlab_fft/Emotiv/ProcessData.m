%%                                             %%
% ProcessData.m :                               %
%                                               %
% Author: Camilo Aguilar                        %
%                                               %
% Modification History:                         %
% 19/10/14 CA Initial Version                   % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function[] = ProcessData(WindowLength, EpochLength, freq)
    %Main Script-Variables Definition
    %%
    %Load and Segment the Data
    disp('Loading Data...');
    %data1 = SegmentData('camilo_eeg_action_partI.csv', WindowLength, EpochLength);
    data2 = SegmentData('Omar_pilot_runII.CSV', WindowLength, EpochLength);
    SegData  = data2;%cat(3,data1,data2);
    clear data1 data2;

    disp('SUCCES: Data Loaded and Segmented');

    %%
    %Function to Low Pass Filter


    %%
    %Get the FFT and power of data 
    disp('FFTing the data...');
    trialChannelPower = FFTPower(SegData, WindowLength, EpochLength);
    disp('SUCCESS: Data FFTED!');

    %%
    %Plot Specific Frequency
    disp('Plotting Data');
    PlotFreq(trialChannelPower, freq, WindowLength, EpochLength);
end
