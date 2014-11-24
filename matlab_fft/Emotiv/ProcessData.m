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
%file = 'camilo-exp2_I-13.11.14.18.38.48.CSV';
%file2 = 'camilo-exp2-13.11.14.17.56.50.CSV';
%file = 'Omar_L-Exp4-16.11.14.23.26.51.CSV';
%file = 'Thuong-pilotII-08.11.14.17.32.40.CSV'; 
file = 'Thuong-pilot-08.11.14.16.57.39.CSV';
%file = 'Omar_pilot_runII.CSV';
%file = 'camilo_blink.CSV';
%file = 'camilo_eeg_action_partII.csv';
%file = 'camilo_blink.csv';
text = ['Loading:' file '...'];
disp(text);
[data, trials] = SegmentData(file,WindowLength, EpochLength);
[data2, trials2] = SegmentData(file,WindowLength, EpochLength);
trials = trials; %+ trials2;
SegData = data;%cat(3,data,data2);%%
clear data2 text trials2

disp('SUCCESS: Data Loaded and Segmented');

%%
%Plot Time Series of Raw data
% disp('Plotting Time Series')
% PlotRaw(file, WindowLength, EpochLength);
% disp('SUCCESS: Time Series Plotted!');

%%
%Get the FFT and power of data 
disp('FFTing the data...')
[trialChannelPower,UpperStandardDeviation,LowerStandardDeviation, trialPower]= FFTPower(SegData, WindowLength, EpochLength);
disp('SUCCESS: Data FFTED!');

%%
%Plot Specific Frequency
disp('Plotting Data');
PlotFreq(trialChannelPower,UpperStandardDeviation,LowerStandardDeviation, freq, WindowLength, EpochLength,file);

%PlotLocation