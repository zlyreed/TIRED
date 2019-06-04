%% load our ECG data and convert it into Physionet WFDB format file
clear all; clc; close all;

% load S17_Resting_2.mat  % too short
% load S17_MVC60_Fatigue2.mat % 3 mins
% load S21_MVC30_Fatigue1.mat

load S17_MVC60_Fatigue2.mat

TrialName='S17_MVC60Fatigue2_ecg_mV';

time=Data{1,1};
Fs=round(1/(time(2)-time(1)));

sig1=Data{1,2}; %EMG, uV
sig2=Data{1,9}; %Noraxon Desk Receiver.BIO 1 Respiration, uV

sig3=Data{1,10}; %Noraxon Desk Receiver.BIO 1 ECG, uV;

RRi=Data{1,14}; %Noraxon Desk Receiver.BIO 1 R-R Interval, ms

sig=sig3*1000; % change to the required unit (mV)
adu='mV';

info=TrialName;

sg_name={'ECG'};


%% write it to wfdb files (.dat and .hea)
mat2wfdb(sig,TrialName,Fs,[],adu,info,[],sg_name)
