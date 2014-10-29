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
%clear;
close all;
%WindowLength = 1;
%EpochLength = 5;
%freq = 4;
WindowLength = wl;
EpochLength = el;
%file = 'Omar_pilot_runII.CSV';
%file = 'camilo_blink.CSV';
file = 'camilo_eeg_action_partII.csv';
disp('Loading Data...');
data = SegmentData(file,WindowLength, EpochLength);
SegData = data;%cat(3,data1,data2);
clear data2

disp('SUCCES: Data Loaded and Segmented');

%%
%Plot Time Series of Raw data
% disp('Plotting Time Series')
% PlotRaw(file, WindowLength, EpochLength);
% disp('SUCCESS: Time Series Plotted!');

%%
%Get the FFT and power of data 
disp('FFTing the data...')
trialChannelPower = FFTPower(SegData, WindowLength, EpochLength);
disp('SUCCESS: Data FFTED!');

%%
%Plot Specific Frequency
disp('Plotting Data');
PlotFreq(trialChannelPower, freq, WindowLength, EpochLength);
