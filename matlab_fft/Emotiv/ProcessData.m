%%                                             %%
% ProcessData.m :                               %
%                                               %
% Author: Camilo Aguilar                        %
%                                               %
% Modification History:                         %
% 19/10/14 CA Initial Version                   % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Main Script-Variables Definition
%%
%Load and Segment the Data
clear;
WindowLength = 0.5;
EpochLength = 3;
freq = 11;
disp('Loading Data...');
data2 = SegmentData('camilo_eeg_action_partII.csv', WindowLength, EpochLength);
%data2 = SegmentData('camilo_rest.CSV', WindowLength, EpochLength);
SegData = data2;%cat(3,data1,data2);
clear data2

disp('SUCCES: Data Loaded and Segmented');

%%
%Function to Low Pass Filter


%%
%Get the FFT and power of data 
disp('FFTing the data...')
trialChannelPower = FFTPower(SegData, WindowLength, EpochLength);
disp('SUCCESS: Data FFTED!');

%%
%Plot Specific Frequency
disp('Plotting Data');
PlotFreq(trialChannelPower, freq, WindowLength, EpochLength);
