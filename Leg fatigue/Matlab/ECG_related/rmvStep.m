function points=rmvStep(stepData)

%% #### Remove step value
% for "step" data (data with same-value points), remove the points with same
% value and only keep the different-value points

% stepData: RR interval data output from biomonitor (points with steps/some same value
% points)

% points= points with differet values (the points with same values are
% removed)

% #####

% %% example
% %load mat file
% clear all; clc; close all;
% 
% path=pwd;
% load([pwd '/db/mitdb/S22_MVC60_Fatigue2.mat']);
% 
% time=Data{1,1};
% ECG=Data{1,10}; %Noraxon Desk Receiver.BIO 1 ECG, uV
% RRi=Data{1,14}/1000;  %Noraxon Desk Receiver.BIO 1 R-R Interval, ms; unit=s now
% stepData=RRi;

%% 
% ### Step 1: find the index where the next number is different than the
% previous one 
Diff=stepData(2:end,1)-stepData(1:end-1,1);
dI=find(abs(Diff)>0);

% ### Step 2: among the selected index from the step 1, find  the indice are
% not next to each other (there are interpolated values on the
% vertical line of the step, so their indice are next to each other)
diffInd=dI(2:end,1)-dI(1:end-1,1);
stepI0=find(diffInd>1);
selectedInd=stepI0+1;
stepInd=dI(selectedInd,1);

% ### Step 3: add the first point and last point from the original stepData
totalInd=[1;stepInd;length(stepData)];
points=RRi(totalInd,1);  %points with differet values (the points with same values are removed

% %% plot
% Xi=1:1:length(stepData);
% figure(11)
% plot(Xi,stepData)
% hold on
% plot(Xi(totalInd),RRi_diff,'rx')
