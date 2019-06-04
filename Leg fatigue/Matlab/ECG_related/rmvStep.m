
function [time_sel,points]=rmvStep(time, stepData) % pick the indice of the beginning of the step
%function [time_sel_mid,points_mid]=rmvStep(time, stepData)


%% #### Remove step value
% for "step" data (data with same-value points), remove the points with same
% value and only keep the different-value points

% time: corresponding time
% stepData: RR interval data output from biomonitor (points with steps/some same value
% points)

% time_sel_mid=correspoding time with selected point
% points_mid= points with differet values (the points with same values are
% removed; where the mid-point of the step was selected)


% #####

% %% example
% %load mat file
% clear all; clc; close all;
% 
% path=pwd;
% load([pwd '/db/mitdb/S22_MVC60_Fatigue1.mat']);
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
stepInd=dI(stepI0,1)+1; % the begining of the step
stepInd2=dI(stepI0+1,1);  % the end of the step


% ### Step 3: add the first point and last point from the original stepData
totalInd=[1;stepInd;dI(end,1)+1];  % indice of the beginning of the step
points=stepData(totalInd,1);  %points with differet values (the points with same values are removed
time_sel=time(totalInd,1); 

totalInd2=[dI(1,1);stepInd2;length(stepData)]; % indice of the end of the step
points2=stepData(totalInd2,1);  %points with differet values (the points with same values are removed
time_sel2=time(totalInd2,1); 

totalInd_mid=round(0.5*(totalInd+totalInd2)); % indice of the mid-point of the step
points_mid=stepData(totalInd_mid,1);  %points with differet values (the points with same values are removed
time_sel_mid=time(totalInd_mid,1); 

% %% plot
% 
% figure(11)
% plot(time,stepData)
% hold on
% plot(time,stepData,'co')
% plot(time_sel,points,'rx')
% 
% plot(time_sel2,points2,'mo')
% 
% plot(time_sel_mid,points_mid,'k')
% plot(time_sel_mid,points_mid,'k*')
% 
% % Ind_sel=dI(end,1)+1;
% % Ind_sel2=stepInd2(1,1);
% % plot(time(Ind_sel,1),stepData(Ind_sel,1),'m*')
% % plot(time(Ind_sel2,1),stepData(Ind_sel2,1),'b*')

