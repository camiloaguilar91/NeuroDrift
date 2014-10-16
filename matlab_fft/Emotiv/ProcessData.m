%%Main Script
clear all;
WindowLength = 0.5;
EpochLength = 3;


data1 = SegmentData('camilo_eeg_action_partI.csv', WindowLength, EpochLength);
data2 = SegmentData('camilo_eeg_action_partII.csv', WindowLength, EpochLength);
SegData  = cat(3,data1,data2);

Power = FFTPower(SegData, WindowLength, EpochLength);
%Function to Low Pass Filter


clear data1 data2;

