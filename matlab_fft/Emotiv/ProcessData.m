%%                                             %%
% ProcessData.m :                               %
%                                               %
% Author: Camilo Aguilar                        %
%                                               %
% Modification History:                         %
% 10/19/14 CA Initial Version                   %
% 10/28/14 OS Included Time Series Function Call%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Main Script-Variables Definition
%%
%Load and Segment the Data
clear;
close all;
WindowLength = 0.25;
EpochLength = 3;
freq = 4;
disp('Loading Data...');
data2 = SegmentData('camilo_eeg_action_partII.csv', WindowLength, EpochLength);
%data2 = SegmentData('camilo_rest.CSV', WindowLength, EpochLength);
SegData = data2;%cat(3,data1,data2);
clear data2

disp('SUCCES: Data Loaded and Segmented');

%%
%Plot Time Series of Raw data
disp('Plotting Time Series')
PlotRaw('camilo_eeg_action_partII.csv', WindowLength, EpochLength);
disp('SUCCESS: Time Series Plotted!');

%%
%Get the FFT and power of data 
disp('FFTing the data...')
trialChannelPower = FFTPower(SegData, WindowLength, EpochLength);
disp('SUCCESS: Data FFTED!');

%%
%Plot Specific Frequency
disp('Plotting Data');
PlotFreq(trialChannelPower, freq, WindowLength, EpochLength);
