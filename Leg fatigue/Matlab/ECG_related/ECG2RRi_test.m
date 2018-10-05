%% ECG --> detect QRS --> get R-R interval
% test \wfdb\rqrs.m function


clear all; close all; clc

%%Initializing mhrv toolbox
mhrv_init [-f/--force]


%% get ECG and RRi data
matFile='\db\mitdb\S22_MVC60_Fatigue1.mat';
rec_name='db/mitdb/S22_MVC60Fatigue1';
TrialName='S22_MVC60Fatigue1';

path=pwd;
load([pwd matFile])


time=Data{1,1};

EMG=Data{1,2}; %EMG, uV
Respiration=Data{1,9}; %Noraxon Desk Receiver.BIO 1 Respiration, uV
ECG=Data{1,10}; %Noraxon Desk Receiver.BIO 1 ECG, uV;

RRi=Data{1,14}; %Noraxon Desk Receiver.BIO 1 R-R Interval, ms


%% use mhrv functions
% [ t, sig, Fs ] = rdsamp( rec_name );
[ qrs, tm, sig, Fs ] = rqrs( rec_name, 'gqconf','\cfg\gqrs.default.conf' ); %R-peak detection in ECG signals

[ rri, trr, plot_data ] = ecgrr( rec_name); % obtain RR interval

[nni,tnn,pd_filtrr]=filtrr(rri,trr); %filter outlier

% filter Biomonitor RRi output
[nni2,tnn2,pd_filtrr2]=filtrr(RRi/1000,time);

% [hrv_fd2, ~, ~,  pd_freq2 ] = hrv_freq(RRi);

%% plot ECG data and RRi data
figure (1)
subplot(2,1,1)
plot(time, ECG)
xlabel('time (s)')
ylabel('ECG (uV)')
xlim([0,250]);

subplot(2,1,2)
plot(tm,sig)
xlabel('time (s)')
ylabel('ECG (uV)')
xlim([0,250]);
hold on
plot(tm(qrs,1),sig(qrs,1),'rx')

figure(2)
plot(tm,sig)
xlabel('time (s)')
ylabel('ECG (uV)')
xlim([0,250]);
hold on
plot(tm(qrs,1),sig(qrs,1),'rx')

plot(trr,rri,'co')

%compare with Biomonitor RRi output
figure (3)
hold on
p(1,1)=plot(time, RRi/1000,'k');
%plot(time, RRi/1000,'rx');
xlabel('time (s)')
ylabel('RRi(s)')


p(1,2)=plot(trr,rri,'bo');
plot(trr,rri,'b')

%filtered 
plot(tnn,nni,'m')
p(1,3)=plot(tnn,nni,'mx');

% plot(tnn2,nni2,'c')
% plot(tnn2,nni2,'co')
xlim([0,250]);

legend(p,{'RRi-Biomonitor','RRi-mhrv-calculated','NNi-mhrv-filtered'})
   
