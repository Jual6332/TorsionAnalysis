%% Group 9 
% ASEN 3112 Exp Lab 1

%% Clear All
clc; clear all; close all;

%% Declare filenames and call calcData functions
filename = 'Group_9_400.csv'; % Data for CTW specimen (subjected to T = 400lbs)
calcDataCTW(filename); % Read in data, Calculate values, and plot for CTW case

filename = 'Group_9_20.csv'; % Data for OTW specimen (subjected to T = 20lbs)
calcDataOTW(filename); % Read in data, calculate values, and plot for OTW case
